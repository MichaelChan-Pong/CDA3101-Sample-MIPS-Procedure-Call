.data

old: .asciiz "The old values of a, b, and c are "
new: .asciiz "The new values of a, b, and c are "
sumstring: .asciiz "The sum of "
sumand: .asciiz " and "
sumis: .asciiz " is "
message: .asciiz "Isn't discussion great?\n"
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
#   c = sum(a, b);
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

  add $a0, $s0, $zero     # store a in first argument register
  add $a1, $s1, $zero     # store b in second argument register
  jal sum                 # call sum procedure
  add $s2, $v0, $zero     # store returned value in c

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
# Procedures
#
#

###################################
# Sum
#
# int sum (int x, int y) {
#   printMessage();
#   printf("The sum of 2 and 2 is %d\n", x + y);
#   return x + y;
# }
#
# Registers: $s0 = x, $s1 = y, $s2= x + y

sum:
  ##### PROLOGUE #####
  ##### TODO: Consider which registers need to be saved to the stack here #####
  addi $sp, $sp, -12      # allocate 3 words on the stack
  sw $s0, 8($sp)          # store $s0 (a) at top of stack
  sw $s1, 4($sp)          # store $s1 (b) next
  sw $s2, 0($sp)          # store $s2 (c) at bottom of stack

  ##### BODY #####
  ##### TODO: Consider which registers need to be saved to the stack here #####
  jal printMessage        # call printMessage procedure

  add $s0, $zero, $a0     # load x into $s0
  add $s1, $zero, $a1     # load y into $s1
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
  add $v0, $s2, $zero     # place return value in $v0

  lw $s2, 0($sp)          # load $s2 (c) from bottom of stack
  lw $s1, 4($sp)          # load $s1 (b) from stack
  lw $s0, 8($sp)          # load $s0 (a) from top of stack
  addi $sp, $sp, 12       # deallocate stack

  jr $ra                  # return back to where procedure was called

###################################
# Print Message
#
# void printMessage () {
#   printf("Isn't discussion great?\n");
#   return;
# }
#

printMessage:
  la $a0, message         # load message address in $a0
  addi $v0, $zero, 4      # print string on syscall
  syscall                 # print string

  jr $ra                  # return to callee
