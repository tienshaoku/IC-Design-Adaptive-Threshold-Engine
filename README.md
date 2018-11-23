# IC-Design-Adaptive-Threshold-Engine
Verilog code of a adaptive threshold engine

Explanation of the implementation:
1. When reset==1, initialize the value of all regs as 0.
2. I add an extra buffer[64] so that it can be compared to the value of the threshold.
3. With the advise of others, I set the range of the value of block_count between 0 to 5, so that the code will be easier(namely, no need to write if block_count==6, 12 bla bla bla)
4. Also, the value of bin has to be set up in “assign”, as it can assign value "instantly" when the value of block_count changes. This is the adjustment I made after encountering errors.

Extra thoughts during completing the homework:

Code Simplification:
I tried to improve my codes after it succeeded to function, with the guidance of masters in our lab.
Firstly, express numbers in their complete bit length, so that the program will not fill the empty bits with wrong numbers.

before: if (block_count== 5)
after: if (block_count== 5'd5)

Then, I was told to use "bit comparison" to substitute number comparison.

before: if (block_count== 5'd5)
after: if (block_count[2] & block_count[0])

As in my code, the value range of block_count is between 0 and 5, so it’s impossible to have 7(111 in binary) but only 5(101 in binary). 
Therefore, use "and" to compare the [0] and [2] position of block_count can achieve the same idea as comparing ==5.

<br>

1. Description.pdf: description of the requirement of the adaptive threshold engine
2. explanation.pdf: explanation of the code and also some personal reviews
3. ate.v: verilog code
4. ate.vo, ate_v.sdo, cycloneii_atoms.v: files for simulation
5. testfixture.v: testbench
