module display (
  input clk,
  input rst, // Assuming active-high reset
  input in_en,
  input [15:0] in,
  output reg [7:0] out
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      out <= 0;
    end else if (in_en) begin
      out <= in[7:0];
    end
  end
endmodule
