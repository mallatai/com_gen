class CommandPart
  attr_accessor :name,
                :msb, :lsb,
                :value

  def initialize(name, msb=-1, lsb=-1, value="")
    @name = name
    @msb, @lsb = msb, lsb
    @value = value
  end

  def to_s
    %Q({"#{@name}":{"msb":"#{@msb}","lsb":"#{@lsb}","value":"#{@value}"}})
  end
  
end

