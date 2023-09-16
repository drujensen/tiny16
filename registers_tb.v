`timescale 1ns/1ns

module registers_tb;
  reg clk;
  reg rst;
  reg [2:0] src_sel;
  reg [2:0] dst_sel;
  reg in_en;
  reg [15:0] in;
  reg out_en;
  reg pc_inc;

  wire [15:0] out;
  wire [15:0] src;
  wire [15:0] dst;

  registers dut (
    .clk(clk),
    .rst(rst),
    .src_sel(src_sel),
    .dst_sel(dst_sel),
    .in_en(in_en),
    .in(in),
    .out_en(out_en),
    .pc_inc(pc_inc),
    .out(out),
    .src(src),
    .dst(dst)
  );

  // Clock generation
  always begin
    #1 clk = ~clk;
  end

  initial begin
    // Initialize inputs
    clk = 0;
    rst = 0;
    src_sel = 0;
    dst_sel = 0;
    in_en = 0;
    in = 0;
    out_en = 0;
    pc_inc = 0;

    // Reset
    #2 rst = 1;
    #2 rst = 0;

    // read from register 0 and 1
    src_sel = 0;
    dst_sel = 1;
    out_en = 1;
    #2

    out_en = 0;

    $display("out = %d", out);
    $display("src = %d", src);
    $display("dst = %d", dst);

    // write a value to register 2
    dst_sel = 2;
    in_en = 1;
    in = 10;
    #2 in_en = 0;

    // write a value to register 3
    dst_sel = 3;
    in_en = 1;
    in = 20;
    #2

    in_en = 0;

    // read from register 0 and 1
    src_sel = 2;
    dst_sel = 3;
    out_en = 1;
    #2

    out_en = 0;

    $display("out = %d", out);
    $display("src = %d", src);
    $display("dst = %d", dst);

    // Finish simulation
    $finish;
  end
endmodule
