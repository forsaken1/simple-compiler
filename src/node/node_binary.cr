class NodeBinary < Node
  def initialize(@left : Node, @operation : Token, @right : Node)
  end

  def to_s
    "(#{@operation.text})\n" \
    "|\n" \
    "+---#{@left.to_s}\n" \
    "|\n" \
    "+---#{@right.to_s}\n"
  end
end