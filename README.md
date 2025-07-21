# FIR_zynqz7

FIR Filter FPGA Project (Vitis HLS + Vivado)
📌 Project Overview
This project demonstrates the implementation of a Finite Impulse Response (FIR) filter on FPGA using AXI interface.
The complete flow includes writing FIR logic in C (Vitis HLS), exporting RTL, integrating into Vivado Block Design, and verifying functionality through simulation.

📝 Workflow
1. Vitis HLS
Developed fir_2.c, fir.h, and fir_test.c

✅ Performed C Simulation (csim) and Co-Simulation (cosim)

✅ Exported RTL (Verilog)

2. Vivado
✅ Added the FIR IP generated from Vitis HLS to Vivado Block Design

✅ Connected AXI interface and performed address mapping in Address Editor

✅ Used auto-generated files like fir.v, fir_axi.v

✅ Created tb_fir.v to verify timing and waveforms

💡 Purpose
Validate AXI4-Lite interface operation

Verify RTL timing and functionality of the FIR filter

Learn the end-to-end process from C → RTL → Vivado Integration → Simulation

