class Node
  def initialize(@token)
  end

  def to_s
    "(#{@token.name})"
  end
end