class String
  def have_dot?
    1 == count { |char| char == '.' }
  end

  def have_dots?
    1 < count { |char| char == '.' }
  end
end