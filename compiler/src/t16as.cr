class T16as
  VERSION = "0.1.0"
  property opcodes = {} of String => String
  property registers = {} of String => String

  def initialize
    # opcodes for tiny16 computer
    self.opcodes = {
      "NOP"  => "00000000",
      "IN"   => "00000001",
      "OUT"  => "00000010",
      "SET"  => "00000011",
      "CLR"  => "00000100",
      "INT"  => "00001110",
      "HLT"  => "00001111",
      "LLI"  => "0001",
      "LDI"  => "0001",
      "LUI"  => "0010",
      "LD"   => "00110100",
      "ST"   => "00111000",
      "ADD"  => "01000000",
      "SUB"  => "01000100",
      "ADC"  => "01001000",
      "SBC"  => "01001100",
      "MLT"  => "01010000",
      "DIV"  => "01010100",
      "MOD"  => "01011000",
      "AND"  => "01100000",
      "OR"   => "01100100",
      "XOR"  => "01101000",
      "NOT"  => "01101100",
      "SLA"  => "01110000",
      "SRA"  => "01110100",
      "SLL"  => "01111000",
      "SRL"  => "01111100",
      "ADD#" => "01000010",
      "SUB#" => "01000110",
      "ADC#" => "01001010",
      "SBC#" => "01001110",
      "MLT#" => "01010010",
      "DIV#" => "01010110",
      "MOD#" => "01011010",
      "AND#" => "01100010",
      "OR#"  => "01100110",
      "XOR#" => "01101010",
      "NOT#" => "01101110",
      "SLA#" => "01110010",
      "SRA#" => "01110110",
      "SLL#" => "01111010",
      "SRL#" => "01111110",
      "ADDI" => "01000010",
      "SUBI" => "01000110",
      "ADCI" => "01001010",
      "SBCI" => "01001110",
      "MLTI" => "01010010",
      "DIVI" => "01010110",
      "MODI" => "01011010",
      "ANDI" => "01100010",
      "ORI"  => "01100110",
      "XORI" => "01101010",
      "NOTI" => "01101110",
      "SLAI" => "01110010",
      "SRAI" => "01110110",
      "SLLI" => "01111010",
      "SRLI" => "01111110",
      "LD*"  => "00110101",
      "ST*"  => "00111001",
      "ADD*" => "01000001",
      "SUB*" => "01000101",
      "ADC*" => "01001001",
      "SBC*" => "01001101",
      "MLT*" => "01010001",
      "DIV*" => "01010101",
      "MOD*" => "01011001",
      "AND*" => "01100001",
      "OR*"  => "01100101",
      "XOR*" => "01101001",
      "NOT*" => "01101101",
      "SLA*" => "01110001",
      "SRA*" => "01110101",
      "SLL*" => "01111001",
      "SRL*" => "01111101",
      "JALR" => "10000000",
      "BEQ"  => "10010000",
      "BNE"  => "10010001",
      "BLT"  => "10010010",
      "BGE"  => "10010011",
      "BZS"  => "10010000",
      "BZC"  => "10010001",
      "BNS"  => "10010010",
      "BNC"  => "10010011",
      "BCS"  => "10010100",
      "BCC"  => "10010101",
      "BOS"  => "10010110",
      "BOC"  => "10010111",
      "PSH"  => "10100101",
      "POP"  => "10100110",
    } of String => String

    self.registers = {
      "ZERO" => "0000",
      "PC"   => "0001",
      "SP"   => "0010",
      "BA"   => "0011",
      "RA"   => "0100",
      "S0"   => "0101",
      "S1"   => "0110",
      "S2"   => "0111",
      "A0"   => "1000",
      "A1"   => "1001",
      "A2"   => "1010",
      "A3"   => "1011",
      "A4"   => "1100",
      "A5"   => "1101",
      "A6"   => "1110",
      "A7"   => "1111",
      "X0"   => "0000",
      "X1"   => "0001",
      "X2"   => "0010",
      "X3"   => "0011",
      "X4"   => "0100",
      "X5"   => "0101",
      "X6"   => "0110",
      "X7"   => "0111",
      "X8"   => "1000",
      "X9"   => "1001",
      "X10"  => "1010",
      "X11"  => "1011",
      "X12"  => "1100",
      "X13"  => "1101",
      "X14"  => "1110",
      "X15"  => "1111",
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

    # track labels with their line number
    labels = {} of String => Int32
    program.each_with_index do |line, index|
      if line.matches?(/^[a-zA-Z]+:\s/)
        labels[line.split(": ")[0]] = index
        program[index] = line.split(": ")[1].strip
      end
    end

    puts "labels: #{labels}"

    # replace labels with position
    puts "replacing labels with position"
    program.each_with_index do |line, index|
      if line.matches?(/:[a-zA-Z]+$/)
        label = line.split(":")[1].strip
        addr = labels[label]
        replace = addr.to_s(2).rjust(8, '0')

        if line.includes?("LUI") # upper 8 bits of address
          replace = (addr >> 8).to_s(2).rjust(8, '0')
        end

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

    # replace strings with 8-bit ascii binary
    program = program.map do |line|
      if line.includes? "\""
        parts = line.split("\"")
        values = parts[1].gsub("\"", "").bytes.map(&.to_s(2).rjust(16, '0'))
        values[0] = parts[0] + values[0]
        values
      else
        line
      end
    end.flatten
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
    regex = /(#{opcodes.keys.join("|")})(?=\s|$)/
    program = program.map do |line|
      line.gsub(regex) do |match|
        opcodes[match]
      end
    end
    puts program

    # replace registers with binary
    puts "replacing registers with binary"
    program = program.map do |line|
      line.gsub(/(#{registers.keys.join("|")})(?=\s|$)/) do |match|
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
program = t16as.compile

# write to file
File.open("program.hex", "w") do |f|
  program.each do |line|
    f.puts line.to_i(2).to_s(16).rjust(4, '0').upcase
  end
  (0..(256 - program.size - 1)).each do |i|
    f.puts "0000"
  end
end
