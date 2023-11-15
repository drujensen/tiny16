module display (
  input clk,
  input rst,
  input in_en,
  input [15:0] in,
  output [15:0] out
);

  reg [15:0] out_reg;

  assign out = out_reg;

  always @(posedge clk) begin
    if (rst) begin
      out_reg <= 0;
    end else if (in_en) begin
      out_reg <= in;
    end
  end
endmodule
