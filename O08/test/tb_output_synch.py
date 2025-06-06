import cocotb
from cocotb.triggers import RisingEdge, Edge, FallingEdge, ClockCycles, Timer
from cocotb.utils import get_sim_time
from cocotb.clock import Clock
import random


async def reset(dut):
    dut._log.info("Resetting...")
    dut.reset.value = 1
    dut.dir_async.value = 0
    dut.en_async.value = 0
    await ClockCycles(dut.mclk, 2)
    dut.reset.value = 0
    await ClockCycles(dut.mclk, 2)



@cocotb.test()
async def main_test(dut):

    dut._log.info("Starting testing")
    dut._log.info("Starting clock")
    cocotb.start_soon(Clock(dut.mclk, 100, units="ns").start())
    # dut.reset.value = 1
    # await Timer(10, units="ns")
    await reset(dut)

    dut._log.info("Starting stimuli")
    # await Edge(dut.change)
    # dut._log.info("Starting stimuli")
    dut.dir_async.value = 0
    dut.en_async.value = 1
    await Timer(100)
    dut.dir_async.value = 1
    dut.en_async.value = 1
    await Timer(500)
    dut.dir_async.value = 0
    dut.en_async.value = 1
    await Timer(100)
    dut.dir_async.value = 1
    dut.en_async.value = 0

    await ClockCycles(dut.mclk, 5)
    
    
    
    dut._log.info("Testing done. All tests passed")
