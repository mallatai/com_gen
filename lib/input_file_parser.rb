require 'json'

require_relative 'format'
require_relative 'operand'

class InputFileParser
  attr_accessor :total_length,
                :fields,
                :format_list

  def initialize(input_filename)
    @input_filename = input_filename
  end

  def process_file
    open(@input_filename, "r") { |f|
      @json_hash = JSON.parse(f.read)
    }

    @total_length = @json_hash["length"].to_i

    @fields = make_fields_hash(@json_hash["fields"])

    @format_list = []
    ins_hash = @json_hash["instructions"]
    ins_hash.each do |i|
      @format_list << Format.new(i["format"], i["comment"],
                                 i["insns"],  i["operands"])

    end
  end

  def make_fields_hash(fields_json)
    fields = {}
    fields_json.each do |field_pair|
      name = field_pair.keys[0]
      value = field_pair.values[0]

      operand_fixed = true
      operand_length = -1

      if value.start_with?(">=")
        operand_fixed = false
        operand_length = value.slice!(">=").to_i  
      end
      operand_length = value.to_i

      fields[name] = Operand.new(name,
                                 operand_length,
                                 operand_fixed)
    end

    fields
  end

end

