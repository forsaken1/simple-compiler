class Node
  def initialize(@token : Token)
  end

  def to_s
    "(#{(@token as Token).text})"
  end
end