module registers (
  input clk,
  input rst, // Assuming active-high reset
  input [3:0] src_sel,
  input [3:0] dst_sel,
  input in_en,
  input up_en,
  input lo_en,
  input pc_inc,
  input sp_inc,
  input sp_dec,
  input [15:0] in,
  input out_en,
  output [15:0] out,
  output [15:0] src,
  output [15:0] dst
);

  parameter PC = 4'b0001; // program counter
  parameter SP = 4'b0010; // stack pointer
  parameter BP = 4'b0011; // branch pointer

  reg [15:0] gpr[0:15];

  assign out = gpr[src_sel];
  assign src = gpr[src_sel];
  assign dst = gpr[dst_sel];

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      gpr[0]  <= 16'h0000;
      gpr[1]  <= 16'h0000;
      gpr[2]  <= 16'h00FF;
      gpr[3]  <= 16'h0000;
      gpr[4]  <= 16'h0000;
      gpr[5]  <= 16'h0000;
      gpr[6]  <= 16'h0000;
      gpr[7]  <= 16'h0000;
      gpr[8]  <= 16'h0000;
      gpr[9]  <= 16'h0000;
      gpr[10] <= 16'h0000;
      gpr[11] <= 16'h0000;
      gpr[12] <= 16'h0000;
      gpr[13] <= 16'h0000;
      gpr[14] <= 16'h0000;
      gpr[15] <= 16'h0000;
    end else begin
      if (dst_sel != 0) begin
        if (in_en) begin
            gpr[dst_sel] <= in;
          end

        if (up_en) begin
          gpr[dst_sel][15:8] <= in[7:0];
        end

        if (lo_en) begin
          gpr[dst_sel][7:0] <= in[7:0];
        end
      end

      if (pc_inc) begin
        gpr[PC] <= gpr[PC] + 1;
      end

      if (sp_inc) begin
        gpr[SP] <= gpr[SP] + 1;
      end

      if (sp_dec) begin
        gpr[SP] <= gpr[SP] - 1;
      end
    end
  end
endmodule
