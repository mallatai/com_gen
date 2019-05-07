require_relative 'command_part'

class CommandGenerator

  FORMAT_HEADER_LEN = 2
  OPCODE_LEN = 4

  def initialize(total_length, fields, format_list)
    @total_length = total_length
    @fields = fields
    @format_list = format_list
  end

  def generate_commands
    commands = ""

    @format_list.each_with_index do |f, index|
      @current_pos = @total_length - 1
      
      format_header = make_format_header(index)

      f.instructions.each_with_index do |ins, ins_index|
        @current_pos = @total_length - 1 - FORMAT_HEADER_LEN
        
        opcode_part = make_opcode_part(ins_index)

        ins_parts = [format_header, opcode_part]

        last_operand_index = f.operands.length - 1
        f.operands.each_with_index do |op_name, op_index|
          last_operand = (op_index == last_operand_index)
          ins_parts << make_operand_part(op_name, last_operand)
        end
        
        res_part = make_res_part
        ins_parts << res_part unless res_part.nil?

        commands << make_instruction_json(ins, ins_parts) << "\n"
      end
    end

    commands
  end
  
  private

  def make_instruction_json(ins, ins_parts)
    fields_str = ins_parts.map { |i| i.to_s }.join(",\n")

    %Q({"insn":"#{ins}",\n"fields":[#{fields_str}]}\n)
  end

  def make_operand_part(op_name, last_operand = false)
    op = @fields[op_name]
    if op.fixed || !last_operand
      operand_part = CommandPart.new(op.name,
                                     @current_pos,
                                     @current_pos - op.length + 1,
                                     "+") 
      @current_pos -= op.length
    else
      operand_part = CommandPart.new(op.name, @current_pos, 0, "+")
      @current_pos = 0
    end
         
    operand_part
  end

  def make_res_part
    res_part = nil
    if @current_pos > 0
      res_part = CommandPart.new("RES0", @current_pos, 0,
                                 "0".rjust(@current_pos + 1, '0'))
    end

    res_part
  end

  def make_opcode_part(ins_index)
    opcode_part = CommandPart.new("OPCODE",
                                  @current_pos,
                                  @current_pos - OPCODE_LEN + 1,
                                  ins_index.to_s(2).rjust(OPCODE_LEN, '0'))
    @current_pos -= OPCODE_LEN

    opcode_part
  end

  def make_format_header(index)
    format_header = CommandPart.new("F",
                                     @current_pos, @current_pos - FORMAT_HEADER_LEN + 1,
                                     index.to_s(2).rjust(FORMAT_HEADER_LEN, '0'))
    @current_pos -= FORMAT_HEADER_LEN
   
    format_header
  end

end

