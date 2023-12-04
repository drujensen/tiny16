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
  parameter BA = 4'b0011; // branch address
  parameter RA = 4'b0100; // return address

  reg [15:0] gpr[0:15];

  assign out = gpr[src_sel];
  assign src = gpr[src_sel];
  assign dst = gpr[dst_sel];

  integer i;
  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < 16; i = i + 1) begin
        gpr[i] <= (i == SP) ? 16'h0100 : 16'h0000;
      end
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
