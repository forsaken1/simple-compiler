class NodeStatement < Node
  def initialize(@expression : Node)
  end

  def to_s
    @expression.to_s
  end
end