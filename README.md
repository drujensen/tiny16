# Tiny16 Computer

The Tiny16 computer is a 16bit system built on the TinyFPGA B-Series.  The system
has similar capabilites as a C6502 8bit system.

The computer can support 128KB of RAM and has a 16bit bus and instruction set.  memory is 16bit per address location instead of 8bit. This keeps the system 16bit aligned with no special handling.  everything is 16bits.

## Instruction Set Architecture

The system has 16 base opcodes.  This is the first 4 bits of the 16bit fixed width commands.

### System Instructions
 | OPCODE (4) | FUNCT (4) | DEST (4) | SRC (4) | Description |
 |-------|-------|--------|-------|--------------|
 | 0 SYS | 0 NOP | x0:x15 | 0:x15 | No Operation |
 | 0 SYS | 1 IN  | x0:x15 | 0:x15 | input from keyboard |
 | 0 SYS | 2 OUT | x0:x15 | 0:x15 | output to display |
 | 0 SYS | 3 SET | x0:x15 | 0:x15 | set register |
 | 0 SYS | 4 CLR | x0:x15 | 0:x15 | clear register |
 | 0 SYS | 14 INT| x0:x15 | 0:x15 | interrupt handler |
 | 0 SYS | 15 HLT| x0:x15 | 0:x15 | halt cpu |


### Memory Instructions

 | OPCODE (4) | DEST (4) | VAL (8) | Description |
 |-------|---------|-------------|--------------|
 | 1 LLI |  x0:x15 | lower value | Load lower 8 bits |
 | 2 LUI |  x0:x15 | upper value | Load upper 8 bits |

 | OPCODE (4) | FUNCT (4) | DEST (4) | SRC (4) | Description |
 |-------|-------|--------|--------|--------------|
 | 3 MEM | 1 LD  | x0:x15 | x0:x15 | Load from register |
 | 3 MEM | 2 ST  | x0:x15 | x0:x15 | Store to register |
 | 3 MEM | 3 LD* | x0:x15 | x0:x15 | Load from memory |
 | 3 MEM | 4 ST* | x0:x15 | x0:x15 | Store to memory |


### Arithmetic/Logic Instructions

| OPCODE (4) | FUNCT (4) | DEST (3) | SRC (4) | Description |
|------------|---------------|  ---------------|--------------|------------|------------|-------------|
| 4 MATH | 0 ADD | x0:x15 | x0:x15 | Add |
| 4 MATH | 1 SUB | x0:x15 | x0:x15 | Subtract |
| 4 MATH | 2 ADC | x0:x15 | x0:x15 | Add with Carry |
| 4 MATH | 3 SBC | x0:x15 | x0:x15 | Subtract with Carry |
| 5 LOGIC | 0 AND | x0:x15 | x0:x15 | And |
| 5 LOGIC | 1 OR  | x0:x15 | x0:x15 | Or |
| 5 LOGIC | 2 XOR | x0:x15 | x0:x15 | Xor |
| 5 LOGIC | 3 NOT | x0:x15 | x0:x15 | Xor |
| 6 SHIFT | 0 SLA  | x0:x15 | x0:x15 | Shift Left Arithmetic |
| 6 SHIFT | 1 SRA  | x0:x15 | x0:x15 | Shift Right Arithmetic|
| 6 SHIFT | 2 SLL  | x0:x15 | x0:x15 | Shift Left Logical |
| 6 SHIFT | 3 SRL  | x0:x15 | x0:x15 | Shift Right Logical|
| 7 MULT | 0 MLT | x0:x15 | x0:x15 | Multiply |
| 7 MULT | 1 DIV  | x0:x15 | x0:x15 | Divide |
| 7 MULT | 2 MOD | x0:x15 | x0:x15 | Modulus |


### Branch Instructions

* Jump is relative to the current instruction pointer.

| OPCODE (4) | FUNCT (4) | DEST (4) | SRC (4) | Description |
|--------|--------|--------|--------|--------------|
| 8 JUMP | 0 JALR | x0:x15 | x0:x15 | Jump And Link Register |

### Branch Instructions

| OPCODE (4) | FUNCT (4) | DEST (4) | SRC (4) | Description |
|--------|--------|--------|--------|--------------|
| 9 BRANCH | 0 ZS (EQ) | x0:x15 | x0:x15 | Branch if Zero Set |
| 9 BRANCH | 1 ZC (NE) | x0:x15 | x0:x15 | Branch if Zero Clear |
| 9 BRANCH | 2 NS (LT) | x0:x15 | x0:x15 | Branch if Negative Set |
| 9 BRANCH | 3 NC (GE) | x0:x15 | x0:x15 | Branch if Negative Clear |
| 9 BRANCH | 4 CS      | x0:x15 | x0:x15 | Branch if Carry Set |
| 9 BRANCH | 5 CC      | x0:x15 | x0:x15 | Branch if Carry Clear |
| 9 BRANCH | 6 OS      | x0:x15 | x0:x15 | Branch if Overflow Set |
| 9 BRANCH | 7 OC      | x0:x15 | x0:x15 | Branch if Overflow Clear |


## Registers:

| Register | Label | Alias | Description |
|----------|-------|-------|-------------|
| 0 | X0 | ZERO | Always Zero |
| 1 | X1 | PC | Program Counter |
| 2 | X2 | SP | Stack Pointer |
| 3 | X3 | BA | Branch Address |
| 4 | X4 | RA | Return Address |
| 5 | X5 | S0 | Saved 0 |
| 6 | X6 | S1 | Saved 1 |
| 7 | X7 | S2 | Saved 2 |
| 8 |  X8  | A0 | Argument 0 |
| 9 |  X9  | A1 | Argument 1 |
| 10 | X10 | A2 | Argument 2 |
| 11 | X11 | A3 | Argument 3 |
| 12 | X12 | A4 | Argument 4 |
| 13 | X13 | A5 | Argument 5 |
| 14 | X14 | A6 | Argument 6 |
| 15 | X15 | RES | Reserved |

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

