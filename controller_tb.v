`timescale 1ns/1ns
// module controller (
//   input clk,
//   input rst,
//   input [15:0] in,
//   input [3:0] flags,
//   output reg [3:0] alu_opcode,
//   output reg alu_out_en,
//   output reg alu_ar_flag,
//   output reg mem_addr_en,
//   output reg mem_in_en,
//   output reg mem_out_en,
//   output reg [2:0] reg_src_sel,
//   output reg [2:0] reg_dst_sel,
//   output reg reg_in_en,
//   output reg reg_out_en,
//   output reg reg_pc_inc,
//   output reg [15:0] out
// );

module controller_test;

  // Inputs
  reg clk = 0;
  reg rst = 0;
  reg [15:0] in;
  reg [3:0] flags;

  // Outputs
  wire [3:0] alu_opcode;
  wire alu_out_en;
  wire alu_ar_flag;
  wire mem_addr_en;
  wire mem_in_en;
  wire mem_out_en;
  wire [2:0] reg_src_sel;
  wire [2:0] reg_dst_sel;
  wire reg_in_en;
  wire reg_out_en;
  wire reg_pc_inc;
  wire [15:0] out;


  // Instantiate the controller module
  controller dut (
    .clk(clk),
    .rst(rst),
    .in(in),
    .flags(flags),
    .alu_opcode(alu_opcode),
    .alu_out_en(alu_out_en),
    .alu_ar_flag(alu_ar_flag),
    .mem_addr_en(mem_addr_en),
    .mem_in_en(mem_in_en),
    .mem_out_en(mem_out_en),
    .reg_src_sel(reg_src_sel),
    .reg_dst_sel(reg_dst_sel),
    .reg_in_en(reg_in_en),
    .reg_out_en(reg_out_en),
    .reg_pc_inc(reg_pc_inc),
    .out(out)
  );

  // Clock generation
    always begin
      #1 clk = ~clk;
    end

  // Testbench
  initial begin
    // Reset
    clk = 0;
    rst = 1;
    #2

    rst = 0;

    $display("stp:", dut.counter);
    #2

    $display("reg_out_en:", reg_out_en);
    if (reg_out_en != 1) begin
      $display("Test failed");
      $finish;
    end
    $display("mem_addr_en:", mem_addr_en);
    if (mem_addr_en != 1) begin
      $display("Test failed");
      $finish;
    end
    $display("stp:", dut.counter);
    #2

    $display("stp:", dut.counter);
    #2

    $display("stp:", dut.counter);
    #2
    $finish;
  end
endmodule
