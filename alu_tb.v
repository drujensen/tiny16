`timescale 1ns/1ns

module alu_test;

  // Inputs
  reg clk = 0;
  reg rst = 0;
  reg [3:0] opcode;
  reg [15:0] src1, src2;
  reg ar_flag = 0;
  reg out_en = 1;

  // Outputs
  wire [15:0] out;
  wire [3:0] flags;

  // Instantiate the alu module
  alu dut (
    .clk(clk),
    .rst(rst),
    .opcode(opcode),
    .ar_flag(ar_flag),
    .src1(src1),
    .src2(src2),
    .out_en(out_en),
    .out(out),
    .flags(flags)
  );

  // Clock generation
    always begin
      #1 clk = ~clk;
    end

  // Testbench
  initial begin
    src1 <= 10;
    src2 <= 5;

    rst <= 1;
    #4
    rst <= 0;
    out_en <= 0;
    #4

    $display("RST:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    opcode <= 4'b0011; // Addition operation
    out_en <= 1;
    #4

    $display("ADD:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    opcode <= 4'b0100; // Subtraction operation
    #4

    $display("SUB:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    opcode <= 4'b0101; // Multiplication operation
    #4

    $display("MUL:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    opcode <= 4'b0110; // Division operation
    #4

    $display("DIV:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    opcode <= 4'b0111; // AND operation
    #4

    $display("AND:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    opcode <= 4'b1000; // OR operation
    #4

    $display("OR:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    opcode <= 4'b1001; // XOR operation
    #4

    $display("XOR:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    opcode <= 4'b1010; // SHL operation
    #4

    $display("SHL:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    opcode <= 4'b1011; // SHR operation
    #4

    $display("SHR:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    opcode <= 4'b1010; // ROL operation
    ar_flag <= 1'b1;
    #4

    $display("ROL:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    opcode <= 4'b1011; // ROR operation
    ar_flag <= 1'b1;
    #4

    $display("ROR:");
    $display("out = %d", out);
    $display("flags = %b", flags);

    #4 $finish;
  end
endmodule
