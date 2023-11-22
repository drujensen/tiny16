module memory (
  input clk,
  input rst, // Assuming active-high reset
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

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      mar <= 16'h0000;
    end else begin
      if (addr_en) begin
        mar <= addr;
      end
      if (in_en) begin
        //TODO: fix this
        //mem[mar] <= in;
      end
    end
  end

  initial begin
    $readmemh("program.hex", mem);
  end
endmodule
