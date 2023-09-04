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
      src <= 0;
      dst <= 0;
      gpr[0] <= 16'h0000; //PC set to start at 0000
      gpr[1] <= 16'hFFFF; //SP set to start at FFFF
    end
    else begin
      src <= gpr[src_sel];
      dst <= gpr[dst_sel];
    end
  end

  always @(negedge clk) begin
    if (!rst  && in_en == 1'b1) begin
      gpr[dst_sel] <= in;
    end
    if (!rst  && out_en == 1'b1) begin
      out <= gpr[dst_sel];
    end
  end
endmodule
