import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
import random

@cocotb.test()
async def test_random_pulse_generator(dut):
    """Test random pulse generator with rotary encoder adjustments"""

    # Generate the clock
    cocotb.start_soon(Clock(dut.clk, 20, units="ns").start())  # 50 MHz

    # Apply reset
    dut.rst_n.value = 0
    await Timer(100, units="ns")
    dut.rst_n.value = 1

    # Enable the module
    dut.ena.value = 1

    # Set initial rotary encoder value and monitor pulse behavior
    for encoder_val in [1, 5, 15]:  # Simulating low, medium, and high frequency settings
        dut.ui_in.value = encoder_val
        await Timer(1000, units="ns")  # Wait to observe pulse pattern

        # Check if pulse output changes based on ui_in frequency input
        pulse_changes = 0
        last_pulse = dut.uio_out.value & 0x01  # Monitor only the LSB of uio_out (pulse)

        for _ in range(100):  # Check over 100 clock cycles
            await RisingEdge(dut.clk)
            current_pulse = dut.uio_out.value & 0x01
            if current_pulse != last_pulse:
                pulse_changes += 1
            last_pulse = current_pulse

        cocotb.log.info(f"Encoder setting {encoder_val}: Pulse toggled {pulse_changes} times.")
        assert pulse_changes > 0, f"Pulse did not toggle as expected with encoder setting {encoder_val}"

    # Finish test
    dut.ena.value = 0
    await Timer(100, units="ns")
