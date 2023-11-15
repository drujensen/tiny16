module bus (
  input clk,
  input rst,
  input alu_out_en,
  input [15:0] alu_out,
  input mem_out_en,
  input [15:0] mem_out,
  input reg_out_en,
  input [15:0] reg_out,
  input ctl_out_en,
  input [15:0] ctl_out,
  output [15:0] out
);

  assign out = alu_out_en ? alu_out :
               mem_out_en ? mem_out :
               reg_out_en ? reg_out :
               ctl_out_en ? ctl_out :
               16'h0000;
endmodule
