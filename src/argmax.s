.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    # TODO: Add your own implementation
    mv      t0, a0                  # t0 = integer adress
    li      t1, 1                   # t1 = 1 (i)
    lw      t2, 0(t0)               # t2 = MEM[t0]
    li      t3, 0                   # t3 = argmax

loop_start:
    addi    t1, t1, 1               # t1++
    addi    t0, t0, 4               # t0 += 4 (To next int)
    blt     a1, t1, done            # if( a1 < i ) finish loop
    lw      t4, 0(t0)               # t4 = MEM[t0]
    bge     t2, t4, loop_start      # if t2 >= t4 continue loop
    mv      t2, t4                  # t2 = t4
    addi    t3, t1, -1              # t3 = index of argmax
    j       loop_start

handle_error:
    li a0, 36
    j exit

done:
    mv      a0, t3
    jr      ra