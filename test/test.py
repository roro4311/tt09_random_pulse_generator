# test.py - Test script for Random Pulse Generator
import cocotb
from cocotb.regression import TestFactory
from cocotb.binary import BinaryValue

@cocotb.coroutine
def random_pulse_generator_tb(dut):
    # Initial setup (reset signal)
    dut.rst_n <= 0
    yield cocotb.regression.ClockCycles(dut.clk, 2)  # Wait for a couple of clock cycles

    # Release reset
    dut.rst_n <= 1
    yield cocotb.regression.ClockCycles(dut.clk, 2)  # Wait for a couple more clock cycles

    # Check pulse output after reset is released
    assert dut.uio_out == BinaryValue(0b1, size=8), f"Expected pulse on uio_out, got {dut.uio_out}"

    # Wait for the pulse to go low after the counter wraps
    yield cocotb.regression.ClockCycles(dut.clk, 100)  # Wait for 100 clock cycles

    # Check if pulse has returned to 0
    assert dut.uio_out == BinaryValue(0b0, size=8), f"Expected no pulse on uio_out, got {dut.uio_out}"

    # End the simulation
    yield cocotb.regression.ClockCycles(dut.clk, 200)
    assert dut.uio_out == BinaryValue(0b0, size=8), f"Expected no pulse after simulation end, got {dut.uio_out}"

# Define the test factory and add the test
tf = TestFactory(random_pulse_generator_tb)
tf.add_option("-v", "--vcd")  # To generate VCD waveform output (optional)
tf.generate_tests()
