# Tiny16 Computer

The Tiny16 computer is a 16bit system built on the TinyFPGA B-Series.  The system
has similar capabilites as a C6502 8bit system.

The computer can support 128KB of RAM and has a 16bit bus and instruction set.  memory is 16bit per address location instead of 8bit. This keeps the system 16bit aligned with no special handling.  everything is 16bits.

## Instruction Set Architecture

The system has 16 base opcodes.  This is the first 4 bits of the 16bit fixed width commands.

### System Instructions
 | OPCODE (4) | SYSCODE (4) | Description |
 |------------|-------------|-------------|
 | 0 SYS | 0 NOP  | No Operation |
 | 0 SYS | 1 IN   | input from keyboard |
 | 0 SYS | 2 OUT  | output to display |
 | 0 SYS | 3 SET  | set register |
 | 0 SYS | 4 CLR  | clear register |
 | 0 SYS | 13 RET | return from JSR subroutine |
 | 0 SYS | 14 INT | interrupt handler |
 | 0 SYS | 15 HLT | halt cpu |


### Memory Instructions

| OPCODE (4) | IMMEDIATE (1) | DESTINATION (3) | INDIRECT (1) | SOURCE (3) | OFFSET (4) | Description |
|------------|---------------|  ---------------|---------------|-----------|------------|-------------|
| 1 LD | 0 | x0:x7 | 0 | x0:x7 | 0:F | Load from memory |
| 2 ST | 0 | x0:x7 | 0 | x0:x7 | 0:F | Store to memory |

#### Immediate Instructions

| OPCODE (4) | IMMEDIATE (1) | DESTINATION (3) | VALUE (8) | Description |
|------------|---------------|-----------------|-----------|-------------|
| 1 LDI | 1 | x0:x7 | 00:FF | Load from memory |

### Arithmetic/Logic Instructions

| OPCODE (4) | IMMEDIATE (1) | DESTINATION (3) | INDIRECT (1) | SOURCE (3) | OFFSET (4) | Description |
|------------|---------------|  ---------------|--------------|------------|------------|-------------|
| 3 ADD  | 0 | x0:x7 | 0 | x0:x7 | 0:F | Add |
| 4 SUB  | 0 | x0:x7 | 0 | x0:x7 | 0:F | Subtract |
| 5 MULT | 0 | x0:x7 | 0 | x0:x7 | 0:F | Multiply |
| 6 DIV  | 0 | x0:x7 | 0 | x0:x7 | 0:F | Divide |
| 7 AND  | 0 | x0:x7 | 0 | x0:x7 | 0:F | And |
| 8 OR   | 0 | x0:x7 | 0 | x0:x7 | 0:F | Or |
| 9 XOR  | 0 | x0:x7 | 0 | x0:x7 | 0:F | Xor |
| A SL   | 0 | x0:x7 | 0 | x0:x7 | 0:F | Shift Left |
| B SR   | 0 | x0:x7 | 0 | x0:x7 | 0:F | Shift Right |

#### Immediate Instructions

| OPCODE (4) | IMMEDIATE (1) | DESTINATION (3) | VALUE (8) | Description |
|------------|---------------|-----------------|-----------|-------------|
| 3 ADDI  | 1 | x0:x7 | 00:FF | Add |
| 4 SUBI  | 1 | x0:x7 | 00:FF | Subtract |
| 5 MULTI | 1 | x0:x7 | 00:FF | Multiply |
| 6 DIVI  | 1 | x0:x7 | 00:FF | Divide |
| 7 ANDI  | 1 | x0:x7 | 00:FF | And |
| 8 ORI   | 1 | x0:x7 | 00:FF | Or |
| 9 XORI  | 1 | x0:x7 | 00:FF | Xor |
| A SLI   | 1 | x0:x7 | 00:FF | Shift Left |
| B SRI   | 1 | x0:x7 | 00:FF | Shift Right |


### Branch Instructions

* Jump is relative to the current instruction pointer.

| OPCODE (4) | DIRECTION (1) | DISTANCE (11) | Description |
|------------|---------------|---------------|-------------|
| C JMP | 0 | 000:4FF | Jump |
| D JSR | 0 | 000:4FF | Jump to Subroutine |

### Compare Instructions

| OPCODE (4) | IMMEDIATE (1) | DESTINATION (3) | INDIRECT (1) | SOURCE (3) | OFFSET (4) | Description |
|------------|---------------|-----------------|--------------|------------|------------|-------------|
| E CMP | 0 | x0:x7 | 0 | x0:x7 | 0:F | Compare |

#### Immediate Instructions

| OPCODE (4) | IMMEDIATE (1) | DESTINATION (3) | VALUE (8) | Description |
|------------|---------------|-----------------|-----------|-------------|
| E CMPI | 1 | x0:x7 | 00:FF | Compare |

### Branch Instructions

| OPCODE (4) | IMMEDIATE (1) | COMPARATOR (3) | INDIRECT (1) | SOURCE (3) | OFFSET (4) | Description |
|------------|---------------|----------------|--------------|------------|------------|-------------|
| F BR | 0 | 0 ZS (EQ) | 0 | x0:x7 | 0:F | Branch if Zero Set |
| F BR | 0 | 1 ZC (NE) | 0 | x0:x7 | 0:F | Branch if Zero Clear |
| F BR | 0 | 2 NS (LT) | 0 | x0:x7 | 0:F | Branch if Negative Set |
| F BR | 0 | 3 NC (GE) | 0 | x0:x7 | 0:F | Branch if Negative Clear |
| F BR | 0 | 4 CS      | 0 | x0:x7 | 0:F | Branch if Carry Set |
| F BR | 0 | 5 CC      | 0 | x0:x7 | 0:F | Branch if Carry Clear |
| F BR | 0 | 6 OS      | 0 | x0:x7 | 0:F | Branch if Overflow Set |
| F BR | 0 | 7 OC      | 0 | x0:x7 | 0:F | Branch if Overflow Clear |

#### Immediate Instructions

* Immediate branching is relative distance from the current instruction pointer.

| OPCODE (4) | IMMEDIATE (1) | COMPARATOR (3) | DIRECTION (1) | DISTANCE (7) | Description |
|------------|---------------|----------------|---------------|--------------|-------------|
| F BRI | 1 | 0 ZS (EQ) | 0 | 00:8F | Branch if Zero Set |
| F BRI | 1 | 1 ZC (NE) | 0 | 00:8F | Branch if Zero Clear |
| F BRI | 1 | 2 NS (LT) | 0 | 00:8F | Branch if Negative Set |
| F BRI | 1 | 3 NC (GE) | 0 | 00:8F | Branch if Negative Clear |
| F BRI | 1 | 4 CS      | 0 | 00:8F | Branch if Carry Set |
| F BRI | 1 | 5 CC      | 0 | 00:8F | Branch if Carry Clear |
| F BRI | 1 | 6 OS      | 0 | 00:8F | Branch if Overflow Set |
| F BRI | 1 | 7 OC      | 0 | 00:8F | Branch if Overflow Clear |

* Indirect instructions use the value in the source register as the address in memory to load the value from.
* Offset is added after the value is loaded from memory.

## Registers:

| Register | Label | Description |
|----------|-------|-------------|
| 0 | x0 | (PC) Program Counter |
| 1 | x1 | (SP) Stack Pointer |
| 2 | x2 | Argument 1 |
| 3 | x3 | Argument 2 |
| 4 | x4 | Argument 3 |
| 5 | x5 | Argument 4 |
| 6 | x6 | Argument 5 |
| 7 | x7 | Reserved (used for imm/ind instructions)|

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

