# ZynqCrypt-SoC

A comprehensive cryptographic System-on-Chip implementation for Xilinx Zynq-7000 platform featuring hardware-accelerated cryptographic operations with AES, DES, and GCD processing units.

## 🔒 Overview

ZynqCrypt-SoC demonstrates advanced hardware/software co-design for cryptographic acceleration on Xilinx Zynq FPGA. This project implements custom IP cores for cryptographic operations with multiple software execution environments including bare-metal, FreeRTOS, and Linux kernel drivers.

## 🏗️ Architecture

### Hardware Components (`hw/`)
- **AES IP Core**: 128-bit Advanced Encryption Standard with hardware key expansion
- **DES IP Core**: 64-bit Data Encryption Standard with optimized S-boxes
- **GCD IP Core**: Hardware-accelerated Greatest Common Divisor using Euclidean algorithm
- **Inter IP Core**: Interrupt controller for GPIO, switches, LEDs, and buttons
- **System Integration**: Complete Zynq PS/PL integration with AXI4-Lite interfaces

### Software Implementations (`sw/`)
- **Standalone**: Bare-metal implementation for maximum performance
- **FreeRTOS**: Real-time operating system with task-based crypto workflows
- **Linux Driver**: Kernel module with character device interface and user applications

## 📁 Project Structure

```
ZynqCrypt-SoC/
├── hw/                         # Hardware design & IP cores
│   ├── aes_ip/                # AES-128 encryption IP core
│   ├── des_ip/                # DES encryption IP core
│   ├── gcd_ip/                # GCD calculation IP core
│   ├── inter_ip/              # Interrupt/GPIO controller IP
│   └── integrator/            # Vivado project & system integration
├── sw/                         # Software implementations
│   ├── standalone/            # Bare-metal application
│   ├── freertos/              # FreeRTOS-based application
│   ├── linux_driver/          # Linux kernel module & user apps
│   └── common/                # Shared utilities and libraries
├── scripts/                    # Build automation & deployment scripts
├── doc/                       # Comprehensive documentation
├── Vitis/                     # Vitis workspace (legacy projects)
└── vivado/                    # Vivado projects and IP repository
```

## 🚀 Quick Start

### Prerequisites
- **Hardware**: Xilinx Zynq-7000 series board (PYNQ-Z2 recommended)
- **Software**: Xilinx Vivado & Vitis 2020.1 or later
- **OS**: Linux development environment with ARM cross-compilation tools``

### Linux Deployment
```bash
# Deploy to target board
cd sw/linux_driver
make deploy

# Load kernel module
sudo insmod crypto_ips.ko
sudo chmod 666 /dev/crypto_ips

# Run cryptographic workflow
./crypto_workflow
```

## 🔐 Cryptographic Workflow

The system implements a comprehensive cryptographic pipeline:

1. **Input Acquisition** - Read plaintext from switches or user input
2. **DES Encryption** - Primary encryption using DES IP core
3. **Data Verification** - DES decryption and integrity check
4. **GCD Processing** - Mathematical operation on encrypted data
5. **AES Encryption** - Secondary encryption of GCD results
6. **Output Display** - LED visualization and UART output

### Supported Operations
- **AES-128**: ECB mode encryption/decryption
- **DES**: 64-bit block cipher with 56-bit keys
- **GCD**: Hardware-accelerated Euclidean algorithm
- **GPIO Control**: Switch input and LED output management

## ✨ Features

- 🔧 **Hardware Acceleration**: Custom FPGA IP cores for crypto operations
- 🎯 **Multi-Platform**: Bare-metal, RTOS, and Linux implementations
- ⚡ **Performance Optimized**: Pipeline architecture with DMA support
- 🔄 **Interrupt-Driven**: Efficient event-based processing
- 📊 **Comprehensive Testing**: Built-in test suites and benchmarks
- 💡 **Visual Feedback**: LED patterns for operation status
- 🛠️ **Automated Build**: Script-based compilation and deployment

## 📚 Documentation

- [Hardware Architecture](hw/README.md) - Detailed IP core specifications
- [Linux Driver Guide](sw/linux_driver/README.md) - Kernel module usage
- [Linux Usage Examples](doc/linux_usage.md) - Application examples
- [FreeRTOS Implementation](sw/freertos/README.md) - RTOS-based approach
- [Standalone Application](sw/standalone/README.md) - Bare-metal programming

## 🔧 Hardware Requirements

- **FPGA Board**: Xilinx Zynq-7000 series (Zynq-7010/7020)
- **Memory**: Minimum 512MB DDR3 RAM
- **Interfaces**: UART, GPIO, SD card slot
- **Development Tools**: Xilinx Vivado/Vitis 2020.1+

## 💻 Software Requirements

- **Cross-Compiler**: ARM GCC toolchain (arm-linux-gnueabi)
- **Build System**: GNU Make, CMake (optional)
- **Target OS**: Linux kernel 4.14+ (for driver implementation)
- **Libraries**: Standard C library, POSIX threads

## 🧪 Testing & Validation

```bash
# Run hardware-in-the-loop tests
cd sw/linux_driver/test
./run_all_tests.sh

# Performance benchmarking
./crypto_benchmark --iterations=1000

# Unit tests for individual IP cores
cd hw/aes_ip/tb && make test
cd hw/des_ip/tb && make test
cd hw/gcd_ip/tb && make test
```

## 📊 Performance Metrics

| Operation | Hardware (cycles) | Software (cycles) | Speedup |
|-----------|------------------|-------------------|---------|
| AES-128   | ~10              | ~200              | 20x     |
| DES       | ~16              | ~300              | 18.75x  |
| GCD       | ~50              | ~1000             | 20x     |

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines
- Follow existing code style and conventions
- Add comprehensive test coverage for new features
- Update documentation for any API changes
- Ensure all CI/CD checks pass

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Xilinx for the Zynq platform and development tools
- Open-source cryptographic reference implementations
- FPGA development community for optimization techniques

## 📧 Contact & Support

For questions, issues, or support:
- **Issues**: Please use GitHub Issues for bug reports and feature requests
- **Discussions**: Join our GitHub Discussions for community support
- **Documentation**: Comprehensive guides available in the `doc/` directory

---

**⭐ Star this repository if it helped your project!**