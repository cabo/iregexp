require 'treetop'
require_relative './iregexpgrammar'
require_relative '../iregexp'

class Treetop::Runtime::SyntaxNode
  def ast
    fail "undefined_ast #{inspect}"
  end
  def ast1                      # devhack
    "#{inspect[10..20]}--#{text_value[0..15]}"
  end
end
