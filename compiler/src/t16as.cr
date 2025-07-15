class T16as
  VERSION = "0.1.0"
  property aliases = {} of String => String
  property opcodes = {} of String => String
  property registers = {} of String => String

  def initialize
    # aliases for tiny16 computer
    self.aliases = {
      "JMP" => "JALR X0 BA",
      "JSR" => "JALR RA BA",
      "RET" => "JALR X0 RA",
    }

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
      "LUI"  => "0010",
      "LD"   => "00110000",
      "ST"   => "00110001",
      "LDP"  => "00110010",
      "STP"  => "00111011",
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
      "ADDP" => "01000001",
      "SUBP" => "01000101",
      "ADCP" => "01001001",
      "SBCP" => "01001101",
      "MLTP" => "01010001",
      "DIVP" => "01010101",
      "MODP" => "01011001",
      "ANDP" => "01100001",
      "ORP"  => "01100101",
      "XORP" => "01101001",
      "NOTP" => "01101101",
      "SLAP" => "01110001",
      "SRAP" => "01110101",
      "SLLP" => "01111001",
      "SRLP" => "01111101",
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
      "PSH"  => "10100000",
      "POP"  => "10100001",
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
      "S3"   => "1000",
      "S4"   => "1001",
      "A0"   => "1010",
      "A1"   => "1011",
      "A2"   => "1100",
      "A3"   => "1101",
      "A4"   => "1110",
      "A5"   => "1111",
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
      "zero" => "0000",
      "pc"   => "0001",
      "sp"   => "0010",
      "ba"   => "0011",
      "ra"   => "0100",
      "s0"   => "0101",
      "s1"   => "0110",
      "s2"   => "0111",
      "s3"   => "1000",
      "s4"   => "1001",
      "a0"   => "1010",
      "a1"   => "1011",
      "a2"   => "1100",
      "a3"   => "1101",
      "a4"   => "1110",
      "a5"   => "1111",
      "x0"   => "0000",
      "x1"   => "0001",
      "x2"   => "0010",
      "x3"   => "0011",
      "x4"   => "0100",
      "x5"   => "0101",
      "x6"   => "0110",
      "x7"   => "0111",
      "x8"   => "1000",
      "x9"   => "1001",
      "x10"  => "1010",
      "x11"  => "1011",
      "x12"  => "1100",
      "x13"  => "1101",
      "x14"  => "1110",
      "x15"  => "1111",
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

    puts "replacing aliases"
    regex = /(#{aliases.keys.join("|")})(?=\s|$)/
    program.each_with_index do |line, index|
      if line.match(regex)
        program[index] = line.gsub(regex) do |match|
          aliases[match]
        end
      end
      if line.includes? "PSHR"
        program[index] = line.gsub("PSHR", "PSH RA")
        program.insert(index + 1, "PSH S4")
        program.insert(index + 1, "PSH S3")
        program.insert(index + 1, "PSH S2")
        program.insert(index + 1, "PSH S1")
        program.insert(index + 1, "PSH S0")
      end
      if line.includes? "POPR"
        program[index] = line.gsub("POPR", "POP S4")
        program.insert(index + 1, "POP RA")
        program.insert(index + 1, "POP S0")
        program.insert(index + 1, "POP S1")
        program.insert(index + 1, "POP S2")
        program.insert(index + 1, "POP S3")
      end
    end
    puts program

    puts "replacing characters with 8-bit ascii binary"
    program = program.map do |line|
      line.gsub(/'.'/) do |match|
        match[1].ord.to_s(2).rjust(8, '0')
      end
    end
    puts program

    puts "replace strings with 16-bit ascii binary"
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

    puts "replacing LDI with LLI and LUI"
    program.each_with_index do |line, index|
      if match = line.match(/^LDI.*0x([0-9a-fA-Z]+)$/)
        if capture = match.captures[0]
          program.insert(index, program[index])

          value = capture.to_i(16)
          replace = (value >> 8).to_s(2).rjust(8, '0')
          program[index] = program[index].gsub("LDI", "LUI")
          program[index] = program[index].gsub(/0x[0-9A-Z]+$/, replace)

          value = capture[-2..-1].to_i(16)
          replace = value.to_s(2).rjust(8, '0')
          program[index + 1] = program[index + 1].gsub("LDI", "LLI")
          program[index + 1] = program[index + 1].gsub(/0x[0-9A-Z]+$/, replace)
          program[index + 1] = program[index + 1].gsub(/^[0-9a-zA-Z]+:/, "")
        end
      end

      if match = line.match(/LDI.*(:[0-9a-zA-Z]+)$/)
        program.insert(index, program[index])
        program[index] = program[index].gsub("LDI", "LUI")
        program[index + 1] = program[index + 1].gsub("LDI", "LLI")
        program[index + 1] = program[index + 1].gsub(/^[0-9a-zA-Z]+:/, "")
      end

      if match = line.match(/(JALR|BEQ|BNE|BLT|BGE|BZS|BZC|BNS|BNC|BCS|BCC|BOS|BOC).*(:[0-9a-zA-Z]+)$/)
        if capture = match.captures[1]
          program[index] = line.gsub(/:[a-zA-Z]+$/, "")
          program.insert(index, "LLI BA #{capture}")
          program.insert(index, "LUI BA #{capture}")
        end
      end
    end
    puts program

    puts "replacing hex 0x? numbers with binary"
    program = program.map do |line|
      line.gsub(/0x[0-9a-fA-F]+/) do |match|
        match[2..-1].chars.map { |c| c.to_i(16).to_s(2).rjust(4, '0') }.join
      end
    end
    puts program

    puts "replacing hex 0b? numbers with binary"
    program = program.map do |line|
      line.gsub(/0b[0-1]+/) do |match|
        match[2..-1].chars.map { |c| c.to_i(2).to_s(2).rjust(4, '0') }.join
      end
    end
    puts program

    # track labels with their line number
    labels = {} of String => Int32
    program.each_with_index do |line, index|
      if line.matches?(/^[a-zA-Z]+:\s/)
        labels[line.split(": ")[0]] = index
        program[index] = line.split(": ")[1].strip
      end
    end
    puts "identifying labels: #{labels}"

    # replace labels with position
    puts "replacing labels with position"
    program.each_with_index do |line, index|
      if line.matches?(/:[a-zA-Z]+$/)
        label = line.split(":")[1].strip
        addr = labels[label]

        if line.includes?("LUI") # upper 8 bits of address
          replace = (addr >> 8).to_s(2).rjust(8, '0')
          program[index] = line.gsub(/:[a-zA-Z]+$/, "#{replace}")
        else
          replace = addr.to_s(2).rjust(8, '0')
          program[index] = line.gsub(/:[a-zA-Z]+$/, "#{replace}")
        end
      end
    end
    puts program

    puts "replacing opcodes with binary"
    regex = /(#{opcodes.keys.join("|")})(?=\s|$)/
    program = program.map do |line|
      line.gsub(regex) do |match|
        opcodes[match]
      end
    end
    puts program

    puts "replacing registers with binary"
    program = program.map do |line|
      line.gsub(/(#{registers.keys.join("|")})(?=\s|$)/) do |match|
        registers[match]
      end
    end
    puts program

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
