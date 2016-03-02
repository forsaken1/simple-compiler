class ScannerException < SimpleCompilerException
  def to_s
    "Lexical error: #{message} on line #{@line} in position #{@pos}"
  end
end