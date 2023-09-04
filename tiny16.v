`include "memory.v"
`include "registers.v"
`include "alu.v"
`include "controller.v"

module tiny16 (
    input  CLK,            // 16MHz clock
    input  RST,
    output USBPU           // USB pull-up resistor
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    //create a bus
    wire [15:0] bus;

    wire mem_addr_en;
    wire mem_in_en;
    wire mem_out_en;

    // instantiate the memory module
    memory mem (
        .clk(CLK),
        .rst(RST),
        .addr_en(mem_addr_en),
        .addr(bus),
        .in_en(mem_in_en),
        .in(bus),
        .out_en(mem_out_en),
        .out(bus)
    );

    wire reg_in_en;
    wire reg_out_en;
    wire [2:0] reg_src_sel;
    wire [2:0] reg_dst_sel;
    wire [15:0] src;
    wire [15:0] dst;

    // instantiate the registers module
    registers regs (
        .clk(CLK),
        .rst(RST),
        .src_sel(reg_src_sel),
        .dst_sel(reg_dst_sel),
        .in_en(reg_in_en),
        .in(bus),
        .out_en(reg_out_en),
        .out(bus),
        .src(src),
        .dst(dst)
    );

    wire [3:0] alu_opcode;
    wire alu_ar_flag;
    wire alu_out_en;
    wire [3:0] alu_flags;

    // instantiate the alu module
    alu alu (
        .clk(CLK),
        .rst(RST),
        .opcode(alu_opcode),
        .ar_flag(alu_ar_flag),
        .src1(src),
        .src2(dst),
        .out_en(alu_out_en),
        .out(bus),
        .flags(alu_flags)
    );

    // instantiate the controller module
    controller ctrl (
        .clk(CLK),
        .rst(RST),
        .in(bus),
        .flags(alu_flags),
        .alu_opcode(alu_opcode),
        .alu_out_en(alu_out_en),
        .alu_ar_flag(alu_ar_flag),
        .mem_addr_en(mem_addr_en),
        .mem_in_en(mem_in_en),
        .mem_out_en(mem_out_en),
        .reg_src_sel(reg_src_sel),
        .reg_dst_sel(reg_dst_sel),
        .reg_in_en(reg_in_en),
        .reg_out_en(reg_out_en),
        .reg_pc_inc(reg_pc_inc),
        .out(bus)
    );

  always @ (posedge clk) begin

  end
endmodule
