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

  always begin
    #1 clk = ~clk;
  end

  initial begin
    clk = 0;
    rst = 0;

    #4 rst = 1;
    #2 rst = 0;
    $display("counter = %b", counter);
    #2;
    $display("counter = %b", counter);
    #2;
    $display("counter = %b", counter);
    #2;
    $display("counter = %b", counter);
    #2;
    $display("counter = %b", counter);
    #2;
    $display("counter = %b", counter);
    #2;
    $display("counter = %b", counter);
    #2;
    $display("counter = %b", counter);
    #2;
    $display("counter = %b", counter);
    $finish;
  end

endmodule
