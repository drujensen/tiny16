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
 | 0 SYS | 14 INT | interrupt handler |
 | 0 SYS | 15 HLT | halt cpu |


### Memory Instructions
1 ST
2 LD

### Arithmetic/Logic Instructions
3 ADD
4 SUB
5 MUL
6 DIV
7 AND
8 OR
9 XOR
A SL
B SR

### Branch Instructions
C JMP
D JSR
E CMP
F BR


If Memory/Arithmetic/Logic:
  
  DESTINATION (3-bit)
  x0:x7 - destination register

  IMMEDIATE (1-bit)
  0 - register
  1 - immediate

  IF IMMEDIATE:
    VALUE (8-bit)
    00:FF - value

  ELSE:
    DIRECT (1-bit)
    0 - Direct
    1 - Indirect - Deref pointer

    SOURCE (3-bt)
    x0:x7 - Register

    OFFSET (4-bit)
    0:F - value

If Branch Instructions:
  IF JMP or JSR:
    IF IMM:
      000:8FF - Immediate (11-bit)
    ELSE:
      x0:x7 - Register (3-bit)
      00:FF - Offset (8-bit)

  IF CMP:
    Same as Memory

  IF BR:
    Same as Memory but replace 3-bit destination:
    COMPARATOR (3-bit):
    0 ZS (EQ) - Zero Set
    1 ZC (NE) - Zero Clear
    2 NS (LT) - Negative Set
    3 NC (GE) - Negative Clear
    4 CS      - Carry Set
    5 CC      - Carry Clear
    6 OS      - Overflow Set
    7 OC      - Overflow Clear


Registers:
0 - x0 (PC)
1 - x1 (SP)
2 - x2 a0 A
3 - x3 a1 B
4 - x4 a2 C
5 - x5 a3 X
6 - x6 a4 Y
7 - x7 a5 Z

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
make
```

## Install

Install on the board:
```shell
make prog
```


