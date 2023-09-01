`timescale 1ns/1ns

module registers_tb;
  reg clk;
  reg rst;
  reg [2:0] src_sel;
  reg [2:0] dst_sel;
  reg out_en;
  reg in_en;
  reg [15:0] in;

  wire [15:0] src;
  wire [15:0] dst;

  registers dut (
    .clk(clk),
    .rst(rst),
    .src_sel(src_sel),
    .dst_sel(dst_sel),
    .out_en(out_en),
    .src(src),
    .dst(dst),
    .in_en(in_en),
    .in(in)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  initial begin
    // Initialize inputs
    clk = 0;
    rst = 0;
    src_sel = 0;
    dst_sel = 0;
    out_en = 0;
    in_en = 0;
    in = 0;

    // Reset
    #10 rst = 1;
    #10 rst = 0;

    // read from register 0 and 1
    src_sel = 0;
    dst_sel = 1;
    out_en = 1;
    #10 out_en = 0;

    $display("src = %d", src);
    $display("dst = %d", dst);

    // write a value to register 2
    dst_sel = 2;
    in_en = 1;
    in = 10;
    #10 in_en = 0;

    // write a value to register 3
    dst_sel = 3;
    in_en = 1;
    in = 20;
    #10 in_en = 0;

    // read from register 0 and 1
    src_sel = 2;
    dst_sel = 3;
    out_en = 1;
    #10 out_en = 0;

    $display("src = %d", src);
    $display("dst = %d", dst);

    // Finish simulation
    $finish;
  end
endmodule
