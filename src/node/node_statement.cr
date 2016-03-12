class NodeStatement < Node
  def initialize(@first : Node)
  end

  def initialize(@first : Node, @second : Node)
  end

  def to_s(level = 0, have_link = false)
    @first.to_s level + 1, true
  end
end