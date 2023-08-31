module registers (
  input clk,
  input rst,
  input [2:0] src_sel,
  input [2:0] dst_sel,
  input out_en,
  output reg [15:0] src,
  output reg [15:0] dst,
  input in_en,
  input [15:0] in
);

  reg [15:0] gpr[0:7];

  always @ (posedge clk) begin
    if (rst == 1'b1) begin
      src <= 0;
      dst <= 0;
      gpr[3'b0] <= 'h0000; //PC set to start at 0000
      gpr[3'b1] <= 'hFFFF; //SP set to start at FFFF
    end

    if (rst == 1'b0 && out_en == 1'b1) begin
      src <= gpr[src_sel];
      dst <= gpr[dst_sel];
    end
  end

  always @ (negedge clk) begin
    if (rst == 1'b0 && in_en == 1'b1) begin
      gpr[dst_sel] <= in;
    end
  end
endmodule
