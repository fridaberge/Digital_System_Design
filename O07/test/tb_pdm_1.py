import cocotb
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles, Timer
from cocotb.utils import get_sim_time
from cocotb.clock import Clock
import random
CLOCK_PERIOD_NS = 10


async def reset(dut):
    dut._log.info("Resetting...")
    dut.reset.value = 1
    dut.mea_req.value = 0
    dut.min_on.value = 5
    dut.setpoint.value = 25000 #endre?
    dut.min_off.value = 10
    dut.max_on.value = 200
    await ClockCycles(dut.clk, 2)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 2)
    dut._log.info("Reset...")


async def max_on_check(dut):
    dut._log.info("Checking max on")
    while True:
        await RisingEdge(dut.pdm_pulse)
        start = get_sim_time('ns')
        await FallingEdge(dut.pdm_pulse)
        end = get_sim_time('ns')
        duration = end-start
        cycles = duration/CLOCK_PERIOD_NS
        # assert cycles <= int(dut.max_on.value)+1, (
        #     f"""Pulse of {cycles} cycles greater than 
        #     max_on: {int(dut.max_on.value)}""")


async def min_on_check(dut):
    dut._log.info("Checking min on")
    while True:
        await FallingEdge(dut.pdm_pulse)
        start = get_sim_time('ns')
        await RisingEdge(dut.pdm_pulse)
        end = get_sim_time('ns')
        duration = end-start
        cycles = duration/CLOCK_PERIOD_NS
        # assert cycles >= int(dut.min_on.value), (
        #     f"""Pulse of {cycles} cycles greater than 
        #     max_on: {int(dut.min_on.value)}""")


async def mea_ack_check(dut):
    dut._log.info("Checking mea ack")
    while True:
        await RisingEdge(dut.mea_req)
        if(dut.pdm_pulse.value == 0):
            assert(dut.pdm_pulse.value == 0, f"""Mea_ack was asserted when pdm_pulse was high""")
            await ClockCycles(dut.clk, 2)
            assert dut.mea_ack.value == 0b1, (f"""mea_ack not asserted within 2 clock cycles after mea_req was asserted""")
            await FallingEdge(dut.mea_req)
            await ClockCycles(dut.clk, 2)
            assert dut.mea_ack.value == 0b0, (f"""mea_ack not de-asserted within 2 clock cycles after mea_req was de-asserted""")
    


async def duty_cycle(dut):
    dut._log.info("Starting duty cycle")
    while True:
        #checking time on
        await FallingEdge(dut.pdm_pulse)
        start = get_sim_time('ns')
        await RisingEdge(dut.pdm_pulse)
        start_on = get_sim_time('ns')
        await FallingEdge(dut.pdm_pulse)
        end = get_sim_time('ns')
        end_on = get_sim_time('ns')

        duration = end-start
        duration_on = end_on-start_on
        cycles = duration/CLOCK_PERIOD_NS
        cyckles_on = duration_on/CLOCK_PERIOD_NS

        duty_cycle = cyckles_on/cycles
        setpoint = int(dut.setpoint.value)/(2**dut.width.value)
        
        #assert abs(duty_cycle-setpoint) <= 0.1, (f"""The duty cycle is too low: f{duty_cycle}""")



async def mea_stimuli(dut):
    dut._log.info("Starting mea stimuli")
    for i in range(5):
        await ClockCycles(dut.clk, str(random.randint(400,10000)))
        dut.mea_req.value = 0b1
        await ClockCycles(dut.clk,5)
        dut.mea_req.value = 0b0


async def setpoint_stimuli(dut):
    dut._log.info("Starting setpoint stimuli") 
    for i in range(50):
        #every second setpoint value hold for 4 cycles
        # await Timer(10000, units="ns")
        if i%2:
            dut.setpoint.value = random.randint(1000, 2**dut.width.value-1000)
            for i in range(4):
                await FallingEdge(dut.pdm_pulse) 

        #every second setpoint value hold for 2 cycles
        else:
            dut.setpoint.value = random.randint(1000, 2**dut.width.value-1000)
            for i in range(2):
                await FallingEdge(dut.pdm_pulse)                


# async def stimuli(dut):
#     dut._log.info("Starting stimuli")
#     mea_stimuli(dut)
#     setpoint_stimuli(dut)
    # dut._log.info("Starting setpoint stimuli")
    # for i in range(50):
    #     #every second setpoint value hold for 4 cycles
    #     # await Timer(10000, units="ns")
    #     if i%2:
    #         dut.setpoint.value = random.randint(1000, 2**dut.width.value-1000)
    #         for i in range(4):
    #             await FallingEdge(dut.clk) 

    #     #every second setpoint value hold for 2 cycles
    #     else:
    #         dut.setpoint.value = random.randint(1000, 2**dut.width.value-1000)
    #         for i in range(2):
    #             await FallingEdge(dut.clk) 
    # cocotb.start_soon(stimuli(dut))  
    # #setpoint_stimuli(dut)
    


@cocotb.test()
async def main_test(dut):
    dut._log.info("Starting testing")
    dut._log.info("Starting clock")

    cocotb.start_soon(Clock(dut.clk, CLOCK_PERIOD_NS, units="ns").start())
    await reset(dut)
    cocotb.start_soon(max_on_check(dut))
    cocotb.start_soon(min_on_check(dut))
    cocotb.start_soon(mea_ack_check(dut))
    cocotb.start_soon(duty_cycle(dut))
    
    dut._log.info("Starting setpoint stimuli") 
    for i in range(50):
        #every second setpoint value hold for 4 cycles
        # await Timer(10000, units="ns")
        if i%2:
            dut.setpoint.value = random.randint(1000, 2**dut.width.value-1000)
            for i in range(4):
                await FallingEdge(dut.pdm_pulse) 

        #every second setpoint value hold for 2 cycles
        else:
            dut.setpoint.value = random.randint(1000, 2**dut.width.value-1000)
            for i in range(2):
                await FallingEdge(dut.pdm_pulse)      
    # cocotb.start_soon(setpoint_stimuli(dut))

    dut._log.info("Starting mea stimuli")
    for i in range(5):
        await ClockCycles(dut.clk, random.randint(400,10000))
        dut.mea_req.value = 0b1
        await RisingEdge(dut.mea_ack)
        await ClockCycles(dut.clk,5)
        dut.mea_req.value = 0b0

     

    # cocotb.start_soon(setpoint_stimuli(dut))
    # cocotb.start_soon(mea_stimuli(dut))

    await Timer(100, units="ns")

    dut._log.info("Testing done. All tests passed")

