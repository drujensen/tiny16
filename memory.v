module memory (
  input clk,
  input rst,
  input in_en,
  input [15:0] in_addr,
  input [15:0] in_data,
  input out_en,
  input [15:0] out_addr,
  output reg [15:0] out_data
);

  reg [15:0] mem ['h0000:'hFFFF];

  always @ (posedge clk) begin
    if (rst == 1'b1) begin
      out_data <= 0;
    end
    if (rst == 1'b0 && out_en == 1'b1) begin
      out_data <= mem[out_addr];
    end
  end

  always @ (negedge clk) begin
    if(rst == 1'b0 && in_en == 1'b1) begin
      mem[in_addr] <= in_data;
    end
  end
endmodule
