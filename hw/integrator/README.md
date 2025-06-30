# Hardware Integration - System Design

This directory contains the complete system integration files for the ZynqCrypt-SoC project, including the Vivado project, block design, and system-level hardware artifacts.

## 🏗️ Overview

The integrator directory serves as the central hub for combining all individual IP cores into a complete cryptographic system. It includes the Vivado project files, block design, constraints, and generated bitstreams for deployment to the target FPGA.

## 📁 Directory Structure

```
integrator/
├── vivado_project/         # Complete Vivado project
│   ├── project_1.xpr      # Main Vivado project file
│   ├── project_1.srcs/    # Source files and constraints
│   ├── project_1.cache/   # Build cache (gitignored)
│   ├── project_1.runs/    # Synthesis and implementation runs
│   └── project_1.gen/     # Generated files
├── xdc/                   # Constraint files
│   └── system_constraints.xdc # Pin assignments and timing
├── system_wrapper.bit     # Generated bitstream
├── system_wrapper_final.xsa # Hardware specification for software
├── build_system.tcl       # Automated build script
└── README.md              # This file
```

## 🔧 System Architecture

### Block Design Overview
```
    ┌─────────────────────────────────────────────────────────┐
    │                 Zynq Processing System                   │
    │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
    │  │ARM Cortex-A9│  │    DDR3     │  │  Peripherals │      │
    │  │   Dual Core │  │   Controller │  │   (UART,    │      │
    │  │             │  │             │  │   GPIO, etc.)│      │
    │  └─────────────┘  └─────────────┘  └─────────────┘      │
    └─────────────┬───────────────────────────────────────────┘
                  │ AXI4 HP/GP Interfaces
                  ▼
    ┌─────────────────────────────────────────────────────────┐
    │              Programmable Logic (PL)                    │
    │                                                         │
    │  ┌─────────────┐     ┌─────────────────────────────┐    │
    │  │ AXI Crossbar│◄───►│      AXI Interconnect       │    │
    │  │   Switch    │     │                             │    │
    │  └─────────────┘     └─────────────────────────────┘    │
    │         │                          │                    │
    │         ▼                          ▼                    │
    │  ┌─────────────┐              ┌─────────────┐           │
    │  │   AES IP    │              │   DES IP    │           │
    │  │   Core      │              │   Core      │           │
    │  │0x43C00000   │              │0x43C10000   │           │
    │  └─────────────┘              └─────────────┘           │
    │         │                          │                    │
    │         ▼                          ▼                    │
    │  ┌─────────────┐              ┌─────────────┐           │
    │  │   GCD IP    │              │  Inter IP   │           │
    │  │   Core      │              │ (GPIO/IRQ)  │           │
    │  │0x43C20000   │              │0x43C30000   │           │
    │  └─────────────┘              └─────────────┘           │
    │                                      │                  │
    │                                      ▼                  │
    │                               ┌─────────────┐           │
    │                               │ Board I/O   │           │
    │                               │LEDs,Switches│           │
    │                               │   Buttons   │           │
    │                               └─────────────┘           │
    └─────────────────────────────────────────────────────────┘
```

## 📋 Memory Map

### AXI4-Lite Address Assignments
| Component     | Base Address | Size  | Address Range      | Description |
|---------------|--------------|-------|-------------------|-------------|
| AES IP Core   | 0x43C00000   | 64KB  | 0x43C00000-0x43C0FFFF | AES-128 crypto engine |
| DES IP Core   | 0x43C10000   | 64KB  | 0x43C10000-0x43C1FFFF | DES crypto engine |
| GCD IP Core   | 0x43C20000   | 64KB  | 0x43C20000-0x43C2FFFF | GCD calculator |
| Inter IP Core | 0x43C30000   | 64KB  | 0x43C30000-0x43C3FFFF | GPIO & interrupt controller |

### Zynq PS Peripherals
| Peripheral | Base Address | Description |
|------------|--------------|-------------|
| UART0      | 0xE0000000   | Debug console |
| UART1      | 0xE0001000   | Application UART |
| GPIO       | 0xE000A000   | PS GPIO (MIO) |
| Timer      | 0xF8F00600   | System timer |
| Interrupt  | 0xF8F01000   | GIC distributor |

## ⚙️ Clock and Reset Architecture

### Clock Domains
```
FCLK_CLK0 (100 MHz) ────┬─── AXI4-Lite Interfaces
                        ├─── AES IP Core
                        ├─── DES IP Core  
                        ├─── GCD IP Core
                        └─── Inter IP Core

FCLK_CLK1 (200 MHz) ────── High-speed interfaces (future use)

External Clock (125 MHz) ── Board oscillator (not used in current design)
```

### Reset Hierarchy
```
PS_PORB ─────┬─── System Reset
             │
PS_SRSTB ────┼─── Processor System Reset
             │
             └─── rst_ps7_0_100M ────┬─── AXI Infrastructure
                                     ├─── IP Core Resets
                                     └─── User Logic Reset
```

## 🚀 Build Instructions

### Prerequisites
- Xilinx Vivado 2020.1 or later
- Valid Vivado license
- Minimum 8GB RAM for synthesis
- 20GB free disk space

### Automated Build
```bash
# Navigate to integrator directory
cd hw/integrator/

# Run automated build script
vivado -mode batch -source build_system.tcl

# Check for successful completion
ls -la *.bit *.xsa
```

### Manual Build Process
```bash
# Open Vivado project
vivado vivado_project/project_1.xpr

# In Vivado GUI:
# 1. Generate IP cores
# 2. Run synthesis
# 3. Run implementation  
# 4. Generate bitstream
```

### Build Script Details
The `build_system.tcl` script performs the following operations:
1. **Project Setup**: Opens existing project or creates new one
2. **IP Generation**: Generates all custom IP cores
3. **Synthesis**: Runs synthesis with optimized settings
4. **Implementation**: Places and routes the design
5. **Bitstream Generation**: Creates final bitstream file
6. **Export**: Generates XSA file for software development

## 📊 Resource Utilization Report

### Zynq-7020 Utilization Summary
| Resource Type | Used | Available | Utilization |
|---------------|------|-----------|-------------|
| LUTs          | 4,660| 53,200    | 8.76%       |
| Flip-Flops    | 2,980| 106,400   | 2.80%       |
| Block RAM     | 6    | 140       | 4.29%       |
| DSP Slices    | 2    | 220       | 0.91%       |
| IO Pins       | 20   | 200       | 10.00%      |

### Power Analysis
| Component | Power (mW) | Percentage |
|-----------|------------|------------|
| PS7       | 1,432      | 84.2%      |
| AES IP    | 86         | 5.1%       |
| DES IP    | 45         | 2.6%       |
| GCD IP    | 23         | 1.4%       |
| Inter IP  | 12         | 0.7%       |
| Other PL  | 102        | 6.0%       |
| **Total** | **1,700**  | **100%**   |

## ⏱️ Timing Analysis

### Clock Constraints
```tcl
# Primary system clock - 100MHz
create_clock -period 10.000 -name clk_fpga_0 [get_ports clk_fpga_0]

# AXI interface constraints
set_input_delay -clock clk_fpga_0 2.000 [get_ports {M_AXI_*}]
set_output_delay -clock clk_fpga_0 2.000 [get_ports {M_AXI_*}]

# Board I/O constraints
set_input_delay -clock clk_fpga_0 5.000 [get_ports {switches[*]}]
set_output_delay -clock clk_fpga_0 5.000 [get_ports {leds[*]}]
```

### Timing Results
| Path Type | Requirement | Achieved | Slack | Status |
|-----------|-------------|----------|-------|--------|
| Setup     | 10.000 ns   | 8.245 ns | 1.755 ns | ✓ Met |
| Hold      | 0.000 ns    | 0.234 ns | 0.234 ns | ✓ Met |
| Recovery  | 9.500 ns    | 8.891 ns | 0.609 ns | ✓ Met |
| Removal   | 0.500 ns    | 0.723 ns | 0.223 ns | ✓ Met |

## 🔌 Pin Assignments

### Board-Specific Constraints (PYNQ-Z2)
```tcl
# System Clock
set_property PACKAGE_PIN H16 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]

# Slide Switches
set_property PACKAGE_PIN M20 [get_ports {switches[0]}]
set_property PACKAGE_PIN M19 [get_ports {switches[1]}]
# ... (complete switch assignments)
set_property IOSTANDARD LVCMOS33 [get_ports {switches[*]}]

# LEDs  
set_property PACKAGE_PIN R14 [get_ports {leds[0]}]
set_property PACKAGE_PIN P14 [get_ports {leds[1]}]
# ... (complete LED assignments)
set_property IOSTANDARD LVCMOS33 [get_ports {leds[*]}]

# Push Buttons
set_property PACKAGE_PIN D19 [get_ports {buttons[0]}]
set_property PACKAGE_PIN D20 [get_ports {buttons[1]}]
set_property PACKAGE_PIN L20 [get_ports {buttons[2]}]
set_property PACKAGE_PIN L19 [get_ports {buttons[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {buttons[*]}]
```

## 🧪 Verification and Testing

### Design Rule Checks (DRC)
All DRC violations have been resolved:
- ✅ No unconnected pins
- ✅ All clocks properly constrained  
- ✅ No timing violations
- ✅ All I/O standards specified
- ✅ Power analysis passed

### Hardware Validation
```bash
# Load bitstream and test basic functionality
cd test/
./hardware_validation.sh

# Test individual IP cores
./test_aes_ip.sh
./test_des_ip.sh  
./test_gcd_ip.sh
./test_inter_ip.sh

# System-level integration test
./full_system_test.sh
```

### Post-Implementation Simulation
```bash
# Run post-implementation timing simulation
cd vivado_project/
vivado -mode batch -source post_impl_sim.tcl
```

## 🔧 Customization and Modifications

### Adding New IP Cores
1. **Create IP**: Develop new IP core following AXI4-Lite standard
2. **Add to Project**: Import IP into Vivado project
3. **Update Block Design**: Add IP to system block design
4. **Assign Address**: Configure address in memory map
5. **Update Constraints**: Add any required timing/pin constraints
6. **Rebuild System**: Run complete build flow

### Memory Map Extension
To add new IP cores, modify the address assignments:
```tcl
# Example: Add new crypto IP at 0x43C40000
assign_bd_address [get_bd_addr_segs {new_crypto_ip/S00_AXI/reg0}]
set_property offset 0x43C40000 [get_bd_addr_segs {processing_system7_0/Data/SEG_new_crypto_ip_reg0}]
set_property range 64K [get_bd_addr_segs {processing_system7_0/Data/SEG_new_crypto_ip_reg0}]
```

### Performance Optimization
1. **Clock Frequency**: Increase system clock (requires timing closure)
2. **Pipeline Stages**: Add pipeline registers in critical paths
3. **Parallel Processing**: Duplicate IP cores for throughput
4. **Memory Optimization**: Use BRAM for large lookup tables

## 🔍 Debug and Troubleshooting

### Common Build Issues
1. **IP Lock Files**: Remove `.lock` files if Vivado crashes
2. **Out of Memory**: Increase virtual memory or use 64-bit machine
3. **Timing Violations**: Check critical paths and clock constraints
4. **Resource Overflow**: Optimize IP implementations or use larger device

### Debug Features
- **Integrated Logic Analyzer**: ChipScope/ILA for real-time debug
- **Hardware Manager**: JTAG-based debugging and programming
- **Simulation**: Comprehensive testbench for verification
- **Power Analysis**: Real-time power monitoring

### Hardware Debug Setup
```tcl
# Add ILA for debugging AXI transactions
create_debug_core u_ila_0 ila
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
```

## 📈 Performance Benchmarks

### Throughput Measurements
| Operation | Clock Cycles | Throughput @ 100MHz |
|-----------|-------------|-------------------|
| AES-128   | 11          | 1.16 Gbps        |
| DES       | 16          | 400 Mbps         |
| GCD-32    | 1-64        | Variable         |
| GPIO      | 1           | 100 Mops         |

### Latency Analysis
| Component | Latency (ns) | Description |
|-----------|-------------|-------------|
| AXI Read  | 30          | Register read latency |
| AXI Write | 20          | Register write latency |
| Interrupt | 50          | Interrupt assertion to PS |
| Context Switch | 200    | PS task switching overhead |

## 📚 Additional Resources

### Xilinx Documentation
- [Zynq-7000 Technical Reference Manual](https://docs.xilinx.com/r/en-US/ug585-Zynq-7000-TRM)
- [Vivado Design Suite User Guide](https://docs.xilinx.com/r/en-US/ug910-vivado-getting-started)
- [AXI Reference Guide](https://docs.xilinx.com/r/en-US/ug1037-vivado-axi-reference-guide)

### Design Guidelines
- [IP Core Design Best Practices](../doc/ip_design_guidelines.md)
- [Timing Closure Techniques](../doc/timing_optimization.md)
- [Power Optimization Guide](../doc/power_optimization.md)

---

For software integration and driver development, refer to the software documentation in the `sw/` directory.