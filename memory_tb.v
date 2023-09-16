`timescale 1ns/1ns

module memory_unit_test;

  // Parameters
  parameter MEM_SIZE = 65536;

  // Inputs
  reg clk;
  reg rst;
  reg addr_en;
  reg [15:0] addr;
  reg in_en;
  reg [15:0] in;
  reg out_en;

  // Outputs
  wire [15:0] out;

  // Instantiate the memory module
  memory dut (
    .clk(clk),
    .rst(rst),
    .addr_en(addr_en),
    .addr(addr),
    .in_en(in_en),
    .in(in),
    .out_en(out_en),
    .out(out)
  );

  // Clock generation
  always begin
    #1 clk = ~clk;
  end

  // Test stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    addr_en = 0;
    addr = 0;
    in_en = 0;
    in = 0;
    out_en = 0;

    // Reset
    #2 rst = 0;
    #2

    // set address to 0
    addr_en = 1;
    addr = 0;
    #2;

    // Write data to memory
    addr_en = 0;
    in_en = 1;
    in = 16'h1234;
    #2;

    // set address to 1
    addr_en = 1;
    addr = 1;
    #2;

    // Write data to memory
    addr_en = 0;
    in_en = 1;
    in = 16'h4321;
    #2;

    // set address to 0
    addr_en = 1;
    addr = 0;
    #2;

    // Read data from memory
    in_en = 0;
    out_en = 1;
    #2;
    out_en = 0;

    $display("out = %h", out);
    if (out !== 16'h1234)
      $error("Test failed");

    // set address to 0
    addr_en = 1;
    addr = 1;
    #2;

    // Read data from memory
    in_en = 0;
    out_en = 1;
    #2;
    out_en = 0;

    $display("out = %h", out);
    // Check expected output
    if (out !== 16'h4321)
      $error("Test failed");

    $display("Test passed");
    $finish;
  end

endmodule
