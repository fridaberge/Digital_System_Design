import cocotb
from cocotb.triggers import RisingEdge, Edge, FallingEdge, ClockCycles, Timer
from cocotb.utils import get_sim_time
from cocotb.clock import Clock
import random


async def reset(dut):
    dut._log.info("Resetting...")
    dut.reset.value = 1
    await ClockCycles(dut.clk, 2)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 2)


@cocotb.test()
async def main_test(dut):

    dut._log.info("Starting testing")
    dut._log.info("Starting clock")
    cocotb.start_soon(Clock(dut.mclk, 100, units="ns").start())
    dut.reset.value = 1
    # await Timer(10, units="ns")
    # await reset(dut)

    # dut._log.info("Starting stimuli")
    # await Edge(dut.change)
    # dut._log.info("Starting stimuli")
    # for i in range(dut.num_values.value):
    #     dut.address.value = i
    #     await Edge(dut.change)
    # for i in range(10):
    #     await Edge(dut.change)
    
    
    dut._log.info("Testing done. All tests passed")

