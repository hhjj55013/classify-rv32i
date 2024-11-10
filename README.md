# Assignment 2: Classify
2024/11/11 Contributed by < [Huckle_H](https://github.com/hhjj55013/classify-rv32i) > 
###### tags: `RISC-V` `Computer architure 2024`


## Part A: Mathematical Functions
### Task 1: ReLU
This task for implement the ReLU function which detects whether the input interger a1 is under 0. If a1 is under 0, then change the number to 0. If it isn't then skip to the next element.
```c
for(t1 = 0; t1 < a1; t1++){
    MEM[a0] = t2 < 0 ? 0 : MEM[a0];
}
```

### Task 2: ArgMax
This task is finding the maximun interger in the array. Which I use a loop to scan over the elements in the array. If any of the element is greater than the temporary interger then the element replace it. While the loop is done, the interger in the temporary is the maximun number of the array.
```c
t3 = Mem[a0][0];
for(t1 = 1; t1 < a1; t1++){
    t3 = t3 < Mem[a0][t1] ? Mem[a0][t1] : t3;
}
```

### Task 3.1: Dot Product
First, we use a for loop to go over all the elements. Then we do multipile caculate and add up the results.
```c
t0 = 0; // Stores the result
a3 = a3*4; // Reading address shifts 4bytes for every stride.
a4 = a4*4;
for(t1 = 0; t1 < a2; t1++){
    t2 = Mem[a0][t1]; // Input array 1
    t3 = Mem[a1][t1]; // Input array 2
    t4 = t2 * t3;
    t0 += t4;
}
```

Since the assignment requires only RV32I instructions, we can't use ```mul``` in the M extention. So here is the replacement code using only RV32I instructions.

```python
#   mul     t4, t2, t3
    li      t4, 0                   # Initialize result t4 = 0
    li      t5, 1                   # Set t5 = 1, used to check bits in t3

mul_loop:
    and     t6, t3, t5              # Check if the current bit of b (t3) is set
    beqz    t6, mul_skip_add        # If bit is 0, skip addition
    add     t4, t4, t2              # If bit is 1, add a (t0) to the result (t2)

mul_skip_add:
    slli    t2, t2, 1               # Shift a (t0) left by 1 for the next bit
    slli    t5, t5, 1               # Shift mask t3 left by 1 to check next bit
    bnez    t5, mul_loop            # Repeat until all bits of b (t1) are processed
#   mul finish
```
Steps of mul:
1. t2 is set to 0 to store the result.
2. t3 is set to 1, which acts as a bit mask to examine each bit of b (in t1) from least significant to most significant.
3. The and operation with t4, t1, t3 checks if the current bit of b is 1.
4. If the bit is set, we add the current value of a (stored in t0) to t2.
5. Both t0 and t3 are shifted left by one bit to move to the next bit of b on the next iteration.
6. The loop continues until t3 (bit mask) becomes zero, which happens when all bits of b have been processed.

### Task 3.2: Matrix Multiplication
In task 3.2 we are doing multiplication from one dimensional to two dimensional array. Which requies an inner loop and outer loop to finish the caculation. Thanks for the instructer has finished almost 80% of code for us. Below is the structure of ```matmul.s```. 
1. Set counters.
2. Load the adress for both loops.
3. ```outer_loop_start```: Detecting when to stop the outer loop.
4. ```inner_loop_start```: Do the dot product caculation.
5. ```inner_loop_end```: Update the inner loop counter and the incrementing matrix B pointer.
6. ```outer_loop_end```: Do epilogue and recover the saved registers.

```python
inner_loop_end:
    # TODO: Add your own implementation
    slli    t0, a2, 2               # number of columns * 4 for the offset of address
    add     s3, s3, t0              # Advance M0 pointer by the number of columns
    addi    s0, s0, 1               # Increment row counter for M0
    j       outer_loop_start        # Repeat outer loop for the next row
```

## Part B: File Operations and Main
### Task 1: Read Matrix
Thanks for the instructer we only need to finish the code about multipile. I replace the code using the method from Task 3.1 to implement the ```mul``` function.
```python
#   mul s1, t1, t2   # s1 is number of elements
#   FIXME: Replace 'mul' with your own implementation
    li      s1, 0                   
    li      t5, 1                   

mul_loop:
    and     t6, t2, t5              
    beqz    t6, mul_skip_add        
    add     s1, s1, t1              

mul_skip_add:
    slli    t1, t1, 1               
    slli    t5, t5, 1               
    bnez    t5, mul_loop            
#   mul finish
```

### Task 2: Write Matrix
Task 2 in part B is as well as task 1 in part B, we only need to finish the code of multipile. With the same method using in Task 3.1 to implement the ```mul``` function.

### Task 3: Classification
Task 3 in part B is as well as task 1 in part B, we only need to finish the code of multipile. With the same method using in Task 3.1 to implement the ```mul``` function.

## Result
Passed all tests.
```
(base) huckle@HuckleMac classify-rv32i % ./test.sh all          
test_abs_minus_one (__main__.TestAbs) ... ok
test_abs_one (__main__.TestAbs) ... ok
test_abs_zero (__main__.TestAbs) ... ok
test_argmax_invalid_n (__main__.TestArgmax) ... ok
test_argmax_length_1 (__main__.TestArgmax) ... ok
test_argmax_standard (__main__.TestArgmax) ... ok
test_chain_1 (__main__.TestChain) ... ok
test_classify_1_silent (__main__.TestClassify) ... ok
test_classify_2_print (__main__.TestClassify) ... ok
test_classify_3_print (__main__.TestClassify) ... ok
test_classify_fail_malloc (__main__.TestClassify) ... ok
test_classify_not_enough_args (__main__.TestClassify) ... ok
test_dot_length_1 (__main__.TestDot) ... ok
test_dot_length_error (__main__.TestDot) ... ok
test_dot_length_error2 (__main__.TestDot) ... ok
test_dot_standard (__main__.TestDot) ... ok
test_dot_stride (__main__.TestDot) ... ok
test_dot_stride_error1 (__main__.TestDot) ... ok
test_dot_stride_error2 (__main__.TestDot) ... ok
test_matmul_incorrect_check (__main__.TestMatmul) ... ok
test_matmul_length_1 (__main__.TestMatmul) ... ok
test_matmul_negative_dim_m0_x (__main__.TestMatmul) ... ok
test_matmul_negative_dim_m0_y (__main__.TestMatmul) ... ok
test_matmul_negative_dim_m1_x (__main__.TestMatmul) ... ok
test_matmul_negative_dim_m1_y (__main__.TestMatmul) ... ok
test_matmul_nonsquare_1 (__main__.TestMatmul) ... ok
test_matmul_nonsquare_2 (__main__.TestMatmul) ... ok
test_matmul_nonsquare_outer_dims (__main__.TestMatmul) ... ok
test_matmul_square (__main__.TestMatmul) ... ok
test_matmul_unmatched_dims (__main__.TestMatmul) ... ok
test_matmul_zero_dim_m0 (__main__.TestMatmul) ... ok
test_matmul_zero_dim_m1 (__main__.TestMatmul) ... ok
test_read_1 (__main__.TestReadMatrix) ... ok
test_read_2 (__main__.TestReadMatrix) ... ok
test_read_3 (__main__.TestReadMatrix) ... ok
test_read_fail_fclose (__main__.TestReadMatrix) ... ok
test_read_fail_fopen (__main__.TestReadMatrix) ... ok
test_read_fail_fread (__main__.TestReadMatrix) ... ok
test_read_fail_malloc (__main__.TestReadMatrix) ... ok
test_relu_invalid_n (__main__.TestRelu) ... ok
test_relu_length_1 (__main__.TestRelu) ... ok
test_relu_standard (__main__.TestRelu) ... ok
test_write_1 (__main__.TestWriteMatrix) ... ok
test_write_fail_fclose (__main__.TestWriteMatrix) ... ok
test_write_fail_fopen (__main__.TestWriteMatrix) ... ok
test_write_fail_fwrite (__main__.TestWriteMatrix) ... ok

----------------------------------------------------------------------
Ran 46 tests in 54.001s
```