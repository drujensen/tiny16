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
  output reg [15:0] out
);

  wire [2:0] counter;
  reg [15:0] in_reg;
  reg [3:0] alu_flags;
  reg [3:0] opcode;
  reg [11:0] jmpdst;
  reg [3:0] syscode;
  reg [8:0] val;
  reg imm;
  reg [2:0] dst;
  reg ind;
  reg [2:0] src;
  reg [4:0] off;

  reg step_reset = 0;

  step step (
   .clk(clk),
   .rst(rst || step_reset),
   .counter(counter)
  );

  always @(posedge clk) begin
    // Reset all signals
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
    out = 16'hZZZZ;

    case (counter)
      0 : begin
        mem_addr_en = 1;
        reg_src_sel = 3'b000;
        reg_out_en = 1;
      end
      1 : begin
        mem_out_en = 1;
        opcode = in[15:12];
        syscode = in[11:8];
        jmpdst = in[11:0];
        dst = in[11:9];
        imm = in[8];
        val = in[7:0];
        ind = in[7];
        src = in[6:4];
        off = in[3:0];
      end
      default: begin
        case (opcode)
          0 : begin // SYS
            case (syscode)
              0 : begin // NOP
                step_reset = 1;
              end
              1 : begin // IN
                step_reset = 1;
              end
              2 : begin // OUT
                step_reset = 1;
              end
              3 : begin // PUSH
                step_reset = 1;
              end
              4 : begin // POP
                step_reset = 1;
              end
              //...
              14 : begin // INT
                step_reset = 1;
              end
              15 : begin // HLT
                step_reset = 1;
              end
              default: begin
                step_reset = 1;
              end
            endcase
          end
          1 : begin // LD
            reg_src_sel = src;
            reg_dst_sel = dst;
            if (imm) begin
              out = val;
              reg_in_en = 1;
              step_reset = 1;
            end else begin
              if (ind) begin
                case (counter)
                  2 : begin
                    mem_addr_en = 1;
                    reg_out_en = 1;
                  end
                  3 : begin
                    mem_out_en = 1;
                    reg_in_en = 1;
                    step_reset = 1;
                  end
                endcase
              end else begin
                reg_out_en = 1;
                reg_in_en = 1;
                step_reset = 1;
              end
            end
          end
          2 : begin // ST
            reg_src_sel = dst;
            reg_dst_sel = src;
            step_reset = 1;
          end
          3,4,5,6,7,8,9 : begin // Math and Logic
            reg_src_sel = src;
            reg_dst_sel = dst;
            if (imm) begin
              case (counter)
                2 : begin
                  out = val;
                  reg_in_en = 1;
                  reg_src_sel = 3'b111;
                end
                3 : begin
                  alu_opcode = opcode;
                  alu_out_en = 1;
                  reg_in_en = 1;
                  step_reset = 1;
                end
              endcase
            end else begin
              if (ind) begin
                case (counter)
                  2 : begin
                    mem_addr_en = 1;
                    reg_out_en = 1;
                  end
                  3 : begin
                    mem_out_en = 1;
                    reg_src_sel = 3'b111;
                    reg_in_en = 1;
                  end
                  4: begin
                    alu_opcode = opcode;
                    alu_out_en = 1;
                    reg_in_en = 1;
                    step_reset = 1;
                  end
                endcase
              end else begin
                alu_opcode = opcode;
                alu_out_en = 1;
                reg_in_en = 1;
                step_reset = 1;
              end
            end
          end
          10,11 : begin // Shift and Rotate
            reg_src_sel = src;
            reg_dst_sel = dst;
            if (ind) begin
              case (counter)
                2 : begin
                  mem_addr_en = 1;
                  reg_out_en = 1;
                end
                3 : begin
                  mem_out_en = 1;
                  reg_src_sel = 3'b111;
                  reg_in_en = 1;
                end
                4 : begin
                  alu_opcode = opcode;
                  alu_ar_flag = imm;
                  alu_out_en = 1;
                  reg_in_en = 1;
                  step_reset = 1;
                end
              endcase
            end else begin
              alu_opcode = opcode;
              alu_ar_flag = imm;
              alu_out_en = 1;
              reg_in_en = 1;
              step_reset = 1;
            end
          end
          12 : begin // JMP
            out = jmpdst[11:0];
            reg_dst_sel = 3'b000;
            reg_in_en = 1;
            step_reset = 1;
          end
          13 : begin // JSR
            case (counter)
              2 : begin
                reg_src_sel = 3'b000;
                reg_out_en = 1;
                reg_dst_sel = 3'b001;
                reg_in_en = 1;
              end
              3 : begin
                out = jmpdst[11:0];
                reg_dst_sel = 3'b000;
                reg_in_en = 1;
                step_reset = 1;
              end
            endcase
          end
          14 : begin // CMP
            reg_src_sel = src;
            reg_dst_sel = dst;
            alu_opcode = 4'b0100;
            if (imm) begin
              case (counter)
                2 : begin
                  out = val;
                  reg_in_en = 1;
                  reg_src_sel = 3'b111;
                end
                3 : begin
                  alu_out_en = 1;
                  step_reset = 1;
                end
              endcase
            end else begin
              if (ind) begin
                case (counter)
                  2 : begin
                    mem_addr_en = 1;
                    reg_out_en = 1;
                  end
                  3 : begin
                    mem_out_en = 1;
                    reg_src_sel = 3'b111;
                    reg_in_en = 1;
                  end
                  4 : begin
                    alu_out_en = 1;
                    step_reset = 1;
                  end
                endcase
              end else begin
                alu_out_en = 1;
                step_reset = 1;
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
                reg_src_sel = src;
                reg_dst_sel = 3'b000;
                if (imm) begin
                  out = val;
                  reg_in_en = 1;
                  step_reset = 1;
                end else if (ind) begin
                  case (counter)
                    2 : begin
                      mem_addr_en = 1;
                      reg_out_en = 1;
                    end
                    3 : begin
                      mem_out_en = 1;
                      reg_in_en = 1;
                      step_reset = 1;
                    end
                  endcase
                end else begin
                  reg_in_en = 1;
                  reg_out_en = 1;
                  step_reset = 1;
                end
            end
          end
          default: begin
            step_reset = 1;
          end
        endcase
      end
    endcase
  end
endmodule
