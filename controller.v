`include "step.v"

module controller (
  input clk,
  input rst,
  input [15:0] in,
  input [3:0] flags,
  output [3:0] alu_opcode,
  output alu_out_en,
  output alu_ar_flag,
  output mem_addr_en,
  output mem_in_en,
  output mem_out_en,
  output [2:0] reg_src_sel,
  output [2:0] reg_dst_sel,
  output reg_in_en,
  output reg_out_en,
  output reg_pc_inc,
  output reg [15:0] out
);

  reg [2:0] counter;
  reg [3:0] alu_flags;
  reg [3:0] opcode;
  reg imm;
  reg [2:0] dst;
  reg ind;
  reg [2:0] src;
  reg [4:0] off;

  wire step_reset;

  step step (
   .clk(clk),
   .rst(rst || step_reset),
   .counter(counter)
  );

  always @(posedge clk) begin
    //reset all signals
    alu_opcode = 4'b0000;
    alu_out_en = 0;
    alu_ar_flag = 0;
    mem_addr_en = 0;
    mem_in_en = 0;
    mem_out_en = 0;
    reg_src_sel = 3'b000;
    reg_dst_sel = 3'b000;
    reg_in_en = 0;
    reg_out_en = 0;
    reg_pc_inc = 0;
    step_reset = 0;

    case (counter)
      0 : begin
        reg_dst_sel = 3'b000;
        reg_out_en = 1;
        mem_addr_en = 1;
      end
      1 : begin
        mem_out_en = 1;
        reg_pc_inc = 1;
        alu_flags = flags;
        opcode = in[15:12];
        imm = in[11];
        dst = in[10:8];
        ind = in[7];
        src = in[6:4];
        off = in[3:0];
      end
      default: begin
        case (opcode)
          0 : begin // SYS
            step_reset = 1;
          end
          1 : begin // LD
            step_reset = 1;
          end
          2 : begin // ST
            step_reset = 1;
          end
          3 : begin // ADD
            step_reset = 1;
          end
          4 : begin // SUB
            step_reset = 1;
          end
          5 : begin // MUL
            step_reset = 1;
          end
          6 : begin // DIV
            step_reset = 1;
          end
          7 : begin // AND
            step_reset = 1;
          end
          8 : begin // OR
            step_reset = 1;
          end
          9 : begin // XOR
            step_reset = 1;
          end
          10 : begin // SHL
            step_reset = 1;
          end
          11 : begin // SHR
            step_reset = 1;
          end
          12 : begin // JMP
            step_reset = 1;
          end
          13 : begin // JSR
            step_reset = 1;
          end
          14 : begin // CMP
            step_reset = 1;
          end
          15 : begin // BR
            step_reset = 1;
          end
          default: begin
            step_reset = 1;
          end
        endcase
      end
    endcase
  end
endmodule
