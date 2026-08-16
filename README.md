# 8-bit-Verilog-ALU
Design and verification of an 8-bit combinational ALU using Verilog HDL.

## Overview
* This project implements and verifies an 8-bit combinational Arithmetic Logic Unit (ALU) using Verilog HDL.

* The ALU accepts two 8-bit inputs and a 3-bit operation select signal. Based on the selected operation, it performs arithmetic or bitwise operations and produces an 8-bit result along with Carry and Zero status flags.

* This project was developed as part of my learning journey in Verilog HDL and digital design, with a focus on understanding RTL design, simulation, and functional verification.

---

## Objectives

- Understand the fundamentals of Verilog HDL.
- Design an 8-bit combinational ALU using RTL concepts.
- Implement arithmetic and logic operations.
- Generate Carry and Zero status flags.
- Develop a Verilog testbench for functional verification.
- Verify the design using directed test cases, edge cases, and randomized testing.
- Analyze simulation waveforms using GTKWave.

---

## ALU Features

The ALU supports 8 operations selected using a 3-bit operation code.

| OP Code | Operation | Description |
|--------|-----------|-------------|
| `000` | ADD | A + B |
| `001` | SUB | A - B |
| `010` | AND | A & B |
| `011` | OR | A \| B |
| `100` | XOR | A ^ B |
| `101` | NOT | ~A |
| `110` | INC | A + 1 |
| `111` | DEC | A - 1 |

### Inputs

- `A[7:0]` – First 8-bit operand
- `B[7:0]` – Second 8-bit operand
- `OP[2:0]` – Operation selector

### Outputs

- `Y[7:0]` – 8-bit ALU result
- `Carry` – Indicates carry/borrow condition
- `Zero` – Indicates when the result is zero

---

## Block Diagram

```text
              ──────────────────────
 A[7:0] ────►│                      │
             │                      │
 B[7:0] ────►│       8-bit ALU      ├────► Y[7:0]
             │                      │
 OP[2:0] ───►│                      ├────► Carry
             │                      │
             │                      ├────► Zero
              ──────────────────────
