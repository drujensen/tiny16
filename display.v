module display (
  input clk,
  input rst,
  input in_en,
  input [15:0] in,
  output reg [7:0] out
);

  always @(posedge rst) begin
    out <= 0;
  end
  always @(posedge clk) begin
    if (in_en) begin
      out <= in[7:0];
    end
  end
endmodule
