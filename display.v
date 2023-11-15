module display (
  input clk,
  input rst,
  input in_en,
  input [15:0] in,
  output reg [15:0] out
);

  always @(posedge clk) begin
    if (rst) begin
      out <= 0;
    end else if (in_en) begin
      out <= in;
    end
  end
endmodule
