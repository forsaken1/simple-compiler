class String
  def have_dot?
    1 <= count { |char| char == '.' }
  end

  def have_dots?
    1 < count { |char| char == '.' }
  end

  def have_e?
    1 <= count { |char| char == 'e' || char == 'E' }
  end

  def have_many_e?
    1 < count { |char| char == 'e' || char == 'E' }
  end

  def valid_real_number?
    self =~ /^\d+\.?\d*((e|E)\-?\d+)?$/
  end
end