import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_tt_um_random_pulse_generator(dut):
    """ Test the random pulse generator """
    # Initialize reset and enable signals
    dut.rst_n.value = 0
    dut.ena.value = 0
    await RisingEdge(dut.clk)  # Wait for a clock edge
    dut.rst_n.value = 1        # Release reset
    dut.ena.value = 1          # Enable the module
    
    # Check for pulse signal behavior
    for _ in range(1000):
        await RisingEdge(dut.clk)  # Assuming you want to wait for a rising edge of the clock
await Timer(200000, units='ns')  # Simulate for 50,000 ns
        # Monitor pulse output (in uio_out[0])
        pulse = dut.uio_out.value & 0x01
        dut._log.info(f"Pulse = {pulse}")
