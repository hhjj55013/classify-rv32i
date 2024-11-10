.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li      t0, 1                   # t0 = 1 (for comparisons)
    blt     a2, t0, error_terminate # Check if element_count < 1
    blt     a3, t0, error_terminate # Check if stride0 < 1
    blt     a4, t0, error_terminate # Check if stride1 < 1
    
    li      t0, 0                   # t0 = Resulting dot product (initialize to 0)
    li      t1, 0                   # t1 = Loop counter (i)
    slli    a3, a3, 2               # a3 = stride0 * 4 (stride in bytes for array0)
    slli    a4, a4, 2               # a4 = stride1 * 4 (stride in bytes for array1)

loop_start:
    lw      t2, 0(a0)               # Load arr0[i * stride0] into t2
    lw      t3, 0(a1)               # Load arr1[i * stride1] into t3
    bge     t1, a2, loop_end        # If i >= element_count, exit loop
    add     a0, a0, a3              # a0 = address of arr0[i * stride0]
    add     a1, a1, a4              # a1 = address of arr1[i * stride1]

#   mul     t4, t2, t3              # t4 = arr0[i * stride0] * arr1[i * stride1]
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

    add     t0, t0, t4              # t0 += t4 (accumulate into result)
    addi    t1, t1, 1               # i++
    j       loop_start              # Repeat loop

loop_end:
    mv      a0, t0                  # Move result to a0
    jr      ra                      # Return

error_terminate:
    blt     a2, t0, set_error_36     # Set error code 36 if element count < 1
    li      a0, 37                   # Set error code 37 if stride < 1
    j       exit                     # Jump to exit

set_error_36:
    li      a0, 36                   # Set error code 36 for invalid element count
    j       exit                     # Jump to exit

