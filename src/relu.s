.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li      t0, 1             
    blt     a1, t0, error     
    li      t1, 0

    # TODO: Add your own implementation
    mv      t0, a0                  # t0 = integer adress
    li      t1, 1                   # t1 = 1 (i)

loop_start:
    blt     a1, t1, done            # if( a1 < i ) finish loop
    lw      t2, 0(t0)               # t2 = MEM[t0]
    bge     t2, x0, continue        # if t2>=0 continue loop
    sw      x0, 0(t0)               # MEM[t0] = 0
continue:
    addi    t1, t1, 1               # t1++
    addi    t0, t0, 4               # t0 += 4 (To next int)
    j       loop_start

error:
    li a0, 36          
    j exit

done:
    jr ra