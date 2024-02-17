module display (
  input clk,
  input rst, // Assuming active-high reset
  input in_en,
  input [15:0] in,
  output reg [7:0] out,
  output reg trigger
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      trigger <= 0;
      out <= 0;
    end else begin
      if (in_en) begin
        trigger <= 1;
        out <= in[7:0];
      end 
      if (trigger) begin
        trigger <= 0;
        out <= 0;
      end
    end
  end
endmodule
