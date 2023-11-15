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

        // Wait for reset to be released
        RST <= 1;
        #2;
        RST <= 0;
        #2;

        #256;

        // End simulation
        $display("Simulation complete");
        #2 $finish;
    end
endmodule
