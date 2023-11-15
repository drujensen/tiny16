`include "memory.v"
`include "registers.v"
`include "alu.v"
`include "controller.v"
`include "bus.v"
`include "display.v"

module tiny16 (
    input  CLK,            // 16MHz clock
    input  RST,
    output [15:0] OUT,     // 16-bit output
    output USBPU           // USB pull-up resistor
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    wire mem_addr_en;
    wire mem_in_en;
    wire mem_out_en;
    wire [15:0] mem_out;

    // instantiate the memory module
    memory mem (
        .clk(CLK),
        .rst(RST),
        .addr_en(mem_addr_en),
        .addr(bus_out),
        .in_en(mem_in_en),
        .in(bus_out),
        .out_en(mem_out_en),
        .out(mem_out)
    );

    wire reg_in_en;
    wire reg_out_en;
    wire reg_pc_inc;
    wire [2:0] reg_src_sel;
    wire [2:0] reg_dst_sel;
    wire [15:0] src;
    wire [15:0] dst;
    wire [15:0] reg_out;

    // instantiate the registers module
    registers regs (
        .clk(CLK),
        .rst(RST),
        .src_sel(reg_src_sel),
        .dst_sel(reg_dst_sel),
        .in_en(reg_in_en),
        .in(bus_out),
        .src(src),
        .dst(dst),
        .out_en(reg_out_en),
        .pc_inc(reg_pc_inc),
        .out(reg_out)
    );

    wire [3:0] alu_opcode;
    wire alu_ar_flag;
    wire alu_out_en;
    wire [3:0] alu_flags;
    wire [15:0] alu_out;

    // instantiate the alu module
    alu alu (
        .clk(CLK),
        .rst(RST),
        .opcode(alu_opcode),
        .ar_flag(alu_ar_flag),
        .src1(src),
        .src2(dst),
        .out_en(alu_out_en),
        .out(alu_out),
        .flags(alu_flags)
    );

    wire ctl_out_en;
    wire [15:0] ctl_out;

    // instantiate the controller module
    controller ctrl (
        .clk(CLK),
        .rst(RST),
        .in(bus_out),
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
        .ctl_out_en(ctl_out_en),
        .dsp_in_en(dsp_in_en),
        .out(ctl_out)
    );

    wire [15:0] bus_out;

    bus bs (
        .clk(CLK),
        .rst(RST),
        .alu_out_en(alu_out_en),
        .alu_out(alu_out),
        .mem_out_en(mem_out_en),
        .mem_out(mem_out),
        .reg_out_en(reg_out_en),
        .reg_out(reg_out),
        .ctl_out_en(ctl_out_en),
        .ctl_out(ctl_out),
        .out(bus_out)
    );


    wire dsp_in_en;
    wire [15:0] dsp_out;

    display dsp (
        .clk(CLK),
        .rst(RST),
        .in_en(dsp_in_en),
        .in(bus_out),
        .out(dsp_out)
    );

    assign OUT = dsp_out;
endmodule
