require "./token"

class Scanner
  def initialize(@file_name)
    @tokens = [] of Token
  end

  def run
    self
  end

  def to_s
    @tokens.map(&.to_s).join("\n")
  end
end