module alu (
  input [3:0] opcode,
  input ar_flag,
  input [15:0] src1,
  input [15:0] src2,
  output [15:0] dst,
  output [3:0] flags //O C N Z
);

  reg [16:0] result;

  always @*
  begin
    case(opcode)
      4'b0011 : begin
        result = src1 + src2;
      end
      4'b0100 : begin
        result = src1 - src2;
      end
      4'b0101 : result = src1 * src2;
      4'b0110 : result = src1 / src2;
      4'b0111 : result = src1 & src2;
      4'b1000 : result = src1 | src2;
      4'b1001 : result = src1 ^ src2;
      4'b1010 : begin
        if (ar_flag == 1'b1)
          result = src1 <<< src2;
        else
          result = src1 << src2;
      end
      4'b1011 : begin
        if (ar_flag == 1'b1)
          result = src1 >>> src2;
        else
          result = src1 >> src2;
      end
      default : result = 0;
    endcase
  end

  assign dst = result[15:0];
  assign flags[3] = (src1[15] == src2[15] && result[15] != src1[15]);
  assign flags[2] = result[16];        // Carry
  assign flags[1] = result[15];        // Negative
  assign flags[0] = result[15:0] == 0; // Zero

endmodule
