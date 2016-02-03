class ScannerException < Exception
  def with_info(@line, @pos)
    self
  end

  def to_s
    "Lexical error: #{message} on line #{@line} in position #{@pos}"
  end
end