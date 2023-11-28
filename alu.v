module alu (
  input clk,
  input rst, // Assuming active-high reset
  input [3:0] opcode,
  input [15:0] src1,
  input [15:0] src2,
  input out_en,
  output [15:0] out,
  output reg [3:0] flags //O C N Z
);

  wire [16:0] result;

  assign result = (opcode == 4'b0000) ? src1 + src2 : // Addition
                  (opcode == 4'b0001) ? src1 - src2 : // Subtraction
                  (opcode == 4'b0010) ? src1 * src2 : // Multiplication
                  (opcode == 4'b0011) ? src1 / src2 : // Division
                  (opcode == 4'b0100) ? src1 & src2 : // Bitwise AND
                  (opcode == 4'b0101) ? src1 | src2 : // Bitwise OR
                  (opcode == 4'b0110) ? src1 ^ src2 : // Bitwise XOR
                  (opcode == 4'b0111) ?      ~ src2 : // Bitwise NOT
                  (opcode == 4'b1000) ? src1 <<< src2 : // Shift Left Arithmetic
                  (opcode == 4'b1001) ? src1 >>> src2 : // Shift Right Arithmetic
                  (opcode == 4'b1010) ? src1 << src2 : // Shift Left Logical
                  (opcode == 4'b1011) ? src1 >> src2 : // Shift Right Logical
                  17'b0; // Default

  assign out = result[15:0];

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      flags <= 4'b0000;
    end else if (out_en) begin
      flags[3] <= (src1[15] == src2[15] && result[15] != src1[15]); // Overflow flag
      flags[2] <= result[16];        // Carry flag
      flags[1] <= result[15];        // Negative flag
      flags[0] <= result[15:0] == 0; // Zero flag
    end
  end
endmodule
