# Oblig  3
### fridatbe

### a)
The output signal changes after 400ps. After 200 ps, the input data changes to 1111000 (and rst_n is already not 0 at 100ps), the a signal changes on the same rising edge. 
Assigning the value variable v1 and then to signal b, takes more than 50ps (the clock cycle), so the changes to b comes with the next clock cycle at 300ps. And the same happens with assigning the value to v2 and then c.


### b)
The output signal now changes at 700 and 800ps. When changing the variables to signals, it takes longer before the output signal changes. The reason for this is that it takes longer for signals to go from one state to another. The variables change in the process while singals waits until after the process. The output data is UUUUUUUU because the input signals havent been assigned yet, and the output signals are therefore also undefined at 50ps.

### c)
The output signals (7 downto 6) is always equal to output (3 downto 2), even though they are defined in variables_vs_signals to be the opposite (because it is inverted with a 'not'). The input and output will be the same because the change has not been applied yet during the process.
The variables are updated within the process, so the delay will not impact the variables (5 downto 4) so they will be inverted, and therefore different from (1 downto 0). The drawing is attached as 3c.png

### d)
The output (7 downto 6) and (3 downto 2) are unitialized when we remove sig1 and sig2 from the sensitivity list. During initialization the process will be excecuted once. So the signals will be assigned values, which will trigger the process to excecute, because the attributes in the sensitivity list will trigger the process. In task d), the signals will not trigger the process to start (after initialization), so the process will start when the indata changes in the test bench which is after 100ps






