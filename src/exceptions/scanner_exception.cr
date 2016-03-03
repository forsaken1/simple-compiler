class ScannerException < SimpleCompilerException
  def initialize(message, @line, @pos)
    super message
  end

  def to_s
    "Lexical error: #{message} on line #{@line} in position #{@pos}"
  end
end