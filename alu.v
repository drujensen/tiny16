module alu (
  input clk,
  input rst,
  input [3:0] opcode,
  input ar_flag,
  input [15:0] src1,
  input [15:0] src2,
  input out_en,
  output reg [15:0] out,
  output reg [3:0] flags //O C N Z
);

  reg [16:0] result;

  always @(posedge clk) begin
    case(opcode)
      // Addition
      4'b0011 : result <= src1 + src2;

      // Subtraction
      4'b0100 : result <= src1 - src2;

      // Multiplication
      4'b0101 : result <= src1 * src2;

      // Division
      4'b0110 : result <= src1 / src2;

      // Bitwise AND
      4'b0111 : result <= src1 & src2;

      // Bitwise OR
      4'b1000 : result <= src1 | src2;

      // Bitwise XOR
      4'b1001 : result <= src1 ^ src2;

      // Shift left or rotate left
      4'b1010 : begin
        if (ar_flag == 1'b1)
          result <= src1 <<< src2;
        else
          result <= src1 << src2;
      end

      // Shift right or rotate right
      4'b1011 : begin
        if (ar_flag == 1'b1)
          result <= src1 >>> src2;
        else
          result <= src1 >> src2;
      end

      // Default
      default : result <= 0;
    endcase

    if (rst) begin
      result <= 17'b0;
      flags <= 4'b0000;
    end

    if (!rst) begin
      if (out_en) begin
        out <= result[15:0];
        flags[3] <= (src1[15] == src2[15] && result[15] != src1[15]); // Overflow flag
        flags[2] <= result[16];        // Carry flag
        flags[1] <= result[15];        // Negative flag
        flags[0] <= result[15:0] == 0; // Zero flag
      end
      else begin
        out <= 16'hZZZZ; // Tri-state the output of the wire
      end
    end
  end

  always @(negedge clk) begin
  end
endmodule
