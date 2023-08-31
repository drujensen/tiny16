`include "memory.v"
`include "registers.v"
`include "alu.v"

module tiny16 (
    input  CLK,            // 16MHz clock
    input  RST,
    output USBPU           // USB pull-up resistor
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    memory mem (
      .clk(CLK),
      .rst(RST),
      .in_en(0),
      .in_addr(0),
      .in_data(0),
      .out_en(0),
      .out_addr(0),
      .out_data()
    );

    registers rgstr (
      .clk(CLK),
      .rst(RST),
      .src_sel('h2),
      .dst_sel('h2),
      .out_en(1),
      .src(),
      .dst(),
      .in_en(1),
      .in(0)
    );

    alu cpu (
      .opcode('h4),
      .ar_flag(0),
      .src1(0),
      .src2(0),
      .dst()
    );

  always @ (posedge clk) begin

  end
endmodule
