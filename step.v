module step (
  input clk,
  input rst, // Assuming active-high reset
  input step_reset,
  output reg [2:0] counter
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      counter <= 3'b0;
    end else if (step_reset) begin
      counter <= 3'b0;
    end else begin
      counter <= counter + 1;
    end
  end
endmodule
