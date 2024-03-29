`include "memory.v"
`include "registers.v"
`include "alu.v"
`include "controller.v"
`include "bus.v"
`include "keyboard.v"
`include "display.v"
`include "clock_divider.v"

module tiny16 (
    input  CLK,            // 16MHz clock
    input  RST,            // reset pin
    input  [7:0] IN,       // 8-bit input
    output [7:0] OUT,      // 8-bit output
    output OUT_EN,
    output USBPU           // USB pull-up resistor
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    wire clk_1mhz;

    // instantiate the clock divider module
    clock_divider div (
        .clk(CLK),
        .rst(RST),
        .clk_1mhz(clk_1mhz)
    );

    wire mem_addr_en;
    wire mem_in_en;
    wire mem_out_en;
    wire [15:0] mem_out;

    // instantiate the memory module
    memory mem (
        .clk(clk_1mhz),
        .addr_en(mem_addr_en),
        .addr(bus_out),
        .in_en(mem_in_en),
        .in(bus_out),
        .out_en(mem_out_en),
        .out(mem_out)
    );

    wire reg_in_en;
    wire reg_up_en;
    wire reg_lo_en;
    wire reg_pc_inc;
    wire reg_sp_inc;
    wire reg_sp_dec;
    wire reg_out_en;
    wire [3:0] reg_src_sel;
    wire [3:0] reg_dst_sel;
    wire [15:0] src;
    wire [15:0] dst;
    wire [15:0] reg_out;

    // instantiate the registers module
    registers regs (
        .clk(clk_1mhz),
        .rst(RST),
        .src_sel(reg_src_sel),
        .dst_sel(reg_dst_sel),
        .in_en(reg_in_en),
        .up_en(reg_up_en),
        .lo_en(reg_lo_en),
        .pc_inc(reg_pc_inc),
        .sp_inc(reg_sp_inc),
        .sp_dec(reg_sp_dec),
        .in(bus_out),
        .src(src),
        .dst(dst),
        .out_en(reg_out_en),
        .out(reg_out)
    );

    wire [3:0] alu_opcode;
    wire alu_out_en;
    wire [3:0] alu_flags;
    wire [15:0] alu_out;

    // instantiate the alu module
    alu alu (
        .clk(clk_1mhz),
        .rst(RST),
        .opcode(alu_opcode),
        .src1(dst),
        .src2(src),
        .out_en(alu_out_en),
        .out(alu_out),
        .flags(alu_flags)
    );

    wire ctl_out_en;
    wire [15:0] ctl_out;

    // instantiate the controller module
    controller ctrl (
        .clk(clk_1mhz),
        .rst(RST),
        .in(bus_out),
        .flags(alu_flags),
        .alu_opcode(alu_opcode),
        .alu_out_en(alu_out_en),
        .mem_addr_en(mem_addr_en),
        .mem_in_en(mem_in_en),
        .mem_out_en(mem_out_en),
        .reg_src_sel(reg_src_sel),
        .reg_dst_sel(reg_dst_sel),
        .reg_in_en(reg_in_en),
        .reg_up_en(reg_up_en),
        .reg_lo_en(reg_lo_en),
        .reg_pc_inc(reg_pc_inc),
        .reg_sp_inc(reg_sp_inc),
        .reg_sp_dec(reg_sp_dec),
        .reg_out_en(reg_out_en),
        .ctl_out_en(ctl_out_en),
        .kbd_out_en(kbd_out_en),
        .dsp_in_en(dsp_in_en),
        .out(ctl_out)
    );

    wire kbd_out_en;
    wire [15:0] kbd_out;

    keyboard kbd (
        .clk(clk_1mhz),
        .rst(RST),
        .in(IN),
        .out_en(kbd_out_en),
        .out(kbd_out)
    );

    wire [15:0] bus_out;

    bus bs (
        .clk(clk_1mhz),
        .rst(RST),
        .alu_out_en(alu_out_en),
        .alu_out(alu_out),
        .mem_out_en(mem_out_en),
        .mem_out(mem_out),
        .reg_out_en(reg_out_en),
        .reg_out(reg_out),
        .ctl_out_en(ctl_out_en),
        .ctl_out(ctl_out),
        .kbd_out_en(kbd_out_en),
        .kbd_out(kbd_out),
        .out(bus_out)
    );

    wire dsp_in_en;
    wire [7:0] dsp_out;

    display dsp (
        .clk(clk_1mhz),
        .rst(RST),
        .in_en(dsp_in_en),
        .in(bus_out),
        .out(dsp_out),
        .trigger(OUT_EN)
    );

    assign OUT = RST ? 8'h55 : dsp_out;
endmodule
