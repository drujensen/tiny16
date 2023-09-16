`timescale 1ns/1ns

module tiny16_tb;
    // Declare signals and variables
    reg CLK = 0;
    reg RST = 0;
    wire [15:0] OUT;
    wire USBPU;
    integer i = 0;

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
        // Initialize inputs
        // Perform test operations
        // Write test code here
        // Populate memory
        dut.mem.mem[16'b0000] = 16'b0001010100000001;      // LD X2, #1
        dut.mem.mem[16'b0001] = 16'b0001011100000010;      // LD X3, #2
        dut.mem.mem[16'b0010] = 16'b0011010000110000;      // ADD X2, X3
        dut.mem.mem[16'b0011] = 16'b1100000000000011;      // JMP #3

        // Wait for reset to be released
        RST <= 1;
        #4
        RST <= 0;
        #2;

        for (i=0; i<16; i=i+1) begin
          $display("stp: %h", dut.ctrl.step.counter);
          $display("ins: %h", dut.ctrl.in);
          $display("opc: %h", dut.ctrl.opcode);
          $display("ade: %h", dut.mem_addr_en);
          $display("reg: %h", dut.regs.out);
          $display(" X0: %h", dut.regs.gpr[0]);
          $display(" X1: %h", dut.regs.gpr[1]);
          $display(" X2: %h", dut.regs.gpr[2]);
          $display(" X3: %h", dut.regs.gpr[3]);
          $display(" X4: %h", dut.regs.gpr[4]);
          $display(" X5: %h", dut.regs.gpr[5]);
          $display("adr: %h", dut.mem.addr);
          $display("mem: %h", dut.mem.out);
          $display("alu: %h", dut.alu.out);
          $display("---------------------------");
          #2;
        end

        // End simulation
        #2 $finish;
    end
endmodule
