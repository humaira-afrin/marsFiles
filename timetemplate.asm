  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
 time2string:
 	PUSH	($ra)
 	PUSH	($s0)
 	PUSH	($s1)
 	
 	move $s0,$a0
 	move $s1,$a1
 	
 	andi $a0, $s1,0xF000
 	srl $a0,$a0,12
 	jal hexasc
 	nop
 	sb $v0, 5($s0)
 	
 	
 	
 	andi $a1, $s1,0xF00
 	srl $a1,$a1,8
 	jal hexasc
 	nop
 	sb $v0, 4($s0)
 	nop
 	
 
 	
 	addi $t0, $0, 0x3a
 	jal hexasc
 	nop
 	sb $v0, 3($s0)
 	nop
 	
 	
 	andi $a1, $s1,0xF0
 	srl $a1,$a1,4
 	jal hexasc
 	nop
 	sb $v0, 2($s0)
 	nop
 	

 	andi $a1, $s1,0xF
 	jal hexasc
 	nop
 	sb $v0, 1($s0)
 	nop
 	
 	addi $t1, $0,0x00
 	jal hexasc
 	nop
 	sb $v0, 0($s0)
 	
 	POP ($s1)
 	POP ($s0)
 	POP ($ra)
 	
 	jr $ra
 	nop
  
  delay:
  	jr $ra
  	nop
  
  hexasc:
  	andi $v0, $a0, 0xf
  	addi $v0, $v0, 0x30
  	slti $v1,$v0,0x39
  	beq $v1,1,L2
 	addi $v0,$v0,7
 
 
 L2:
 	jr $ra
 
