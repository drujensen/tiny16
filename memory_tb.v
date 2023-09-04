`timescale 1ns/1ns

module memory_unit_test;

  // Parameters
  parameter MEM_SIZE = 65536;

  // Inputs
  reg clk;
  reg rst;
  reg in_en;
  reg [15:0] in_addr;
  reg [15:0] in_data;
  reg out_en;
  reg [15:0] out_addr;

  // Outputs
  wire [15:0] out_data;

  // Instantiate the memory module
  memory dut (
    .clk(clk),
    .rst(rst),
    .in_en(in_en),
    .in_addr(in_addr),
    .in_data(in_data),
    .out_en(out_en),
    .out_addr(out_addr),
    .out_data(out_data)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Test stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    in_en = 0;
    in_addr = 0;
    in_data = 0;
    out_en = 0;
    out_addr = 0;

    // Reset
    #10 rst = 0;

    // Write data to memory
    in_en = 1;
    in_addr = 0;
    in_data = 16'h1234;
    #10;
    in_en = 0;

    // Read data from memory
    out_en = 1;
    out_addr = 0;
    #10;
    out_en = 0;

    $display("out_data = %h", out_data);

    // Check expected output
    if (out_data !== 16'h1234)
      $error("Test failed");

    $display("Test passed");
    $finish;
  end

endmodule
