class Format
  attr_accessor :name, :comment,
                :instructions, :operands  

  def initialize(name, comment, instructions, operands)
    @name = name
    @comment = comment
    @instructions = instructions
    @operands = operands
  end

  def to_s
    "\nFormat: '#{@name}'\n#{@comment}\n#{@instructions}\n#{@operands}"
  end

end

