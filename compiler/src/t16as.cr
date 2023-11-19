class T16as
  VERSION = "0.1.0"
  property opcodes = {} of String => String
  property syscodes = {} of String => String
  property cndcodes = {} of String => String
  property registers = {} of String => String

  def initialize
    # opcodes for atebit computer
    self.syscodes = {
      "NOP" => "00000000",
      "IN"  => "00000001",
      "OUT" => "00000010",
      "CLR" => "00000011",
      "SET" => "00000100",
      "PSH" => "00000101",
      "POP" => "00000110",
      "RET" => "00001110",
      "HLT" => "00001111",
    } of String => String

    self.opcodes = {
      "LD"  => "0001",
      "ST"  => "0010",
      "ADD" => "0011",
      "SUB" => "0100",
      "MLT" => "0101",
      "DIV" => "0110",
      "AND" => "0111",
      "OR"  => "1000",
      "XOR" => "1001",
      "SL"  => "1010",
      "SR"  => "1011",
      "JMP" => "1100",
      "JSR" => "1101",
      "CMP" => "1110",
      "BR"  => "1111",
      "B"   => "1111",
    } of String => String

    self.cndcodes = {
      "EQ"  => "0000",
      "NE"  => "0001",
      "LT"  => "0010",
      "GE"  => "0011",
      "ZS"  => "0000",
      "ZC"  => "0001",
      "NS"  => "0010",
      "NC"  => "0011",
      "CS"  => "0100",
      "CC"  => "0101",
      "OS"  => "0110",
      "OC"  => "0111",
      "IEQ" => "1000",
      "INE" => "1001",
      "ILT" => "1010",
      "IGE" => "1011",
      "IZS" => "1000",
      "IZC" => "1001",
      "INS" => "1010",
      "INC" => "1011",
      "ICS" => "1100",
      "ICC" => "1101",
      "IOS" => "1110",
      "IOC" => "1111",
    } of String => String

    self.registers = {
      "PC"  => "0000",
      "SP"  => "0001",
      "A1"  => "0010",
      "A2"  => "0011",
      "A3"  => "0100",
      "A4"  => "0101",
      "A5"  => "0110",
      "A6"  => "0111",
      "X0"  => "0000",
      "X1"  => "0001",
      "X2"  => "0010",
      "X3"  => "0011",
      "X4"  => "0100",
      "X5"  => "0101",
      "X6"  => "0110",
      "X7"  => "0111",
      "IPC" => "1000",
      "ISP" => "1001",
      "IA1" => "1010",
      "IA2" => "1011",
      "IA3" => "1100",
      "IA4" => "1101",
      "IA5" => "1110",
      "IA6" => "1111",
      "IX0" => "1000",
      "IX1" => "1001",
      "IX2" => "1010",
      "IX3" => "1011",
      "IX4" => "1100",
      "IX5" => "1101",
      "IX6" => "1110",
      "IX7" => "1111",
    } of String => String
  end

  def compile : Array(String)
    # split into lines
    program = ARGF.gets_to_end.split("\n")

    # remove comments, extra space and empty lines
    program = program.map { |line| line.split(";")[0].strip }.reject(&.empty?)
    # remove commas
    program = program.map { |line| line.gsub(",", " ") }

    # remove extra spaces
    program = program.map { |line| line.gsub(/\s+/, " ") }

    # replace "I " with " I" for immediate addressing
    program = program.map { |line| line.gsub("I ", " I") }

    # replace " *" with " I" for indirect addressing
    program = program.map { |line| line.gsub(" *", " I") }

    # track labels with their line number
    labels = {} of String => Int32
    program.each_with_index do |line, index|
      if line.matches?(/^[a-zA-Z]+:/)
        labels[line.split(":")[0]] = index
        program[index] = line.split(":")[1].strip
      end
    end

    puts "labels: #{labels}"

    # replace labels with relative position
    puts "replacing labels with relative position"
    program.each_with_index do |line, index|
      if line.matches?(/:[a-zA-Z]+$/)
        padding = line.includes?("JMP") || line.includes?("JSR") ? 11 : 7
        label = line.split(":")[1].strip
        pos = labels[label] - index - 1
        sign = pos < 0 ? "1" : "0"
        replace = "#{sign}#{(pos.abs).to_s(2).rjust(padding, '0')}"
        program[index] = line.gsub(/:[a-zA-Z]+$/, "#{replace}")
      end
    end
    puts program

    # replace characters with 8-bit ascii binary
    puts "replacing characters with 8-bit ascii binary"
    program = program.map do |line|
      line.gsub(/'.'/) do |match|
        match[1].ord.to_s(2).rjust(8, '0')
      end
    end
    puts program

    # replace hex 0x? numbers with binary
    puts "replacing hex 0x? numbers with binary"
    program = program.map do |line|
      line.gsub(/0x[0-9a-fA-F]+/) do |match|
        match[2..-1].to_i(16).to_s(2).rjust(8, '0')
      end
    end
    puts program

    # replace hex 0b? numbers with binary
    puts "replacing hex 0b? numbers with binary"
    program = program.map do |line|
      line.gsub(/0b[0-1]+/) do |match|
        match[2..-1].to_i(2).to_s(2).rjust(8, '0')
      end
    end
    puts program

    # replace decimal numbers with binary
    puts "replacing decimal numbers with binary"
    program = program.map do |line|
      line.gsub(/0d\d+/) do |match|
        match[2..-1].to_i.to_s(2).rjust(8, '0')
      end
    end

    # replace lowercase with uppercase
    puts "replacing lowercase with uppercase"
    program = program.map do |line|
      line.gsub(/[a-z]+/) do |match|
        match.upcase
      end
    end
    puts program

    # replace opcodes with binary
    puts "replacing opcodes with binary"
    program = program.map do |line|
      line.gsub(/#{opcodes.keys.join("|")}/) do |match|
        opcodes[match]
      end
    end
    puts program

    # replace syscodes with binary
    puts "replacing syscodes with binary"
    program = program.map do |line|
      line.gsub(/#{syscodes.keys.join("|")}/) do |match|
        syscodes[match]
      end
    end
    puts program

    # replace cndcodes with binary
    puts "replacing cndcodes with binary"
    program = program.map do |line|
      line.gsub(/#{cndcodes.keys.join("|")}/) do |match|
        cndcodes[match]
      end
    end
    puts program

    # replace registers with binary
    puts "replacing registers with binary"
    program = program.map do |line|
      line.gsub(/#{registers.keys.join("|")}/) do |match|
        registers[match]
      end
    end
    puts program

    # left justify all lines to 16 bits
    puts "left justify all lines to 16 bits"
    program = program.map do |line|
      line.gsub(" ", "").ljust(16, '0')
    end
    puts program

    return program
  end
end

t16as = T16as.new

# write to file
File.open("program.hex", "w") do |f|
  t16as.compile.each do |line|
    f.puts line.to_i(2).to_s(16).rjust(4, '0').upcase
  end
end
