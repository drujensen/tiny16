module keyboard (
  input clk,
  input rst,
  input out_en,
  input trigger_en,
  input [7:0] in,
  output reg [15:0] out,
  output reg trigger
);
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      out <= 0;
      trigger <= 0;
    end else begin

      if (trigger_en) begin
        trigger <= 1;
      end else begin
        trigger <= 0;
      end

      if (out_en) begin
        out <= {8'b0, in};
      end
    end
  end
endmodule
