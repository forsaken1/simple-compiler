class ParserException < SimpleCompilerException
  def initialize(message, @token)
    super message
  end

  def to_s
    "Syntax error: #{message} on line #{@token.line} in position #{@token.pos}"
  end
end