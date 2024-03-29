`timescale 1ns/1ns

module tiny16_tb;
    // Declare signals and variables
    reg CLK = 0;
    reg RST = 0;
    reg [7:0] IN;
    wire [7:0] OUT;
    wire OUT_EN;
    wire USBPU;

    // Instantiate the DUT (Design Under Test)
    tiny16 dut (
        .CLK(CLK),
        .RST(RST),
        .IN(IN),
        .OUT(OUT),
        .OUT_EN(OUT_EN),
        .USBPU(USBPU)
    );

    // Clock generation
    always begin
      #1 CLK = ~CLK;
    end

    // Test stimulus
    initial begin
        // write to dumpfile
        $dumpfile("tiny16.vcd");
        $dumpvars(0, dut.regs.gpr[0],
                     dut.regs.gpr[1],
                     dut.regs.gpr[2],
                     dut.regs.gpr[3],
                     dut.regs.gpr[4],
                     dut.regs.gpr[5],
                     dut.regs.gpr[6],
                     dut.regs.gpr[7],
                     dut.regs.gpr[8],
                     dut.regs.gpr[9],
                     dut.regs.gpr[10],
                     dut.regs.gpr[11],
                     dut.regs.gpr[12],
                     dut.regs.gpr[13],
                     dut.regs.gpr[14],
                     dut.regs.gpr[15]
                  );
        $dumpvars(0, dut);

        IN <= 0;

        // simulate reset
        RST <= 1;
        #8;
        RST <= 0;

        #4096;

        // End simulation
        $display("Simulation complete");
        #2 $finish;
    end
endmodule
