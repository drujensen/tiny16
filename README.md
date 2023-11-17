# Tiny16 Computer

The Tiny16 computer is a 16bit system built on the TinyFPGA B-Series.  The system
has similar capabilites as a C6502 8bit system.

The computer can support 128KB of RAM and has a 16bit bus and instruction set.  memory is 16bit per address location instead of 8bit. This keeps the system 16bit aligned with no special handling.  everything is 16bits.

## Instruction Set Architecture

The system has 16 base opcodes.  This is the first 4 bits of the 16bit fixed width commands.

### System Instructions
 | OPCODE (4) | SYSCODE (4) | Description |
 | 0 SYS | 0 NOP | No Operation |
 | 0 SYS | 1 IN  | input from keyboard |
 | 0 SYS | 2 OUT | output to display |
 | 0 SYS | 3 SET | set register |
 | 0 SYS | 4 CLR | clear register |
 | 0 SYS | 13 RET | return from JSR subroutine |
 | 0 SYS | 14 INT | interrupt handler |
 | 0 SYS | 15 HLT | halt cpu |


### Memory Instructions
| OPCODE (4) | DESTINATION (3) | IMMEDIATE (1) | INDIRECT (1) | SOURCE (3) | OFFSET (4) | Description |
| 1 LD | x0:x7 | 0 | 0 | x0:x7 | 0:F | Load from memory |
| 2 ST | x0:x7 | 0 | 0 | x0:x7 | 0:F | Store to memory |

### Immediate Instructions
| OPCODE (4) | DESTINATION (3) | IMMEDIATE (1) | VALUE (8) | Description |
| 1 LDI | x0:x7 | 1 | 00:FF | Load from memory |

### Arithmetic/Logic Instructions
| OPCODE (4) | DESTINATION (3) | IMMEDIATE (1) | INDIRECT (1) | SOURCE (3) | OFFSET (4) | Description |
| 3 ADD | x0:x7 | 0 | 0 | x0:x7 | 0:F | Add |
| 4 SUB | x0:x7 | 0 | 0 | x0:x7 | 0:F | Subtract |
| 5 MULT | x0:x7 | 0 | 0 | x0:x7 | 0:F | Multiply |
| 6 DIV | x0:x7 | 0 | 0 | x0:x7 | 0:F | Divide |
| 7 AND | x0:x7 | 0 | 0 | x0:x7 | 0:F | And |
| 8 OR | x0:x7 | 0 | 0 | x0:x7 | 0:F | Or |
| 9 XOR | x0:x7 | 0 | 0 | x0:x7 | 0:F | Xor |
| A SL | x0:x7 | 0 | 0 | x0:x7 | 0:F | Shift Left |
| B SR | x0:x7 | 0 | 0 | x0:x7 | 0:F | Shift Right |

### Immediate Instructions
| OPCODE (4) | DESTINATION (3) | IMMEDIATE (1) | VALUE (8) | Description |
| 3 ADDI | x0:x7 | 1 | 00:FF | Add |
| 4 SUBI | x0:x7 | 1 | 00:FF | Subtract |
| 5 MULTI | x0:x7 | 1 | 00:FF | Multiply |
| 6 DIVI | x0:x7 | 1 | 00:FF | Divide |
| 7 ANDI | x0:x7 | 1 | 00:FF | And |
| 8 ORI | x0:x7 | 1 | 00:FF | Or |
| 9 XORI | x0:x7 | 1 | 00:FF | Xor |
| A SLI | x0:x7 | 1 | 00:FF | Shift Left |
| B SRI | x0:x7 | 1 | 00:FF | Shift Right |


### Branch Instructions
| OPCODE (4) | ADDRESS (12) | Description |
| C JMP | 000:8FF | Jump |
| D JSR | 000:8FF | Jump to Subroutine |

### Compare Instructions
| OPCODE (4) | DESTINATION (3) | IMMEDIATE (1) | INDIRECT (1) | SOURCE (3) | OFFSET (4) | Description |
| E CMP | x0:x7 | 0 | 0 | x0:x7 | 0:F | Compare |

### Immediate Instructions
| OPCODE (4) | DESTINATION (3) | IMMEDIATE (1) | VALUE (8) | Description |
| E CMPI | x0:x7 | 1 | 00:FF | Compare |

### Branch Instructions
| OPCODE (4) | COMPARATOR (3) | IMMEDIATE (1) | INDIRECT (1) | SOURCE (3) | OFFSET (4) | Description |
| F BR | 0 ZS (EQ) | 0 | 0 | x0:x7 | 0:F | Branch if Zero Set |
| F BR | 1 ZC (NE) | 0 | 0 | x0:x7 | 0:F | Branch if Zero Clear |
| F BR | 2 NS (LT) | 0 | 0 | x0:x7 | 0:F | Branch if Negative Set |
| F BR | 3 NC (GE) | 0 | 0 | x0:x7 | 0:F | Branch if Negative Clear |
| F BR | 4 CS      | 0 | 0 | x0:x7 | 0:F | Branch if Carry Set |
| F BR | 5 CC      | 0 | 0 | x0:x7 | 0:F | Branch if Carry Clear |
| F BR | 6 OS      | 0 | 0 | x0:x7 | 0:F | Branch if Overflow Set |
| F BR | 7 OC      | 0 | 0 | x0:x7 | 0:F | Branch if Overflow Clear |

### Immediate Instructions
| OPCODE (4) | COMPARATOR (3) | IMMEDIATE (1) | VALUE (8) | Description |
| F BRI | 0 ZS (EQ) | 1 | 00:FF | Branch if Zero Set |
| F BRI | 1 ZC (NE) | 1 | 00:FF | Branch if Zero Clear |
| F BRI | 2 NS (LT) | 1 | 00:FF | Branch if Negative Set |
| F BRI | 3 NC (GE) | 1 | 00:FF | Branch if Negative Clear |
| F BRI | 4 CS      | 1 | 00:FF | Branch if Carry Set |
| F BRI | 5 CC      | 1 | 00:FF | Branch if Carry Clear |
| F BRI | 6 OS      | 1 | 00:FF | Branch if Overflow Set |
| F BRI | 7 OC      | 1 | 00:FF | Branch if Overflow Clear |

* Indirect instructions use the value in the source register as the address to load the value from.

## Registers:

| Register | Label | Description |
| 0 | x0 | (PC) Program Counter |
| 1 | x1 | (SP) Stack Pointer |
| 2 | x2 | Argument 1 |
| 3 | x3 | Argument 2 |
| 4 | x4 | Argument 3 |
| 5 | x5 | Argument 4 |
| 6 | x6 | Argument 5 |
| 7 | x7 | Argument 6 (volatile)|

## Setup

Install [icestorm](http://www.clifford.at/icestorm/) for your computer once:

```sh
sudo apt-get install build-essential clang bison flex libreadline-dev \
                     gawk tcl-dev libffi-dev git mercurial graphviz   \
                     xdot pkg-config python python3 libftdi-dev


git clone https://github.com/cliffordwolf/icestorm.git icestorm
cd icestorm
make -j$(nproc)
sudo make install
cd ..

git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
make -j$(nproc)
sudo make install
cd ..

git clone https://github.com/cliffordwolf/yosys.git yosys
cd yosys
make -j$(nproc)
sudo make install
cd ..

pip install --user tinyprog
```

## Build

Build the project:
```shell
make clean
make build
```

## Test

Run the testbench:
```shell
make test
open tiny16.vcd
```

## Install

Install on the board:
```shell
make prog
```

