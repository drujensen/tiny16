module keyboard (
  input clk,
  input rst,
  input out_en,
  input [7:0] in,
  output reg [15:0] out
);

  reg [15:0] buffer;
  reg delay;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      out <= 0;
      delay <= 0;
    end else begin
      if (in[7]) begin
        buffer <= {9'b0, in[6:0]};
      end
      if (out_en) begin
        out <= buffer;
        delay <= 1;
      end
      if (delay) begin
        delay <= 0;
        buffer <= 0;
      end
    end
  end
endmodule
