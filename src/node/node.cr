class Node
  def initialize
    @nil = true
  end

  def initialize(@token : Token)
  end

  def to_s(level = 0, have_link = false)
    "(#{(@token as Token).text})\n"
  end

  def nil?
    @nil
  end

  private def draw_path(level = 0, have_link = false)
    link = have_link ? "|   " : "    "
    i, j = level <= 0 ? 0 : level - 1, level - 1
    (0...j).concat { "    " } +
    (i..j).concat { link } +
    "|\n" +
    (0...j).concat { "    " } +
    (i..j).concat { link } +
    "+---"
  end
end