module registers (
  input clk,
  input rst,
  input [2:0] src_sel,
  input [2:0] dst_sel,
  input out_en,
  input in_en,
  input [15:0] in
  output reg [15:0] src,
  output reg [15:0] dst,
);

  reg [15:0] gpr[0:7];

  always @(posedge clk or negedge rst) begin
    if (rst == 1'b1) begin
      src <= 0;
      dst <= 0;
      gpr[0] <= 16'h0000; //PC set to start at 0000
      gpr[1] <= 16'hFFFF; //SP set to start at FFFF
    end
    else if (out_en == 1'b1) begin
      src <= gpr[src_sel];
      dst <= gpr[dst_sel];
    end
  end

  always @(negedge clk) begin
    if (rst == 1'b0 && in_en == 1'b1) begin
      gpr[dst_sel] <= in;
    end
  end
endmodule
