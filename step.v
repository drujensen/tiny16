module step (
  input clk,
  input rst,
  output reg [2:0] counter
);
  always @(negedge clk) begin
    if (rst) begin
      counter <= 3'b0;
    end else begin
      counter <= counter + 1;
    end
  end
endmodule
