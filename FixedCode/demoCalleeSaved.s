.data

old: .asciiz "The old values of a, b, and c are "
new: .asciiz "The new values of a, b, and c are "
sumstring: .asciiz "The sum of "
sumand: .asciiz " and "
sumis: .asciiz " is "
separator: .asciiz ", "
newline: .asciiz "\n"

.globl main

.text

###################################
# Main function
#
# int main() {
#   int a = 4;
#   int b = 6;
#   int c = 74;
#   printf("The old values of a, b, and c are %d, %d, %d\n", a, b, c);
#   sum();
#   printf("The new values of a, b, and c are %d, %d, %d\n", a, b, c);
#   return 0;
# }
#
# Registers: $s0 = a, $s1 = b, $s2 = c

main:
  addi $s0, $zero, 4      # int a = 4
  addi $s1, $zero, 6      # int b = 6
  addi $s2, $zero, 74     # int c = 74

  addi $v0, $zero, 4      # print string on syscall
  la $a0, old             # load string address of "The old values of a, b, and c are"
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $s0     # load a
  syscall                 # print a

  addi $v0, $zero, 4      # print string on syscall
  la $a0, separator       # load string address of ", "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $s1     # load b
  syscall                 # print b

  addi $v0, $zero, 4      # print string on syscall
  la $a0, separator       # load string address of ", "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $s2     # load c
  syscall                 # print c

  addi $v0, $zero, 4      # print string on syscall
  la $a0, newline         # load string address of "\n"
  syscall                 # print string

  jal sum                 # call procedure sum

  addi $v0, $zero, 4      # print string on syscall
  la $a0, new             # load string address of "The new values of a, b, and c are"
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $s0     # load a
  syscall                 # print a

  addi $v0, $zero, 4      # print string on syscall
  la $a0, separator       # load string address of ", "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $s1     # load b
  syscall                 # print b

  addi $v0, $zero, 4      # print string on syscall
  la $a0, separator       # load string address of ", "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $s2     # load c
  syscall                 # print c

  addi $v0, $zero, 4      # print string on syscall
  la $a0, newline         # load string address of "\n"
  syscall                 # print string

  addi $v0, $zero, 10     # exit program on syscall
  syscall                 # exit program

###################################
# PROCEDURES
#

###################################
# Sum
#
# void sum () {
#   int x = 2;
#   int y = 2;
#   printf("The sum of 2 and 2 is %d\n", x + y);
#   return;
# }
#
# Registers: $s0 = x, $s1 = y, $s2 = x + y

sum:
  ##### PROLOGUE #####

  # Because we know this procedure is going to use registers
  # $s0-$s2, and because these are callee-saved registers,
  # we should preserve these on the stack

  addi $sp, $sp, -12      # allocate 3 words on the stack
  sw $s0, 8($sp)          # store $s0 (a) at top of stack
  sw $s1, 4($sp)          # store $s1 (b) next
  sw $s2, 0($sp)          # store $s2 (c) at bottom of stack

  ##### BODY #####
  addi $s0, $zero, 2      # load 2 into x
  addi $s1, $zero, 2      # load 2 into y
  add $s2, $s0, $s1       # store the sum of x and y into $s2
  
  addi $v0, $zero, 4      # print string on syscall
  la $a0, sumstring       # load string address of "The sum of "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $s0     # load x
  syscall                 # print x

  addi $v0, $zero, 4      # print string on syscall
  la $a0, sumand          # load string address of " and "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $s1     # load y
  syscall                 # print y

  addi $v0, $zero, 4      # print string on syscall
  la $a0, sumis           # load string address of " is "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $s2     # load x + y
  syscall                 # print x + y

  addi $v0, $zero, 4      # print string on syscall
  la $a0, newline         # load string address of "\n"
  syscall                 # print string

  ##### EPILOGUE #####

  # Here we reload the values from the stack and deallocate
  # the stack

  lw $s2, 0($sp)          # load $s2 (c) from bottom of stack
  lw $s1, 4($sp)          # load $s1 (b) from stack
  lw $s0, 8($sp)          # load $s0 (a) from top of stack
  addi $sp, $sp, 12       # pop the stack

  jr $ra                  # return back to where procedure was called
