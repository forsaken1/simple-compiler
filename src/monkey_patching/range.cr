struct Range(B, E)
  def concat
    result = ""
    each { result += yield }
    result
  end
end