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

  parameter MEM_SIZE = 65536;
  reg [15:0] mem [0:MEM_SIZE-1];

  always @(posedge clk) begin
    if (rst) begin
      out_data <= 16'b0;
    end
    else if (out_en) begin
      out_data <= mem[out_addr];
    end
  end

  always @(negedge clk) begin
    if (!rst && in_en) begin
      mem[in_addr] <= in_data;
    end
  end
endmodule
