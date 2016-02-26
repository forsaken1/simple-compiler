class NodeStatement < Node
  def initializer(@expression)
  end

  def to_s
    @expression.to_s
  end
end