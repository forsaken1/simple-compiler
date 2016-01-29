class String
  def dot_count
    count { |char| char == '.' }
  end

  def e_count
    count { |char| char == 'e' || char == 'E' }
  end

  def have_dot?
    1 <= dot_count
  end

  def have_dots?
    1 < dot_count
  end

  def have_e?
    1 <= e_count
  end

  def have_many_e?
    1 < e_count
  end

  def valid_real_number?
    self =~ /^\d*\.?\d*((e|E)\-?\d+)?$/
  end
end