require "./token"

class Scanner
  def initialize(@file_name)
    @tokens = [] of Token
  end

  def run
    @result = ""
  end
end