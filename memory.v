module memory (
  input clk,
  input rst,
  input addr_en,
  input [15:0] addr,
  input in_en,
  input [15:0] in,
  input out_en,
  output [15:0] out
);

  parameter MEM_SIZE = 256;
  reg [15:0] mar;
  reg [15:0] mem [0:MEM_SIZE-1];

  assign out = mem[mar];

  always @(negedge rst) begin
    mar <= 16'h0000;
    mem[0] <= 16'h1500;
    mem[1] <= 16'h1701;
    mem[2] <= 16'h3430;
    mem[3] <= 16'h0220;
    mem[4] <= 16'hc002;
  end

  always @(posedge clk) begin
    if (addr_en) begin
      mar <= addr;
    end
    if (in_en) begin
      mem[mar] <= in;
    end
  end
endmodule
