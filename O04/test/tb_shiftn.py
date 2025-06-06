import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock

@cocotb.test()
async def main_test(dut):
    
    """Try accessing the design."""
    dut._log.info("Running test...")
    
    # starting the test with active reset
    dut.rst_n.value = 0
    input_values = [0]*64
    for i in range(64):
        if(i%2 == 0):
            input_values[i] = 1
    #print("\. input values: ", input_values)
    # Starting clock
    dut._log.info("Starting clock")
    cocotb.start_soon(Clock(dut.mclk, 20, units="ns").start())


    for i in range(64):
        dut.inp.value = input_values[i]
        await RisingEdge(dut.mclk)
    #because reset is active the output should be 00000000
    await RisingEdge(dut.mclk)
    assert dut.parallel.value == 0b0000000000000000000000000000000000000000000000000000000000000000, f"Output value for 32bit shift register should be 00000000 00000000 00000000 00000000, but has value: {dut.parallel.value}"
    assert dut.serial.value == 0, f"Output value for 64bit shif register should be 0, but has value: {dut.serial.value}"


    # continue the test with inactive reset
    dut.rst_n.value = 1
    for i in range(64):
        dut.inp.value = input_values[i]
        await RisingEdge(dut.mclk)
    #because reset is inactive the output should be 00000001 for parallel and 1 for serial
    await RisingEdge(dut.mclk)
    assert dut.parallel.value == 0b1010101010101010101010101010101010101010101010101010101010101010, f"Output value for 8bit shif register should be 10000000, but has value: {dut.parallel.value}"
    assert dut.serial.value == input_values[0], f"Output value for 64bit shif register should be 1, but has value: {dut.serial.value}"


    dut._log.info("Running test...done")

    
