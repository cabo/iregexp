require_relative "../iregexp.rb"

class IREGEXP

  # precedence:
  # 0: | alt
  # 1:   seq
  # 2: ... occ dot pos neg - p P

  def prec_check(inner, targetprec, prec, options)
    lp, rp = options[:paren]
    if targetprec > prec
      "#{lp||"("}#{inner}#{rp||")"}"
    else
      inner
    end
  end

  TNR_MAP = {"\t" => "\\t", "\n" => "\\n", "\r" => "\\r"}

  def write_escape(ch, esc, map = TNR_MAP)
    if c1 = map[ch]
      c1
    elsif ch =~ esc
      "\\#{ch}"
    else
      ch
    end
  end

  CC_ESC_CHARS = /\A[-\[\\\]]\z/

  def write_charclass(pn, chars)
    "[#{"^" if pn == "neg"}#{chars.map {|ch|
        case ch
          in String;              write_escape(ch, CC_ESC_CHARS)
          in ["-", l, r];         "#{write_escape(l, CC_ESC_CHARS)}-#{write_escape(r, CC_ESC_CHARS)}"
          in ["p"|"P", _cat];     write_rhs(ch)
        end
     }.join}]"
  end

  SEQ_ESC_CHARS = /\A[()*+.?\[\\\]{|}]\z/ #

  def write_rhs(v, targetprec = 0, options = {})
    #    warn "** v = #{v.inspect}"
    prec, ret =
    case v
    in ["pos" | "neg", *chars]
      [2, write_charclass(v[0], chars)]
    in ["alt", *atoms]
      [0, atoms.map{write_rhs(_1, 1, options)}.join("|")]
    in ["seq", *atoms]
      [1, atoms.map{write_rhs(_1, 1, options)}.join]
    in ["rep", s, e, atom]
      occur = case [s, e]
              in [0, false];       "*"
              in [1, false];       "+"
              in [Integer, false]; "{#{s},}"
              in [0, 1];           "?"
              in [1, 1];           ""
              in [^s, ^s];         "{#{s}}"
              else;                "{#{s},#{e}}"
              end
      [1, "#{write_rhs(atom, 2, options)}#{occur}"]
    in ["dot"]
      [2, options[:dot] || "."]
    in ["p" | "P", cat]
      [2, "\\#{v[0]}{#{cat}}"]
    in String
      [2, write_escape(v, SEQ_ESC_CHARS)]                    # XXX esc!
    end
    prec_check(ret, targetprec, prec, options)
  end

  def to_s
    write_rhs(self.tree)
  end

  def to_pcre
    "\\A#{write_rhs(self.tree, 1, {paren: ["(?:", ")"]})}\\z"
  end

  def to_regexp
    /#{to_pcre}/
  end

  def to_js
    "^#{write_rhs(self.tree, 1, {paren: ["(?:", ")"], dot: "[^\\n\\r]"})}$"
  end

end
