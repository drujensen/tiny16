module registers (
  input clk,
  input rst,
  input [2:0] src_sel,
  input [2:0] dst_sel,
  input in_en,
  input [15:0] in,
  input out_en,
  input pc_inc,
  output reg [15:0] out,
  output reg [15:0] src,
  output reg [15:0] dst
);

  reg [15:0] gpr[0:7];

  always @(posedge clk) begin
    if (rst) begin
      {src, dst} <= 16'h0000;
      gpr[0] <= 16'h0000;
      gpr[1] <= 16'h00FF;
      gpr[2] <= 16'h0000;
      gpr[3] <= 16'h0000;
      gpr[4] <= 16'h0000;
      gpr[5] <= 16'h0000;
      gpr[6] <= 16'h0000;
      gpr[7] <= 16'h0000;
    end else begin
      src <= gpr[src_sel];
      dst <= gpr[dst_sel];

      if (out_en) begin
        out <= gpr[src_sel];
      end else begin
        out <= 16'h0000;
      end
    end
    if (!rst && in_en) begin
      gpr[dst_sel] <= in;
    end

    if (!rst && pc_inc) begin
      gpr[0] <= gpr[0] + 1;
    end
  end
endmodule
