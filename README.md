# Tiny16 Computer

The Tiny16 computer is a 16bit system built on the TinyFPGA B-Series.  The system
has similar capabilites as a C6502 8bit system.

The computer can support 64KB of RAM and has a 16bit bus and instruction set.

## Instruction Set Architecture

The system has 16 base opcodes.  This is the first 4 bits of the 16bit fixed width commands.

OPCODE (4-bit)
System:
0 SYS

Memory:
1 ST
2 LD

Arithmetic/Logic:
3 ADD
4 SUB
5 MUL
6 DIV
7 AND
8 OR
9 XOR
A SL
B SR

Branch:
C JMP
D JSR
E CMP
F BR

If System:
  SYS CODE (4-bit)
  0 NOP
  1 SET
  2 CLR
  ...
  E BRK
  F HLT

If Memory/Arithmetic/Logic:
  IMMEDIATE (1-bit)
  0 - register
  1 - immediate

  DESTINATION (3-bit)
  x0:x7 - destination register

  IF IMMEDIATE:
    VALUE (8-bit)
    00:FF - value

  ELSE:
    DIRECT (1-bit)
    0 - Indirect - Deref pointer
    1 - Direct

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


