# test.py - Cocotb test script for tt_um (Random Pulse Generator)
import cocotb
from cocotb.regression import TestFactory
from cocotb.triggers import RisingEdge, Timer
from cocotb.result import TestFailure

@cocotb.coroutine
async def test_tt_um_random_pulse_generator(dut):
    """ Test the tt_um module with random pulse generation """

    # Apply reset
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    dut.ena.value = 1  # Enable pulse generation

    # Monitor and log pulses
    pulse_count = 0
    last_pulse_time = None
    pulse_intervals = []

    # Run for a longer time to gather more pulse data
    for i in range(500):
        await RisingEdge(dut.clk)

        # Check for pulse on uio_out[0] (LSB)
        if dut.uio_out.value & 0x01:  
            pulse_count += 1
            current_time = i  # Using loop iteration as time reference
            if last_pulse_time is not None:
                interval = current_time - last_pulse_time
                pulse_intervals.append(interval)
                dut._log.info(f"Pulse #{pulse_count} at cycle {current_time}, Interval since last pulse = {interval}")
            last_pulse_time = current_time

    # Verify that at least one pulse was generated
    if pulse_count == 0:
        raise TestFailure("No pulses were generated within the test duration")

    # Check for randomness in pulse intervals
    if len(pulse_intervals) > 1:
        avg_interval = sum(pulse_intervals) / len(pulse_intervals)
        dut._log.info(f"Average interval between pulses: {avg_interval} cycles")
        dut._log.info(f"Pulse intervals observed: {pulse_intervals}")
    else:
        dut._log.warning("Insufficient pulse data to analyze randomness")

    # Disable pulse generation and verify pulses stop
    dut.ena.value = 0
    await Timer(50, units='ns')  # Wait some time
    if dut.uio_out.value & 0x01:
        raise TestFailure("Pulse was still active when it should have stopped")

    dut._log.info("Test completed successfully")

# Create the test factory for the testbench
factory = TestFactory(test_tt_um_random_pulse_generator)
factory.generate_tests()
