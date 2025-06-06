import random
import cocotb
from cocotb import start_soon
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ReadOnly

# Skeleton for task d starting here:
async def reset_dut(dut):
    await FallingEdge(dut.mclk)
    dut.rst_n.value = 0
    dut.indata1.value = 0
    dut.indata2.value = 0
    await RisingEdge(dut.mclk)
    dut.rst_n.value = 1

def parity(value):
    """ Function to calculate what the parity of value is.
    arguments:
      value(cocotb.binary.BinaryValue): Value to calculate parity from (dut.indata*.value).
    return:
      result(int): Parity of value (1 or 0).
    """
    result = 0
    for i in range(value.n_bits):
        result = result ^ (value & 1)
        value = value >> 1
    return result

def predict(dut):
    pred_parity_indata1 = parity(dut.indata1.value)
    pred_parity_indata2 = parity(dut.indata2.value)

    # ^ is bitwise XOR in python
    pred_par =  pred_parity_indata1 ^ pred_parity_indata2 
    return pred_par
   

async def stimuli_generator(dut):

    for i in range(20):
        await FallingEdge(dut.mclk)
        dut.indata1.value = random.randrange(0x0000,0xFFFF, 1)
        dut.indata2.value = i
        await RisingEdge(dut.mclk)
    # Awaiting one last rising_edge(mclk) without changes
    await RisingEdge(dut.mclk)


async def compare(dut):
    # Your code here.
    while True:
        await RisingEdge(dut.mclk)
        await ReadOnly()
        assert parity(dut.indata1.value)==dut.toggle_parity.value, f"Output for toggle is supposted to be {parity(dut.indata1.value)}, but is {dut.toggle_parity.value}"
        reset_dut(dut)
        assert parity(dut.indata2.value)==dut.xor_parity.value, f"Output for xor is supposted to be {parity(dut.indata2.value)}, but is {dut.xor_parity.value}"
        reset_dut(dut)
        assert predict(dut)==dut.par.value, f"Output for combine is supposted to be {predict(dut)}, but is {dut.par.value}"


@cocotb.test()
async def main_test(dut):
    dut._log.info("Running test...")
    start_soon(Clock(dut.mclk, 100, units="ns").start())
    await reset_dut(dut)
    cocotb.start_soon(compare(dut))
    await start_soon(stimuli_generator(dut))
    dut._log.info("Running test... done")
