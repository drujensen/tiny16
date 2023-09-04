module memory (
  input clk,
  input rst,
  input addr_en,
  input [15:0] addr,
  input in_en,
  input [15:0] in,
  input out_en,
  output reg [15:0] out
);

  parameter MEM_SIZE = 65536;
  reg [15:0] mar;
  reg [15:0] mem [0:MEM_SIZE-1];

  always @(posedge clk) begin
    if (rst) begin
      mar <= 16'b0;
      out <= 16'b0;
    end

    if (!rst && addr_en) begin
      mar <= addr;
    end
  end

  always @(negedge clk) begin
    if (!rst && in_en) begin
      mem[mar] <= in;
    end

    if (!rst && out_en) begin
      out <= mem[mar];
    end
  end
endmodule
