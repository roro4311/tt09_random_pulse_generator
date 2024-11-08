# test.py - Cocotb test script for tt_um (Random Pulse Generator)
import cocotb
from cocotb.regression import TestFactory
from cocotb.triggers import RisingEdge

@cocotb.coroutine
def test_tt_um_random_pulse_generator(dut):
    """ Test the tt_um module with random pulse generation """

    # Apply reset
    dut.rst_n = 0
    yield RisingEdge(dut.clk)
    dut.rst_n = 1

    # Wait for a few clock cycles to observe pulse behavior
    yield RisingEdge(dut.clk)
    yield RisingEdge(dut.clk)
    yield RisingEdge(dut.clk)

    # Check that a pulse has been generated (uio_out[0] should be high at some point)
    pulse_generated = False
    for _ in range(100):
        if dut.uio_out.value == 1:
            pulse_generated = True
            break
        yield RisingEdge(dut.clk)

    assert pulse_generated, "Pulse was not generated as expected"

    # Wait for pulse to finish
    yield RisingEdge(dut.clk)

    # Check that pulse has stopped (uio_out[0] should be low)
    assert dut.uio_out.value == 0, f"Pulse was still active when it should have stopped, uio_out = {dut.uio_out.value}"

    # Re-check pulse generation by observing the output again
    yield RisingEdge(dut.clk)
    pulse_generated = False
    for _ in range(100):
        if dut.uio_out.value == 1:
            pulse_generated = True
            break
        yield RisingEdge(dut.clk)

    assert pulse_generated, "Pulse was not generated as expected after a reset"

# Create the test factory for the testbench
factory = TestFactory(test_tt_um_random_pulse_generator)
factory.generate_tests()
