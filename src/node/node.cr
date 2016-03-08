class Node
  def initialize
    @nil = true
  end

  def initialize(@token : Token)
  end

  def to_s
    "(#{(@token as Token).text})"
  end

  def nil?
    @nil
  end
end