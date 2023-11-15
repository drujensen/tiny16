`timescale 1ns/1ns

module tiny16_tb;
    // Declare signals and variables
    reg CLK = 0;
    reg RST = 0;
    wire [15:0] OUT;
    wire USBPU;
    integer idx;

    // Instantiate the DUT (Design Under Test)
    tiny16 dut (
        .CLK(CLK),
        .RST(RST),
        .OUT(OUT),
        .USBPU(USBPU)
    );

    // Clock generation
    always begin
      #1 CLK = ~CLK;
    end

    // Test stimulus
    initial begin
        $dumpfile("tiny16.vcd");
        $dumpvars(0, dut);

        // Populate memory
        dut.mem.mem[16'b0000] = 16'b0001010100000001;      // LD X2, #1
        dut.mem.mem[16'b0001] = 16'b0001011100000010;      // LD X3, #2
        dut.mem.mem[16'b0010] = 16'b0011010000110000;      // ADD X2, X3
        dut.mem.mem[16'b0011] = 16'b1100000000000011;      // JMP #3

        // Wait for reset to be released
        RST <= 1;
        #2;
        RST <= 0;
        #2;

        #64;

        // End simulation
        $display("Simulation complete");
        #2 $finish;
    end
endmodule
