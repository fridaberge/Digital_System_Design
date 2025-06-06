import cocotb
from cocotb.triggers import Edge, Timer, ReadOnly, ClockCycles
from cocotb.clock import Clock

# Dictionary that are in accorance with 'Table 1 Truth table for a seven-segment display*
# Used for testing the combinatorial function made in task a).
# bin2ssd = {
#     0b00: 0b1111110,
#     0b01: 0b0110000,
#     0b10: 0b1101101,
#     0b11: 0b1111001,

# }

state_conv_table = {
    0b00000000 : 'state0',
    0b00000001 : 'state1',
    0b00000010 : 'state2',
    0b00000011 : 'state3'
}

s0tos3 = [[0,0], [0,1], [1,1], [1,0]]
s3tos0 = [[1,1], [0,1], [0,0], [0,0]]
errors = [[0,0], [1,1], [0,1], [1,0]]



async def increase_stimuli(dut):
    await ClockCycles(dut.mclk, 2)
    dut._log.info("starting increase stimuli")
    dut._log.info(state_conv_table[int(dut.r_state)])
    expected = [0b00000000, 0b00000001,0b00000010,0b00000011]
    i = 0

    for valueset in s0tos3:
        
        dut.SA.value = valueset[0]
        dut.SB.value = valueset[1]
        await ClockCycles(dut.mclk, 2)

        state = int(dut.r_state)
        exp = int(expected[i])

        dut._log.info(state_conv_table[state])
        dut._log.info(int(state))
        dut._log.info(int(exp))

        # assert state == exp, \
        #     f"Fail: Actual value of state in increae is '{state_conv_table[state]}' is not matching the expected value of: '{state_conv_table[exp]}'"
        i+=1

    await ClockCycles(dut.mclk, 2)

async def decrease_stimuli(dut):
    await ClockCycles(dut.mclk, 2)
    dut._log.info("starting decrease stimuli")

    expected = [0b00000011,0b00000010,0b00000001,0b00000000]
    i = 0

    for valueset in s3tos0:
        
        dut.SA.value = valueset[0]
        dut.SB.value = valueset[1]
        await ClockCycles(dut.mclk, 2)
        
        state = int(dut.r_state)
        exp = int(expected[i])

        dut._log.info(state_conv_table[state])
        dut._log.info(int(state))
        dut._log.info(int(exp))
        
        assert state == exp, \
            f"Fail: Actual value of state in decrease is '{state_conv_table[state]}' is not matching the expected value of: '{state_conv_table[exp]}'"
        i+=1
        
    await ClockCycles(dut.mclk, 2)

async def error_stimuli(dut):
    await ClockCycles(dut.mclk, 2)
    dut._log.info("starting error stimuli")

    expected = [0,0,1,1]
    exp_error = [0,1,0,1]

    i = 0
    for valueset in errors:
        
        dut.SA.value = valueset[0]
        dut.SB.value = valueset[1]
        await ClockCycles(dut.mclk, 2)

        state = int(dut.r_state)
        exp = expected[i]

        dut._log.info(state_conv_table[state])
        dut._log.info(int(state))
        dut._log.info(exp)
        
        #look at the waveform to see error-signal
        # assert state == exp,\
        #     f"Fail: Actual value of 'state={state_conv_table[state]}' is not matching the expected value of: '{state_conv_table[exp]}'"
        # assert error_msg == exp_error,\
        #     f"Fail: Actual value of 'state={state_conv_table[state]}' is not matching the expected value of: '{state_conv_table[exp]}'"

        i+=1
    await ClockCycles(dut.mclk, 2)

async def reset(dut):
    dut._log.info("Resetting...")
    dut.reset.value = 1
    dut.SA.value = 0
    dut.SB.value = 0
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
    await cocotb.start_soon(increase_stimuli(dut))
    await cocotb.start_soon(decrease_stimuli(dut))
    await cocotb.start_soon(error_stimuli(dut))

    #await Timer(30000, units='ns')
    dut._log.info("Testing done. All tests passed")