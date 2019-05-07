#!/usr/bin/env ruby

require_relative 'lib/input_file_parser'
require_relative 'lib/command_generator'

def main
  if ARGV.length != 1
    puts "Wrong number of arguments! Exiting..."
    exit(false)
  end
  
  input_file = ARGV[0]
  unless File.exist?(input_file)
    puts "File #{input_file} doesn't exist! Exiting..."
    exit(false)
  end

  puts "Starting..."

  parser = InputFileParser.new(input_file)
  parser.process_file

  cg = CommandGenerator.new(parser.total_length,
                            parser.fields,
                            parser.format_list)
  commands = cg.generate_commands

  open("output.json", "w") { |f| f.puts commands }
  puts commands

  puts "\nDone"
end

main

