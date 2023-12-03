module clock_divider (
    input clk_in,
    input rst,
    output reg clk_out
);

// Assuming a 16 MHz input clock, we need to divide by 16 to get 1 MHz.
localparam DIVIDE_BY = 1; // 16 MHz - disable clock divider
//localparam DIVIDE_BY = 8; // 2 MHz
//localparam DIVIDE_BY = 16384;

reg [15:0] counter; // 4-bit counter to count up to 8

always @(posedge clk_in or posedge rst) begin
  if (rst) begin
    counter <= 0;
    clk_out <= 0;
  end else begin
    if (counter == (DIVIDE_BY - 1)) begin
      // Toggle the output clock and reset the counter
      clk_out <= ~clk_out;
      counter <= 0;
    end else begin
      // Increment the counter
      counter <= counter + 1;
    end
  end
end

endmodule
