# Top-level Makefile for Embedded Crypto Suite

.PHONY: all clean hw sw linux standalone freertos help deploy

# Default target
all: help

help:
	@echo "========================================"
	@echo "Embedded Crypto Suite Build System"
	@echo "========================================"
	@echo "Available targets:"
	@echo "  all        - Show this help message"
	@echo "  hw         - Build hardware design (requires Vivado)"
	@echo "  sw         - Build all software components"
	@echo "  linux      - Build Linux driver and applications"
	@echo "  standalone - Build standalone application (requires Vitis)"
	@echo "  freertos   - Build FreeRTOS application (requires Vitis)"
	@echo "  deploy     - Deploy to PYNQ-Z2 board"
	@echo "  clean      - Clean all build artifacts"
	@echo "  help       - Show this help message"
	@echo ""
	@echo "Usage examples:"
	@echo "  make hw          # Build hardware design"
	@echo "  make linux       # Build Linux components"
	@echo "  make deploy      # Deploy to board"
	@echo "  make clean       # Clean everything"

# Hardware build
hw:
	@echo "Building hardware design..."
	@./scripts/build_hw.sh

# Software build
sw:
	@echo "Building software components..."
	@./scripts/build_sw.sh

# Linux-specific build
linux:
	@echo "Building Linux driver and applications..."
	@$(MAKE) -C sw/linux_driver all

# Standalone build (requires Vitis)
standalone:
	@echo "Building standalone application..."
	@echo "Note: This requires Vitis IDE or proper cross-compilation setup"
	@echo "See sw/standalone/README.md for detailed instructions"

# FreeRTOS build (requires Vitis/FreeRTOS SDK)
freertos:
	@echo "Building FreeRTOS application..."
	@echo "Note: This requires Vitis IDE or FreeRTOS SDK setup"
	@echo "See sw/freertos/README.md for detailed instructions"

# Deploy to PYNQ-Z2 board
deploy:
	@echo "Deploying to PYNQ-Z2 board..."
	@./scripts/deploy.sh

# Clean all build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@find . -name "*.o" -delete
	@find . -name "*.ko" -delete
	@find . -name "*.mod" -delete
	@find . -name "*.mod.c" -delete
	@find . -name "modules.order" -delete
	@find . -name "Module.symvers" -delete
	@find . -name ".tmp_versions" -type d -exec rm -rf {} + 2>/dev/null || true
	@$(MAKE) -C sw/linux_driver clean 2>/dev/null || true
	@echo "Clean completed"

# Check project structure
check:
	@echo "Checking project structure..."
	@echo "Hardware IP cores:"
	@ls -la hw/*/src/ 2>/dev/null || echo "  No IP cores found"
	@echo "Software components:"
	@ls -la sw/ 2>/dev/null || echo "  No software components found"
	@echo "Build scripts:"
	@ls -la scripts/*.sh 2>/dev/null || echo "  No build scripts found"
	@echo "Documentation:"
	@ls -la doc/ 2>/dev/null || echo "  No documentation found"

# Install dependencies (placeholder)
deps:
	@echo "Dependency installation not implemented yet"
	@echo "Please ensure you have:"
	@echo "  - Xilinx Vivado 2020.1 or later"
	@echo "  - Xilinx Vitis 2020.1 or later"
	@echo "  - ARM cross-compilation toolchain"
	@echo "  - Linux kernel headers for target"