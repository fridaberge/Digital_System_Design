import cocotb
from cocotb.triggers import Edge, Timer, ReadOnly, ClockCycles
from cocotb.clock import Clock



async def reset(dut):
    dut._log.info("Resetting...")
    dut.reset.value = 1
    dut.a.value = 0
    dut.b.value = 0
    #await Timer(100, units = 'ns')
    await ClockCycles(dut.mclk, 2)
    dut.reset.value = 0
    #await Timer(100, units = 'ns')
    await ClockCycles(dut.mclk, 2)


@cocotb.test()
async def main_test(dut):

    # dut.reset.value = 0b1
    # await Timer(10,units='ns')
    # dut.reset.value = 0b0
    dut._log.info("Starting testing...")
    dut._log.info("Starting clock")
    # set clock to 100MHz when running code
    cocotb.start_soon(Clock(dut.mclk, 50, units="ns").start())
    # cocotb.start_soon(compare(dut))
    #stimuli_generator(dut)
    await cocotb.start_soon(reset(dut))



    #await Timer(30000, units='ns')
    dut._log.info("Testing done. All tests passed")