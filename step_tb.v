`timescale 1ns/1ns

module step_tb;

  reg clk;
  reg rst;
  wire [2:0] counter;

  step uut (
    .clk(clk),
    .rst(rst),
    .counter(counter)
  );

  initial begin
    clk = 0;
    rst = 0;

    #4 rst = 1;
    #8 rst = 0;
    $display("counter = %b", counter);
    #4;
    $display("counter = %b", counter);
    #4;
    $display("counter = %b", counter);
    #4;
    $display("counter = %b", counter);
    #4;
    $display("counter = %b", counter);
    #4;
    $display("counter = %b", counter);
    #4;
    $display("counter = %b", counter);
    #4;
    $display("counter = %b", counter);
    #4;
    $display("counter = %b", counter);
    $finish;
  end

  always begin
    #2 clk = ~clk;
  end

endmodule
