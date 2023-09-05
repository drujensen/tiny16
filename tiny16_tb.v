`timescale 1ns/1ns

module tiny16_tb;
    // Declare signals and variables
    reg CLK, RST;
    wire [15:0] OUT;
    wire USBPU;

    // Instantiate the DUT (Design Under Test)
    tiny16 dut (
        .CLK(CLK),
        .RST(RST),
        .OUT(OUT),
        .USBPU(USBPU)
    );

    // Clock generation
    always #5 CLK = ~CLK;

    // Test stimulus
    initial begin
        // Initialize inputs
        CLK = 0;
        RST = 1;
        // Perform test operations
        // Write test code here
        // Populate memory
        dut.mem.mem[16'b0000] = 16'b0001010100000001;      // LD X2, #1
        dut.mem.mem[16'b0001] = 16'b0001011100000010;      // LD X3, #2
        dut.mem.mem[16'b0010] = 16'b0011010000110000;      // ADD X2, X3

        // Wait for reset to be released
        #10 RST = 0;
        #10

        $display("X0: %d", dut.regs.gpr[0]);
        $display("X1: %d", dut.regs.gpr[1]);
        $display("X2: %d", dut.regs.gpr[2]);
        $display("X3: %d", dut.regs.gpr[3]);

        #120;
        $display("ADD X2, X3");
        $display("X0: %d", dut.regs.gpr[0]);
        $display("X1: %d", dut.regs.gpr[1]);
        $display("X2: %d", dut.regs.gpr[2]);
        $display("X3: %d", dut.regs.gpr[3]);

        // End simulation
        #240 $finish;
    end
endmodule
