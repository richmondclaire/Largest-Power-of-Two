#Claire Holt Lab 3 CS301

.data
prompt_to_user: .asciiz "Please enter an integer that is greater than or equal to 1: " # Prompts the user
tooSmallString: .asciiz "You must enter a value equal to or greater than 1.\n"
outputLine1:    .asciiz "The largest power of 2 that fits into "
outputLine2:    .asciiz " is "
newline: .asciiz "\n" # new line

  .text
  .align 2

.globl main
.ent main

main:
      addi $sp, $sp, -4      # Make room for an address on the stack
      sw $ra, 0($sp)         # Push return address onto the stack

      li $v0, 4
      la $a0, prompt_to_user # Load address of string into $a0
      syscall

      li $v0, 5              # Read integer syscall
      syscall                # Read in integer
      move $a1, $v0          # Moves input into a1

      li $v0, 4
      la $a0, outputLine1    # Prints "the largest power of 2 that fits into"
      syscall

      move $a0, $a1
      li $v0, 1
      syscall                # Prints entered number

      li $v0, 4
      la $a0, outputLine2    # Prints "is"
      syscall

      jal LargestPowerCalculator # Jump to LargestPowerCalculator function

      move $a0, $v0  # Move answer to a0 so it can be printed
      li $v0, 1      # After returning from the calculator function, the return
                     # value is stored in $v0.
      syscall        # Execute system call from before and printing an int

      lw $ra, 0($sp)    # Pops off the address saved at beginning from the stack
      addi $sp, $sp, 4  # Returns from main
      jr $ra            # Return from main method

      .end main


.globl LargestPowerCalculator
.ent LargestPowerCalculator

LargestPowerCalculator:
    # a1 is the user input integer

    addi $t0, 2         # Holds the value 2
    addi $t1, 2         # Current value of 2

    while:
    sub $t3, $a1, $t1   # Subtracts the power of two from inputted number
    blez $t3, exit      # If the power of two doesn't fit, exit the program
    mult $t1, $t0       # Moves t0 to be the next power of 2
    mflo $t1            # Store lo register in t1
    addi $t4, 1         # Add one to count
    j while             # This makes the while loop keep repeating

  exit:                     # When execution gets here, t0 has highest power 2
    add $v0, $zero, $t4   # Puts the answer into v0
    jr $ra                # Jump and return to main

.end LargestPowerCalculator
