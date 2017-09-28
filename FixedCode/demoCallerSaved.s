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
# Registers: $t0 = a, $t1 = b, $t2 = c

main:
  addi $t0, $zero, 4      # int a = 4
  addi $t1, $zero, 6      # int b = 6
  addi $t2, $zero, 74     # int c = 74

  addi $v0, $zero, 4      # print string on syscall
  la $a0, old             # load string address of "The old values of a, b, and c are"
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $t0     # load a
  syscall                 # print a

  addi $v0, $zero, 4      # print string on syscall
  la $a0, separator       # load string address of ", "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $t1     # load b
  syscall                 # print b

  addi $v0, $zero, 4      # print string on syscall
  la $a0, separator       # load string address of ", "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $t2     # load c
  syscall                 # print c

  addi $v0, $zero, 4      # print string on syscall
  la $a0, newline         # load string address of "\n"
  syscall                 # print string

  ##### Because we know we'll need $t0-$t2 later, we need to push it to the stack #####
  
  addi $sp, $sp, -12      # allocate 3 words of space on the stack
  sw $t0, 8($sp)          # store a at the top of the stack
  sw $t1, 4($sp)          # store b in the stack next
  sw $t2, 0($sp)          # store c at the bottom of the stack next

  jal sum                 # call procedure sum

  lw $t2, 0($sp)          # restore c from the stack
  lw $t1, 4($sp)          # restore b from the stack
  lw $t0, 8($sp)          # restore a from the stack
  addi $sp, $sp, 12       # pop the stack

  addi $v0, $zero, 4      # print string on syscall
  la $a0, new             # load string address of "The new values of a, b, and c are"
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $t0     # load a
  syscall                 # print a

  addi $v0, $zero, 4      # print string on syscall
  la $a0, separator       # load string address of ", "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $t1     # load b
  syscall                 # print b

  addi $v0, $zero, 4      # print string on syscall
  la $a0, separator       # load string address of ", "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $t2     # load c
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
# Registers: $t0 = x, $t1 = y, $t2 = x + y

sum:
  addi $t0, $zero, 2      # load 2 into x
  addi $t1, $zero, 2      # load 2 into y
  add $t2, $t0, $t1       # store the sum of x and y into $t2

  addi $v0, $zero, 4      # print string on syscall
  la $a0, sumstring       # load string address of "The sum of "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $t0     # load x
  syscall                 # print x

  addi $v0, $zero, 4      # print string on syscall
  la $a0, sumand          # load string address of " and "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $t1     # load y
  syscall                 # print y

  addi $v0, $zero, 4      # print string on syscall
  la $a0, sumis           # load string address of " is "
  syscall                 # print string

  addi $v0, $zero, 1      # print int on syscall
  add $a0, $zero, $t2     # load x + y
  syscall                 # print x + y

  addi $v0, $zero, 4      # print string on syscall
  la $a0, newline         # load string address of "\n"
  syscall                 # print string

  jr $ra                  # return back to where procedure was called
