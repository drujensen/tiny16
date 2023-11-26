module registers (
  input clk,
  input rst, // Assuming active-high reset
  input [2:0] src_sel,
  input [2:0] dst_sel,
  input in_en,
  input up_en,
  input lo_en,
  input pc_inc,
  input sp_inc,
  input sp_dec,
  input jp_en,
  input br_en,
  input [15:0] in,
  input out_en,
  output [15:0] out,
  output [15:0] src,
  output [15:0] dst
);

  reg [15:0] gpr[0:7];

  assign out = gpr[src_sel];
  assign src = gpr[src_sel];
  assign dst = gpr[dst_sel];

  wire dir;
  assign dir = jp_en ? in[11] : in[7];

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      gpr[0] <= 16'h0000;
      gpr[1] <= 16'h00FF;
      gpr[2] <= 16'h0000;
      gpr[3] <= 16'h0000;
      gpr[4] <= 16'h0000;
      gpr[5] <= 16'h0000;
      gpr[6] <= 16'h0000;
      gpr[7] <= 16'h0000;
    end else begin
      if (in_en) begin
        gpr[dst_sel] <= in;
      end

      if (up_en) begin
        gpr[dst_sel][15:8] <= in[7:0];
      end
      
      if (lo_en) begin
        gpr[dst_sel][7:0] <= in[7:0];
      end

      if (pc_inc) begin
        gpr[0] <= gpr[0] + 1;
      end

      if (sp_inc) begin
        gpr[1] <= gpr[1] + 1;
      end

      if (sp_dec) begin
        gpr[1] <= gpr[1] - 1;
      end

      if (jp_en) begin
        gpr[0] <= dir ? gpr[0] - in[10:0] : gpr[0] + in[10:0];
      end

      if (br_en) begin
        gpr[0] <= dir ? gpr[0] - in[6:0] : gpr[0] + in[6:0];
      end
    end
  end
endmodule
