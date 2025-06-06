import cocotb
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def main_test(dut):
    
    """Try accessing the design."""
    dut._log.info("Running test select decoder...")

    dut.inp.value = 0b00
    await Timer(150, units='ns')
    assert(dut.outp.value == 0b1110, f"Output value for 00 is wrong: {dut.outp.value}")
    
    dut.inp.value = 0b01
    await Timer(150, units='ns')
    assert(dut.outp.value == 0b1101, f"Output value for 01 is wrong: {dut.outp.value}")
    
    dut.inp.value = 0b10
    await Timer(150, units='ns')
    assert(dut.outp.value == 0b1011, f"Output value for 10 is wrong: {dut.outp.value}")
    
    dut.inp.value = 0b11
    await Timer(150, units='ns')
    assert(dut.outp.value == 0b0111, f"Output value for 11 is wrong: {dut.outp.value}")

    await Timer(150, units='ns')
    dut._log.info("Running test...done")