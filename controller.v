`include "step.v"

module controller (
  input clk,
  input rst,
  input [15:0] in,
  input [3:0] flags,
  output reg [3:0] alu_opcode,
  output reg [3:0] reg_src_sel,
  output reg [3:0] reg_dst_sel,
  output reg alu_out_en,
  output reg mem_addr_en,
  output reg mem_in_en,
  output reg mem_out_en,
  output reg reg_in_en,
  output reg reg_up_en,
  output reg reg_lo_en,
  output reg reg_pc_inc,
  output reg reg_sp_inc,
  output reg reg_sp_dec,
  output reg reg_jp_en,
  output reg reg_br_en,
  output reg reg_out_en,
  output reg ctl_out_en,
  output reg kbd_out_en,
  output reg dsp_in_en,
  output [15:0] out
);

  parameter PC = 4'b0001; // program counter
  parameter SP = 4'b0010; // stack pointer
  parameter BA = 4'b0011; // branch address
  parameter RA = 4'b0100; // return address
  parameter RES = 4'b1111; // reserved register

  parameter ADD = 4'b0000; // Add
  parameter SUB = 4'b0001; // Subtract

  wire [2:0] counter;
  reg [15:0] inst;
  wire [3:0] opcode;
  wire [3:0] funct;
  wire [3:0] dst;
  wire [3:0] src;

  wire [4:0] alu_funct;
  wire imm;
  wire ind;

  assign opcode = inst[15:12];
  assign funct = inst[11:8];
  assign dst = inst[7:4];
  assign src = inst[3:0];

  // if top 2 bits of instruction is math/logic/shift/mult
  // then output 4 bits otherwise output 8 bits
  assign out = (inst[15:14] == 1) ? inst[3:0] : inst[7:0];

  assign alu_funct = inst[13:10];
  assign imm = inst[9];
  assign ind = inst[8];

  wire step_reset;
  reg halt = 0;

  assign step_reset = (counter == 7) ? 1 : 0;

  step step (
   .clk(clk),
   .rst(rst | halt),
   .step_reset(step_reset),
   .counter(counter)
  );

  always @(negedge clk) begin
    // Reset all signals
    alu_opcode <= 4'b0000;
    reg_src_sel <= 4'b0000;
    reg_dst_sel <= 4'b0000;
    alu_out_en <= 0;
    mem_addr_en <= 0;
    mem_in_en <= 0;
    mem_out_en <= 0;
    reg_in_en <= 0;
    reg_up_en <= 0;
    reg_lo_en <= 0;
    reg_pc_inc <= 0;
    reg_sp_inc <= 0;
    reg_sp_dec <= 0;
    reg_out_en <= 0;
    ctl_out_en <= 0;
    kbd_out_en <= 0;
    dsp_in_en <= 0;

    case (counter)
      0 : begin
        inst <= 16'h0000;
        reg_src_sel <= PC; //program counter
        reg_out_en <= 1;  //send pc to bus
        mem_addr_en <= 1; //send bus to memory address
      end
      1 : begin
        mem_out_en <= 1; //send memory to bus
        reg_pc_inc <= 1; //increment program counter
      end
      2 : begin
        inst <= in; //get instruction
      end
      default: begin
        case (opcode)
          0 : begin // SYS
            case (funct)
              0 : begin // NOP
              end
              1 : begin // IN
                case (counter)
                  3: begin
                    reg_dst_sel <= dst;
                    kbd_out_en <= 1;
                    reg_in_en <= 1;
                  end
                endcase
              end
              2 : begin // OUT
                case (counter)
                  3: begin
                    reg_src_sel <= dst;
                    reg_out_en <= 1;
                    dsp_in_en <= 1;
                  end
                endcase
              end
              3 : begin // SET
              end
              4 : begin // CLR
              end
              //...
              14 : begin // INT
              end
              15 : begin // HLT
                halt <= 1;
              end
              default: begin
              end
            endcase
          end
          1 : begin // LLI
            case (counter)
              3: begin
                reg_dst_sel <= funct;
                ctl_out_en <= 1;
                reg_lo_en <= 1;
              end
            endcase
          end
          2 : begin // LUI
              case (counter)
                3 : begin
                  reg_dst_sel <= funct;
                  ctl_out_en <= 1;
                  reg_up_en <= 1;
                end
              endcase
          end
          3 : begin // MEM
            case (funct)
              0 : begin // LD
                case (counter)
                  3 : begin
                    reg_src_sel <= src;
                    reg_dst_sel <= dst;
                    reg_out_en <= 1;
                    reg_in_en <= 1;
                  end
                endcase
              end
              1 : begin // ST
                case (counter)
                  3 : begin
                    reg_src_sel <= dst;
                    reg_dst_sel <= src;
                    reg_out_en <= 1;
                    reg_in_en <= 1;
                  end
                endcase
              end
              2 : begin // LD*
                reg_src_sel <= src;
                reg_dst_sel <= dst;
                case (counter)
                  3 : begin
                    reg_out_en <= 1;
                    mem_addr_en <= 1;
                  end
                  4 : begin
                    mem_out_en <= 1;
                    reg_in_en <= 1;
                  end
                endcase
              end
              3 : begin // ST*
                case (counter)
                  3 : begin
                    reg_src_sel <= src;
                    reg_out_en <= 1;
                    mem_addr_en <= 1;
                  end
                  4 : begin
                    reg_src_sel <= dst;
                    reg_out_en <= 1;
                    mem_in_en <= 1;
                  end
                endcase
              end
            endcase
          end
          4,5,6,7 : begin // Math, Logic, Shift
            alu_opcode <= alu_funct;
            reg_src_sel <= src;
            reg_dst_sel <= dst;
            if (imm) begin
              case (counter)
                3 : begin
                  reg_dst_sel <= RES;
                  ctl_out_en <= 1;
                  reg_in_en <= 1;
                end
                4 : begin
                  reg_src_sel <= RES;
                  reg_dst_sel <= dst;
                  alu_out_en <= 1;
                  reg_in_en <= 1;
                end
              endcase
            end else begin
              if (ind) begin
                case (counter)
                  3 : begin
                    reg_out_en <= 1;
                    mem_addr_en <= 1;
                  end
                  4 : begin
                    reg_dst_sel <= RES;
                    mem_out_en <= 1;
                    reg_in_en <= 1;
                  end
                  5 : begin
                    reg_src_sel <= RES;
                    alu_out_en <= 1;
                    reg_in_en <= 1;
                  end
                endcase
              end else begin
                case (counter)
                  3 : begin
                    alu_out_en <= 1;
                    reg_in_en <= 1;
                  end
                endcase
              end
            end
          end
          8 : begin //JALR
            case (counter)
              3 : begin // store PC
                reg_src_sel <= PC;
                reg_dst_sel <= dst;
                reg_out_en <= 1;
                reg_in_en <= 1;
              end
              4 : begin // Jump to address
                reg_src_sel <= src;
                reg_dst_sel <= PC;
                reg_out_en <= 1;
                reg_in_en <= 1;
              end
            endcase
          end
          9 : begin // BR
            case (counter)
              3 : begin
                reg_src_sel <= src;
                reg_dst_sel <= dst;
                alu_opcode <= SUB; // Subtract
                alu_out_en <= 1;
              end
              4 : begin
                if ((funct == 0 && flags[0]) || // Zero - Equal
                    (funct == 1 && ~flags[0]) || // No Zero - Not Equal
                    (funct == 2 && flags[1]) || // Negative - Greater Than or Equal Unsigned
                    (funct == 3 && ~flags[1]) || // No Negative - Less Than Unsigned
                    (funct == 4 && flags[2]) || // Carry
                    (funct == 5 && ~flags[2]) || // No Carry
                    (funct == 6 && flags[3]) || // Overflow - Greater Than or Equal
                    (funct == 7 && ~flags[3])) begin // No Overflow - Less Than
                      reg_src_sel <= BA; // Branch Address
                      reg_dst_sel <= PC; // Program Counter
                      reg_out_en <= 1;
                      reg_in_en <= 1;
                end
              end
            endcase
          end
          10 : begin // Stack Functions
            case (funct)
              0 : begin // PUSH
                case (counter)
                  3 : begin
                    reg_sp_dec <= 1;
                  end
                  4 : begin
                    reg_src_sel <= SP;
                    reg_out_en <= 1;
                    mem_addr_en <= 1;
                  end
                  5 : begin
                    reg_src_sel <= dst;
                    reg_out_en <= 1;
                    mem_in_en <= 1;
                  end
                endcase
              end
              1 : begin // POP
                case (counter)
                  3 : begin
                    reg_src_sel <= SP;
                    reg_out_en <= 1;
                    mem_addr_en <= 1;
                  end
                  4 : begin
                    mem_out_en <= 1;
                    reg_dst_sel <= dst;
                    reg_in_en <= 1;
                  end
                  5 : begin
                    reg_sp_inc <= 1;
                  end
                endcase
              end
            endcase
          end
        endcase
      end
    endcase
  end
endmodule
