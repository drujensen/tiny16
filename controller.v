`include "step.v"

module controller (
  input clk,
  input rst,
  input [15:0] in,
  input [3:0] flags,
  output reg [3:0] alu_opcode,
  output reg alu_out_en,
  output reg alu_ar_flag,
  output reg mem_addr_en,
  output reg mem_in_en,
  output reg mem_out_en,
  output reg [2:0] reg_src_sel,
  output reg [2:0] reg_dst_sel,
  output reg reg_in_en,
  output reg reg_out_en,
  output reg reg_pc_inc,
  output reg ctl_out_en,
  output reg dsp_in_en,
  output [15:0] out
);

  wire [2:0] counter;
  reg [15:0] inst;
  reg [3:0] alu_flags;
  wire [3:0] opcode;
  wire [3:0] syscode;
  wire [2:0] dst;
  wire imm;
  wire ind;
  wire [2:0] src;
  wire [3:0] off;

  assign opcode = inst[15:12];
  assign syscode = inst[11:8];
  assign imm = inst[11];
  assign dst = inst[10:8];
  assign ind = inst[7];
  assign src = inst[6:4];
  assign off = inst[3:0];
  assign out = (opcode == 12 || opcode == 13) ? inst[11:0] : inst[7:0];

  wire step_reset;
  reg halt = 0;

  assign step_reset = (counter == 4) ? 1 : 0;

  step step (
   .clk(clk),
   .rst(rst | halt),
   .step_reset(step_reset),
   .counter(counter)
  );

  always @(negedge clk) begin
    // Reset all signals
    alu_opcode <= 4'b0000;
    alu_out_en <= 0;
    alu_ar_flag <= 0;
    mem_addr_en <= 0;
    mem_in_en <= 0;
    mem_out_en <= 0;
    reg_src_sel <= 3'b000;
    reg_dst_sel <= 3'b000;
    reg_in_en <= 0;
    reg_out_en <= 0;
    reg_pc_inc <= 0;
    ctl_out_en <= 0;
    dsp_in_en <= 0;

    case (counter)
      0 : begin
        inst <= 16'h0000;
        reg_src_sel <= 3'b000; //program counter
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
            case (syscode)
              0 : begin // NOP
              end
              1 : begin // IN
              end
              2 : begin // OUT
                reg_src_sel <= src;
                if (ind) begin
                  case (counter)
                    3 : begin
                      reg_out_en <= 1;
                      mem_addr_en <= 1;
                    end
                    4 : begin
                      mem_out_en <= 1;
                      dsp_in_en <= 1;
                    end
                  endcase
                end else begin
                  reg_out_en <= 1;
                  dsp_in_en <= 1;
                end
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
          1 : begin // LD
            reg_src_sel <= src;
            reg_dst_sel <= dst;
            if (imm) begin
              case (counter)
                3: begin
                  ctl_out_en <= 1;
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
                    mem_out_en <= 1;
                    reg_in_en <= 1;
                  end
                endcase
              end else begin
                case (counter)
                  3 : begin
                    reg_out_en <= 1;
                    reg_in_en <= 1;
                  end
                endcase
              end
            end
          end
          2 : begin // ST
            reg_src_sel <= dst;
            reg_dst_sel <= src;
          end
          3,4,5,6,7,8,9 : begin // Math and Logic
            reg_src_sel <= src;
            reg_dst_sel <= dst;
            alu_opcode <= opcode;
            if (imm) begin
              reg_src_sel <= 3'b111;
              case (counter)
                3 : begin
                  ctl_out_en <= 1;
                  reg_in_en <= 1;
                end
                4 : begin
                  alu_out_en <= 1;
                  reg_in_en <= 1;
                end
              endcase
            end else begin
              if (ind) begin
                reg_src_sel <= 3'b111;
                case (counter)
                  3 : begin
                    reg_out_en <= 1;
                    mem_addr_en <= 1;
                  end
                  4 : begin
                    alu_out_en <= 1;
                    reg_in_en <= 1;
                  end
                endcase
              end else begin
                case (counter)
                  3: begin
                    alu_out_en <= 1;
                    reg_in_en <= 1;
                  end
                endcase
              end
            end
          end
          10,11 : begin // Shift and Rotate
            reg_src_sel <= src;
            reg_dst_sel <= dst;
            alu_opcode <= opcode;
            alu_ar_flag <= imm;
            if (ind) begin
              reg_src_sel <= 3'b111;
              case (counter)
                3 : begin
                  reg_out_en <= 1;
                  mem_addr_en <= 1;
                end
                4 : begin
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
          12 : begin // JMP
            case (counter)
              3 : begin
                ctl_out_en <= 1;
                reg_dst_sel <= 3'b000;
                reg_in_en <= 1;
              end
            endcase
          end
          13 : begin // JSR
            case (counter)
              3 : begin
                reg_src_sel <= 3'b000;
                reg_out_en <= 1;
                reg_dst_sel <= 3'b001;
                reg_in_en <= 1;
              end
              4 : begin
                ctl_out_en <= 1;
                reg_dst_sel <= 3'b000;
                reg_in_en <= 1;
              end
            endcase
          end
          14 : begin // CMP
            reg_src_sel <= src;
            reg_dst_sel <= dst;
            alu_opcode <= 4'b0100;
            if (imm) begin
              case (counter)
                3 : begin
                  ctl_out_en <= 1;
                  reg_src_sel <= 3'b111;
                  reg_in_en <= 1;
                end
                4 : begin
                  alu_out_en <= 1;
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
                    mem_out_en <= 1;
                    reg_src_sel <= 3'b111;
                    reg_in_en <= 1;
                  end
                  5 : begin
                    alu_out_en <= 1;
                  end
                endcase
              end else begin
                case (counter)
                  3 : begin
                    alu_out_en <= 1;
                  end
                endcase
              end
            end
          end
          15 : begin // BR
            if ((dst == 0 && flags[3]) ||
                (dst == 1 && ~flags[3]) ||
                (dst == 2 && flags[2]) ||
                (dst == 3 && ~flags[2]) ||
                (dst == 4 && flags[1]) ||
                (dst == 5 && ~flags[1]) ||
                (dst == 6 && flags[0]) ||
                (dst == 7 && ~flags[0])) begin
                reg_src_sel <= src;
                reg_dst_sel <= 3'b000;
                if (imm) begin
                  case (counter)
                    3 : begin
                      ctl_out_en <= 1;
                      reg_in_en <= 1;
                    end
                  endcase
                end else if (ind) begin
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
                end else begin
                  case (counter)
                    3 : begin
                      reg_out_en <= 1;
                      reg_in_en <= 1;
                    end
                  endcase
                end
            end
          end
        endcase
      end
    endcase
  end
endmodule
