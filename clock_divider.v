module clock_divider (
    input clk,
    input rst, // Assuming active-high reset
    output reg clk_1mhz
);

// Assuming a 16 MHz input clock, we need to divide by 16 to get 1 MHz.
// Since we toggle the output clock, we need to count to half of 16, which is 8.
localparam DIVIDE_BY = 8192;

reg [15:0] counter; // 4-bit counter to count up to 8

always @(posedge clk or posedge rst) begin
  if (rst) begin
    counter <= 0;
    clk_1mhz <= 0;
  end else begin
    if (counter == (DIVIDE_BY - 1)) begin
      // Toggle the output clock and reset the counter
      clk_1mhz <= ~clk_1mhz;
      counter <= 0;
    end else begin
      // Increment the counter
      counter <= counter + 1;
    end
  end
end

endmodule
