// Defined timescale
//
`timescale 1 ns / 10 ps
module alu_test;

  // Inputs
  reg [3:0] opcode;
  reg [15:0] src1, src2;
  reg ar_flag = 0;

  // Outputs
  wire [15:0] dst;
  wire [3:0] flags;

  // Instantiate the alu module
  alu dut (
    .opcode(opcode),
    .ar_flag(ar_flag),
    .src1(src1),
    .src2(src2),
    .dst(dst),
    .flags(flags)
  );

  // Testbench
  initial begin
    // Initialize inputs
    src1 = 10;       // Random test value
    src2 = 5;        // Random test value

    opcode = 4'b0011; // Addition operation
    #10;

    $display("dst = %d", dst);
    $display("flags = %b", flags);

    opcode = 4'b0100; // Subtraction operation
    #10;

    $display("dst = %d", dst);
    $display("flags = %b", flags);

    opcode = 4'b0101; // Multiplication operation
    #10

    $display("dst = %d", dst);
    $display("flags = %b", flags);

    opcode = 4'b0110; // Division operation
    #10

    $display("dst = %d", dst);
    $display("flags = %b", flags);

    opcode = 4'b0111; // AND operation
    #10

    $display("dst = %d", dst);
    $display("flags = %b", flags);

    opcode = 4'b1000; // OR operation
    #10

    $display("dst = %d", dst);
    $display("flags = %b", flags);

    opcode = 4'b1001; // XOR operation
    #10

    $display("dst = %d", dst);
    $display("flags = %b", flags);

  end

  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(1, alu_test);

    #100;
    $display("Testbench finished");
    $finish;
  end

endmodule
