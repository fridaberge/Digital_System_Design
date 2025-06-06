# Signals, Variables and Process Sensitivity #
IN3160/IN4160
Version 2025-1

In exercise, we will explore signals, variables and the process sensitivity list in VHDL.

> [!NOTE]
> GHDL+gtkwave does not support invocation of variables, thus variables can not be viewed in the waveform.
>
> This assignment does not require _viewing_ variables directly.
> However we need to understand how they behave differently from signals.
> We can invoke variable values by creating signals and assigning them to the variable value.

## a) Simulate ##
* Simulate the attached code in delay.vhd and tb_delay.py.
* When does the output data signal change, and what is the cause of this delay?
## b) Modify ##
* Modify delay.vhd so that all of the variables are replaced by signals (TIP: signals cannot be declared within a process).
* Modify tb_delay.py so that the chip is only in reset from the time 100 ns to 200 ns 
  (TIP: change, for example, to the value `'1'` from time zero) and the input data should now change from `"00000000"` at 0 ns (i.e. start) to `"11110000"` at time 300 ns and to `"00001111"` at time 400 ns. 
1.  When does the output data signal change now? 
2.	How and why did changing variables to signals change the timing?
3.	Why is the output data equal to `"UUUUUUUU"` at time 50 ns?
## c) Drawing a diagram ##
* Simulate the attached code in **variables_vs_signals.vhd** and **tb_variables_vs_signals.py**. 
1.	Why is `output(7 downto 6)` always equal to `output(3 downto 2)`? 
2.	Why is `output(5 downto 4)` different from `output(1 downto 0)`?
3.	Draw a diagram showing the architecture
That is- draw the wires and inverters and fill in where signals and variables occur.

> [!TIP]
> Signals may only occur in one location, while variables may occur in several.

## d) Change sensitivity ## 
* Remove the signals `sig1` and `sig2` are from the sensitivity list in variables_vs_signals.vhd.
* Why does `output(7 downto 6)` and `output(3 downto 2)` have different values than in c)?

> [!IMPORTANT]
> Approval:
> 
> Answer to these questions shall be delivered using the portable document format (.pdf).   
> 
> **Peer review two other assignments. Be polite!**
>
> Peer review is required for approval. 
> Peer reviews will be assigned automatically after the first deadline (stated in canvas). 
> Peer reviews should be handed in within one week. 
> The lab supervisors will grade the tasks after the peer review deadline. 
> The peer review deadline will not be visible in canvas.  

## Peer review process:  ##
(Do not comment on grammar, spelling or punctuation unless it affects the meaning of the text. The purpose of reviewing is to allow both submitter and reviewer to learn)
1. For each question (a, b, c, d), does the answer seem correct? 
    * If yes, then comment that it is a good answer. 
    * If no, declare and note whether you consider the issue is a minor or a major one . 
    Declare what would improve the answer most using one statement. 
    (Do not to provide a detailed breakdown; one or two well-put sentence(s) should do). 
    
2. Is the number of major issues two or greater? 
	  * If yes, mark the assignment to be revised before approval.
	  * If no, mark this assignment as approved. 
   Review your own assignment and revise or re-submit as instructed. 
   
If you do not agree upon the reviewers remarks or need help to improve your text, contact your lab supervisors before re-submitting[^2].

[^2]: Report patronizing, condescending or otherwise malicious comments to the lab supervisors,  
  course management or the administrative staff (studieadministrasjonen). 
  Being polite when reviewing is a requirement for approval of all peer reviewed tasks.


**Example on how to comment:**
“n) Minor: Please revise signal f drawing, I believe it should change in clock cycle two and not three. “

“m) Major: Please revise the entity declaration; I believe the banana entity is required to interface with the angry_gorilla entity.” 
