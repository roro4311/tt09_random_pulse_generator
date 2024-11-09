# test.py - Cocotb test script for tt_um_random_pulse_generator
import cocotb
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_tt_um_random_pulse_generator(dut):
    """ Test random pulse generator behavior """

    # Apply reset
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    # Monitor pulse output for a random pulse event
    pulse_detected = False
    for _ in range(500):  # Check for 500 clock cycles
        await RisingEdge(dut.clk)
        if dut.uio_out.value & 0x01:  # Check uio_out[0] for the pulse
            pulse_detected = True
            break

    assert pulse_detected, "No pulse detected within 500 clock cycles"

    # Test reset functionality
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    # Verify that pulse stops with reset
    pulse_after_reset = dut.uio_out.value & 0x01
    assert pulse_after_reset == 0, "Pulse should be inactive after reset"
