class Operand
  attr_accessor :name, :length, :fixed

  def initialize(name, length, fixed = true)
    @name = name
    @length = length
    @fixed = fixed
  end

end

