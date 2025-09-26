# Baccarat Digital Circuit  
**SystemVerilog Implementation – Datapath & State Machine**  

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Datapath](#datapath)
- [State Machine](#state-machine)
- [Score Computation](#score-computation)
- [Verification](#verification)
- [Key Results](#key-results)

---

## Overview  

This project implements a fully functional Baccarat game engine on FPGA using SystemVerilog, synthesizable for the Intel DE1-SoC board.  

The design uses a modular hierarchical approach separating:
- Datapath  
- State machine  
- Card scoring logic  
- Random card generation  

The implementation follows ready/enable protocols, ensuring deterministic hardware execution and single-cycle state transitions.  

---

## Architecture  

The design consists of three primary components:  

- Datapath – Handles card storage, score computation inputs, and display data flow  
- State Machine – Controls card dealing sequence and game logic according to Baccarat rules  
- Score Computation – Computes hand totals modulo 10, following Baccarat’s point system  

Together, these components produce correct results cycle-by-cycle, with no idle states and minimal latency.

---

## Datapath  

The datapath stores card values, updates HEX display outputs, and feeds scores into the control logic.  
It includes:  

- Register bank – Three 4-bit registers for the player/dealer (six total), storing cards dealt sequentially  
- Card loader – Synchronous logic that loads cards into registers on state machine enable  
- Display driver – Drives HEX outputs to show card values in real time  

Example register load logic:  

```SystemVerilog
always_ff @(posedge clk) begin  
  if (~rst_n)  
    pcard1 <= 4'b0;  
  else if (load_pcard1)  
    pcard1 <= dealcard_out;  
end  
```

This approach provides predictable timing, allowing easy waveform verification and simplifying post-synthesis debug.

---

## State Machine  

The state machine acts as the controller for the game.  
It:  

- Alternates card deals between player and dealer  
- Computes whether a third card is needed (player and banker rules)  
- Determines the winner and asserts result signals  

The FSM advances one card per clock cycle, ensuring minimum-cycle execution with no filler states.  

Main states include:  

- RESET / INIT – Clear registers and scores  
- DEAL_P1 / DEAL_P2 / DEAL_D1 / DEAL_D2 – Sequentially deal first two cards  
- EVALUATE – Decide if a third card is required  
- DEAL_P3 / DEAL_D3 – Issue additional cards if needed  
- RESULT – Compute winner and drive LEDs  

---

## Score Computation  

Scoring is implemented as a purely combinational block:  

```SystemVerilog
hand_score = (card1_value + card2_value + card3_value) % 10  
```

This guarantees single-cycle calculation and immediate score updates after each card load.

---

## Verification  

Verification was performed using:  

- RTL testbenches for card7seg, datapath, scorehand, statemachine, and top-level  
- Assertions to check register loads, state transitions, and card sequencing  
- ModelSim waveforms for visual confirmation of datapath behavior  
- Post-synthesis simulation to ensure functional equivalence after Quartus compilation  

This resulted in 100% statement and branch coverage, giving high confidence in design correctness.  

---

## Key Results  

- Implemented a synthesizable Baccarat game with deterministic behavior  
- Achieved cycle-accurate card dealing with no wasted states  
- Scored hands and displayed values in real time  
- Verified using RTL and post-synthesis simulations, achieving full coverage  
- Designed for easy debugging using assertions and waveform inspection

---
