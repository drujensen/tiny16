module registers (
  input clk,
  input rst,
  input [2:0] src_sel,
  input [2:0] dst_sel,
  input in_en,
  input [15:0] in,
  input out_en,
  output reg [15:0] src,
  output reg [15:0] dst,
  output reg [15:0] out
);

  reg [15:0] gpr[0:7];

  always @(posedge clk) begin
    if (rst) begin
      {src, dst} <= 16'h0000;
      gpr[0] <= 16'h0000;
      gpr[1] <= 16'hFFFF;
    end
    else begin
      src <= gpr[src_sel];
      dst <= gpr[dst_sel];
    end
  end

  always @(negedge clk) begin
    if (!rst && in_en) begin
      gpr[dst_sel] <= in;
    end
    if (!rst && out_en) begin
      out <= gpr[dst_sel];
    end
  end
endmodule
