class String
  def have_dot?
    1 <= dot_count
  end

  def have_e?
    1 <= e_count
  end

  def valid_real_number?
    self =~ /^\d*\.?\d*((e|E)\-?\d+)?$/
  end

  def to_readable_format
    self.gsub({ '\n' => "n\n", '\t' => "t", ' ' => "s" })
  end

  private def dot_count
    count { |char| char == '.' }
  end

  private def e_count
    count { |char| char == 'e' || char == 'E' }
  end
end