module memory (
  input clk,
  input addr_en,
  input [15:0] addr,
  input in_en,
  input [15:0] in,
  input out_en,
  output [15:0] out
);

  reg [15:0] mar;
  reg [15:0] mem [0:255];

  assign out = mem[mar];

  always @(posedge clk) begin
    if (addr_en) begin
      mar <= addr;
    end
    if (in_en) begin
      mem[mar] <= in;
    end
  end

  initial begin
    $readmemh("program.hex", mem);
  end
endmodule
