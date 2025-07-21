# FIR Filter FPGA Project (Vitis HLS + Vivado)

## 📌 Project Overview
This project demonstrates the implementation of a **Finite Impulse Response (FIR) filter** on FPGA using the **AXI interface**.  
The full flow covers writing FIR logic in C (Vitis HLS), exporting RTL, integrating with Vivado Block Design, and verifying functionality through simulation.

## 📝 Workflow

### 1. Vitis HLS
- Developed `fir_2.c`, `fir.h`, and `fir_test.c`
- ✅ Performed **C Simulation (csim)** and **Co-Simulation (cosim)**
- ✅ **Exported RTL (Verilog)**

### 2. Vivado
- ✅ Imported the **FIR IP** generated from Vitis HLS into **Vivado Block Design**
- ✅ Connected **AXI4-Lite interface** and configured address mapping using **Address Editor**
- ✅ Added auto-generated files: `fir.v`, `fir_axi.v`
- ✅ Created `tb_fir.v` to **verify timing and waveforms**

## 💻 Development Environment
- **Board:** Digilent Zynq-7000 series
- **FPGA Device:** `xc7z020clg400-1`
- **Toolchain:** Vitis HLS, Vivado

## 💡 Purpose
- Verify the **AXI4-Lite interface** functionality
- Validate **RTL timing and behavior** of the FIR filter
- Learn the end-to-end FPGA design process from **C → RTL → Vivado → Simulation**

## 📊 Simulation Results
Timing diagram and waveform verification results:

<img width="1572" height="486" alt="image" src="https://github.com/user-attachments/assets/4b065759-c4e0-451f-9d10-f2b7e401454a" />



