import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_random_pulse_generator(dut):
    """ Test the random pulse generator with a continuous enable """

    # Reset the device
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1  # Release reset

    # Monitor the pulse, counter, LFSR, and pulse_freq_counter for 20,000 clock cycles
    for cycle in range(20000):
        await RisingEdge(dut.clk)
        
        # Capture current values
        pulse = dut.pulse.value
        counter = dut.counter.value
        lfsr = dut.lfsr.value
        pulse_freq_counter = dut.pulse_freq_counter.value

        # Log these values for insight
        dut._log.info(f"Cycle: {cycle}, Pulse: {pulse}, Counter: {counter}, LFSR: {lfsr}, Pulse Frequency Counter: {pulse_freq_counter}")
        
        # Check if pulse is generated as expected
        if pulse == 1:
            dut._log.info(f"Pulse generated at cycle {cycle} with Counter: {counter}, LFSR: {lfsr}, Pulse Frequency Counter: {pulse_freq_counter}")
            break  # Optional: Stop the test if a pulse is observed
