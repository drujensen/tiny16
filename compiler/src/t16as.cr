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
      "SET" => "00000011",
      "CLR" => "00000100",
      "PSH" => "00000101",
      "POP" => "00000110",
      "INT" => "00001110",
      "HLT" => "00001111",
      "LLI" => "0001",
      "LUI" => "0010",
    } of String => String

    self.opcodes = {
      "LD"   => "00110100",
      "ST"   => "00111000",
      "ADD"  => "01000000",
      "SUB"  => "01000100",
      "MLT"  => "01001000",
      "DIV"  => "01001100",
      "AND"  => "01010000",
      "OR"   => "01010100",
      "XOR"  => "01011000",
      "NOT"  => "01011100",
      "SLA"  => "01100000",
      "SRA"  => "01100100",
      "SHL"  => "01101000",
      "SHR"  => "01101100",
      "LD#"  => "00110110",
      "ST#"  => "00111010",
      "ADD#" => "01000010",
      "SUB#" => "01000110",
      "MLT#" => "01001010",
      "DIV#" => "01001110",
      "AND#" => "01010010",
      "OR#"  => "01010110",
      "XOR#" => "01011010",
      "NOT#" => "01011110",
      "SLA#" => "01100010",
      "SRA#" => "01100110",
      "SHL#" => "01101010",
      "SHR#" => "01101110",
      "LDI"  => "00110110",
      "STI"  => "00111010",
      "ADDI" => "01000010",
      "SUBI" => "01000110",
      "MLTI" => "01001010",
      "DIVI" => "01001110",
      "ANDI" => "01010010",
      "ORI"  => "01010110",
      "XORI" => "01011010",
      "NOTI" => "01011110",
      "SLAI" => "01100010",
      "SRAI" => "01100110",
      "SHLI" => "01101010",
      "SHRI" => "01101110",
      "LD*"  => "00110101",
      "ST*"  => "00111001",
      "ADD*" => "01000001",
      "SUB*" => "01000101",
      "MLT*" => "01001001",
      "DIV*" => "01001101",
      "AND*" => "01010001",
      "OR*"  => "01010101",
      "XOR*" => "01011001",
      "NOT*" => "01011101",
      "SLA*" => "01100001",
      "SRA*" => "01100101",
      "SHL*" => "01101001",
      "SHR*" => "01101101",
    } of String => String

    self.cndcodes = {
      "BEQ" => "10000000",
      "BNE" => "10000001",
      "BLT" => "10000010",
      "BGE" => "10000011",
      "BZS" => "10000000",
      "BZC" => "10000001",
      "BNS" => "10000010",
      "BNC" => "10000011",
      "BCS" => "10000100",
      "BCC" => "10000101",
      "BOS" => "10000110",
      "BOC" => "10000111",
    } of String => String

    self.registers = {
      "ZERO" => "0000",
      "PC"   => "0001",
      "SP"   => "0010",
      "BP"   => "0011",
      "RA"   => "0100",
      "T0"   => "0101",
      "T1"   => "0110",
      "T2"   => "0111",
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
      "XA"   => "1010",
      "XB"   => "1011",
      "XC"   => "1100",
      "XD"   => "1101",
      "XE"   => "1110",
      "XF"   => "1111",
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
        program[index] = line.gsub(/:[a-zA-Z]+$/, "#{addr.to_s(2).rjust(8, '0')}")
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

    # replace syscodes with binary
    puts "replacing syscodes with binary"
    program = program.map do |line|
      line.gsub(/(#{syscodes.keys.join("|")})(?=\s|$)/) do |match|
        syscodes[match]
      end
    end
    puts program

    # replace cndcodes with binary
    puts "replacing cndcodes with binary"
    program = program.map do |line|
      line.gsub(/(#{cndcodes.keys.join("|")})(?=\s|$)/) do |match|
        cndcodes[match]
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
