module step (
  input clk,
  input rst,
  input step_reset,
  output reg [2:0] counter
);
  always @(negedge rst) begin
    counter <= 3'b0;
  end
  always @(negedge clk) begin
    if (step_reset == 1) begin
      counter <= 3'b0;
    end else begin
      counter <= counter + 1;
    end
  end
endmodule
