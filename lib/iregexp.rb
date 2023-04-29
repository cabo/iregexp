require_relative "parser/iregexp-util.rb"

class IREGEXP
  @@parser = IREGEXPGRAMMARParser.new
  # include ::IREGEXPType

  class ParseError < ArgumentError; end

  DATA_DIR = Pathname.new(__FILE__) + "../../data/"

  def self.reason(parser, s)
    reason = [parser.failure_reason]
    parser.failure_reason =~ /^(Expected .+) after/m
    reason = ["#{$1.gsub("\n", '<<<NEWLINE>>>')}:"] if $1
    if line = s.lines.to_a[parser.failure_line - 1]
      reason << line
      reason << "#{'~' * (parser.failure_column - 1)}^"
    end
    reason.join("\n").gsub(/[\u0000-\u0009\u000b-\u001f\u007f]/) {|c| "\\u%04x" % c.ord}
  end

  SAFE_FN = /\A[-._a-zA-Z0-9]+\z/

  def self.from_iregexp(s)
    ast = @@parser.parse s
    if !ast
      fail ParseError.new(self.reason(@@parser, s))
    end
    ret = IREGEXP.new(ast)

    ret
  end

  attr_accessor :ast, :tree, :directives
  def initialize(ast_)
    @ast = ast_
    @tree = ast.ast
  end
end
