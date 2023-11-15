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

  parameter MEM_SIZE = 256;
  reg [15:0] mar;
  reg [7:0] mem [0:MEM_SIZE-1];

  always @(posedge clk) begin
    if (rst) begin
      mar <= 16'hZZZZ;
    end
    if (!rst && out_en) begin
      out <= 8'h0 + mem[mar[7:0]];
    end
    if (!rst && addr_en) begin
      mar <= addr;
    end
    if (!rst && in_en) begin
      mem[mar] <= in;
    end
  end

  initial begin
    $readmemh("memory.mem", mem);
  end
endmodule
