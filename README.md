# fpga-alu-vhdl

8-bit Arithmetic Logic Unit (ALU) implemented in VHDL on an Altera DE2 FPGA board. Features a Moore FSM-controlled sequencer, 4x16 decoder, dual register storage units, and 7-segment display output. Supports 9 arithmetic and logic operations selected automatically via microcode. Designed and simulated in Quartus II.

---

## Overview

This project implements a simple General-Purpose Processor (GPU) on an FPGA. The processor cycles through 9 hardcoded operations sequentially, applying them to two 8-bit inputs A and B and displaying the result on a 7-segment display in hexadecimal format.

The design is broken into 4 main components that mirror a real processor architecture:

- **Control Unit** — FSM + 4x16 decoder that generates the operation selector microcode
- **Storage Unit** — Two 8-bit registers (latches) that hold inputs A and B
- **ALU Core** — Executes the selected operation on A and B
- **Display Unit** — Seven-segment decoders that render the result and student ID on the board

---

## Supported Operations

| Function # | Microcode | Operation |
|------------|-----------|-----------|
| 1 | 0000000000000001 | ADD (A + B) |
| 2 | 0000000000000010 | SUB (A - B) |
| 3 | 0000000000000100 | NOT A |
| 4 | 0000000000001000 | NAND (A, B) |
| 5 | 0000000000010000 | NOR (A, B) |
| 6 | 0000000000100000 | AND (A, B) |
| 7 | 0000000001000000 | XOR (A, B) |
| 8 | 0000000010000000 | OR (A, B) |
| 9 | 0000000100000000 | XNOR (A, B) |

---

## Architecture

```
A[7:0] ──► Latch1 ──►
                      ALU Core ──► Result[7:0] ──► 7-seg Display
B[7:0] ──► Latch2 ──►    ▲
                          │
Clock ──► FSM ──► current_state[3:0] ──► 4x16 Decoder ──► OP[15:0]
           │
           └──► student_id[3:0] ──► 7-seg Display
```

### Components

#### Storage Unit (`latch1.vhd`)
- 8-bit D flip-flop register
- Loads input on rising clock edge
- Active-high synchronous reset
- Two instances used — one for A, one for B

#### FSM (`machine.vhd`)
- Moore finite state machine
- 9 states (s0–s8) cycling sequentially as an up-counter
- Outputs `current_state[3:0]` to the decoder
- Outputs `student_id[3:0]` for 7-segment display
- Active-high reset returns to s0

#### 4x16 Decoder (`dec4to16.vhd`)
- Structural design using two 3x8 decoders (`dec3to8.vhd`)
- Translates `current_state[3:0]` into a 16-bit one-hot `OP` signal
- S3 and its inverse gate each 3x8 decoder's enable

#### ALU Core (`ALU.vhd`)
- Takes 8-bit inputs A, B and 16-bit OP selector
- Clocked on rising edge
- Outputs `R1[3:0]` (lower nibble) and `R2[3:0]` (upper nibble)
- `Neg` flag asserted when subtraction result is negative

#### Seven-Segment Display (`sseg.vhd`, `sseg_modified.vhd`)
- Decodes 4-bit BCD to 7-segment active-low encoding
- Supports full hex display (0–F)
- Modified version adds even parity check on student_id with y/n output

---

## Project Structure

```
fpga-alu-vhdl/
├── src/
│   ├── latch1.vhd          # 8-bit register storage unit
│   ├── machine.vhd         # Moore FSM up-counter
│   ├── dec3to8.vhd         # 3x8 decoder
│   ├── dec4to16.vhd        # 4x16 decoder (structural)
│   ├── ALU.vhd             # ALU core, 9 operations
│   ├── sseg.vhd            # 7-segment decoder (0-F)
│   └── sseg_modified.vhd   # 7-segment + parity y/n output
├── sim/
│   ├── latch1.sim.vwf      # Register simulation waveform
│   ├── dec4to16.sim.vwf    # Decoder simulation waveform
│   ├── ALUcore.sim.vwf     # ALU simulation waveform
│   └── lab6.sim.vwf        # Top-level simulation waveform
├── schematic/
│   └── lab6.bdf            # Top-level block diagram schematic
└── README.md
```

---

## Tools

- **Quartus II 32-bit** (Altera)
- **Target Board:** Altera DE2 (Cyclone II FPGA)
- **Language:** VHDL (IEEE 1164)
- **Simulation:** Quartus II Functional Simulator (VWF)

---

## How It Works

1. On each rising clock edge, the FSM advances one state (s0 → s1 → ... → s8 → s0)
2. `current_state` feeds the 4x16 decoder which asserts the corresponding OP bit
3. The ALU samples OP on the next rising edge and computes the result
4. R1 and R2 (lower and upper nibbles of Result) drive two 7-segment displays
5. The student ID digit for the current state is shown on a third display

The two-cycle pipeline delay (one cycle for the latch, one for the ALU) is expected behavior — results appear one state after the corresponding OP is asserted.

---

## Results

Tested with A = 0x21 (33) and B = 0x34 (52):

| Operation | Expected | Result |
|-----------|----------|--------|
| ADD | 0x55 | ✓ |
| SUB | 0x13, Neg=1 | ✓ |
| NOT A | 0xDE | ✓ |
| NAND | 0xDF | ✓ |
| NOR | 0xCA | ✓ |
| AND | 0x20 | ✓ |
| XOR | 0x15 | ✓ |
| OR | 0x35 | ✓ |
| XNOR | 0xEA | ✓ |
