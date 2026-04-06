# Rsa-Axi4lite-hardware-accelerator
AXI4-Lite interface RSA hardware accelerator for safe SoC integration (Verilog, Vivado, Cadence Genus)

# Overview

This project presents the **VLSI implementation of a 128-bit RSA hardware accelerator** integrated using the **AMBA AXI4-Lite interface** for seamless System-on-Chip (SoC) communication. The design is implemented in **Verilog HDL** and synthesized using **Cadence Genus** and **Xilinx Vivado**, demonstrating efficient hardware-based cryptographic processing for embedded systems.

# Key Features

* 128-bit RSA Encryption & Decryption
* AXI4-Lite Slave Interface (Memory-Mapped Communication)
* Modular Exponentiation using the Square-and-Multiply Algorithm
* Optimized Arithmetic using Montgomery Multiplication
* Fully synthesizable RTL design
* Verified using testbench and waveform analysis
* Suitable for SoC and FPGA-based integration

# Architecture

The system consists of the following major blocks:

* **AXI4-Lite Slave Interface** – Enables processor communication
* **Control & Status Registers (CSR)** – Handles configuration and monitoring
* **RSA Core** – Performs encryption and decryption
* **Modular Arithmetic Engine** – Executes multiplication and reduction

![Architecture](docs/architecture.png)

# Working Flow

1. Processor writes plaintext, key, and modulus via AXI4-Lite registers
2. START signal is asserted through the control register
3. RSA core performs modular exponentiation
4. DONE flag is set upon completion
5. Result is read back through AXI interface

# Results

#  Performance Metrics

| Metric                    | Value      |
| ------------------------- | ---------- |
| Target Frequency          | 200 MHz    |
| Achieved Frequency        | 176.68 MHz |
| Critical Path Delay       | 5.6595 ns  |
| Power                     | 0.02145 W  |
| Power Delay Product (PDP) | 121.4 pJ   |

#  Area Metrics

| Metric     | Value         |
| ---------- | ------------- |
| Cell Area  | 152212.57 µm² |
| Total Area | 199046.35 µm² |

---

#  Simulation Output

![Waveform](docs/waveform.png)

---

# Project Structure

```
rsa-axi4lite-hardware-accelerator/
│
├── rtl/                 # Verilog RTL modules
├── docs/                # Report and architecture diagrams
├── results/             # Graphs and outputs
│   └── reports/         # Synthesis reports
├── scripts/             # Synthesis notes
├── README.md
└── LICENSE
```

---

# Tools Used

* Verilog HDL
* Xilinx Vivado
* Cadence Genus

---

# Synthesis Reports

* [Timing Report](results/reports/rsa_timing.rpt)
* [Power Report](results/reports/rsa_power.rpt)
* [Area Report](results/reports/rsa_area.rpt)

Detailed synthesis insights are available in:

```
scripts/synthesis_notes.txt
```

---

#  Verification

* Functional verification using Verilog testbench
* AXI4-Lite protocol validation
* Simulation waveform confirms correct encryption and decryption

---

#  Future Work

* Extend to 256-bit / 512-bit RSA
* Add side-channel attack protection
* Implement interrupt-driven AXI interface
* FPGA deployment on SoC platforms (Zynq)
* Support for additional cryptographic algorithms (ECC, PQC)

---

#  Author

**Shivangi Nanda**
B.Tech Electronics and Communication Engineering
VIT-AP University

---

#  License

This project is licensed under the MIT License.
