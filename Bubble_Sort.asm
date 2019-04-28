#------------------------------------------------------------------------------
# Font and Size
#------------------------------------------------------------------------------
# Settings > Editor
# Tab Size:  8
# Font Family: Monospaced
# Font Size: 15
#------------------------------------------------------------------------------
# BubleSort: Sorting with method of bubble
#------------------------------------------------------------------------------
# Setup for start program in MARS:
#		Go to Settings -> Memory Configuration
#		Choose Default (Apply and Close)
#		Assemble program
#		Go to Tools -> Bitmap display
#		Setup display bitmap with:
#			Unit Width in Pixels: 32
#			Unit Height in Pixels: 32
#			Display Width in Pixels: 512
#			Display Height in Pixels: 64
#			Base address for display: ($gp)
#		Click on "Connect to MIPS"
#		Running Program
#		Before running again, click on "reset"
#------------------------------------------------------------------------------
.text		# Code Area
#------------------------------------------------------------------------------
# Program:
#		Sorting array with method of bubble
#		Show in display bitmap, colors matching with array elements
# Algorithm:
#		Print initial message
#		show_array()
#		change = true
#		limit = n-1
#		while (limit > 0) AND (change)
#			change = false
#			for (i = 0 ; i < limit ; i++)
#				if array[i] > array[i+1]
#					swap(&array[i], &array[i+1])
#					change = true
#			show_array()
#			limit--
#		Finish execution of program
#------------------------------------------------------------------------------
# Registers used:
#	$v0 = Syscall ( store service number)
#	$a0 = String for printing
#	$a1 = Address of array[i]	
#	$a2 = Address of array[i + 1]
#       $s1 = Initial address of array
#	$t0 = Variable to true or false
#       $t1 = Variable to store limit
#       $t2 = Variable to store conditions
#	$t3 = Variable to store index in memory
#	$t4 = Index
#	$t5 = Content of array[i]
#	$t6 = Content of array[i + 1]

		# initialization
main:	  	li	$v0, 4			# Syscall to write string in screen
	  	la	$a0, msg1		# $a0 = address of the string to write in screen
	 	syscall				# System Call
	  	jal	show_array    		# Call function show_array
		li 	$t0, 1			# Change = true
	  	la	$t1, n			# $t1 receive addres of n
	  	lw	$t1, 0($t1)		# $t1 receive content of n
	  	addi	$t1, $t1, -1		# Limit = n -1
startwhile:	slt	$t2, $zero, $t1		# 0 < Limit
	  	and	$t2, $t2, $t0		# 0 < Limit AND Change
	  	beq	$t2, $zero, endwhile	# Verifies if the sentence above is false
	  	li	$t0, 0			# Change = false
	  	li	$t4, 0			# i = 0
startfor:  	slt	$t2, $t4, $t1		# i < Limit
	  	beq 	$t2, $zero, endfor	# Verifies if the sentence above is false
	  	la	$s1, array		# Store the initial addres of array
	  	sll	$t3, $t4, 2		# $t3 receive i * 4
	  	add	$a1, $s1, $t3           # $a1 receive the addres of array[i]
	  	lw	$t5, 0($a1)		# Read the content of array[i] in register $t5
	  	addi	$t3, $t4, 1		# i + 1
	  	sll	$t3, $t3, 2		# $t3 receive (i + 1) * 4
	  	add	$a2, $s1, $t3		# $a2 receive address of array[i + 1]
	  	lw	$t6, 0($a2)		# Read the content of array[i + 1] in register $t6
	  	slt	$t2, $t6, $t5  		# array[ i + 1] < array[i]
	  	beq	$t2, $zero, endif	# Verifies if the sentence above is false( if without else)
	  	jal	swap			# Call function swap
	  	li	$t0 , 1			# Change = true 
endif:		addi    $t4, $t4, 1		# i++
		j 	startfor		# Return to start of for
endfor:		jal 	show_array		# Call function show_array
		addi	$t1, $t1, -1		# Limit--
		j	startwhile		# Return to start of while
endwhile:   	addi 	$v0, $zero, 10		# System call to terminate program
	  	syscall				# System call
#------------------------------------------------------------------------------
# Routine	swap($a0, $a1)
#		Swapping values of elements of array in the memory
# Parameters:
#		$a1: Address of array[i] in memory
#		$a2: Address of array[i + 1] in memory
# Registers used:
#		$t0 = Store content of array[i]
#		$t1 = Store content of array[i+1]
#		$sp = Stack to store content of temporary registers

		# Building the function
swap:		addi 	$sp, $sp, -8		# Allocating 2 spaces in stack
		sw 	$t0, 0($sp)		# Store value of $t0 in stack
		sw 	$t1, 4($sp)		# Store value of $t1 in stack
		lw   	$t0, 0($a1)		# $t0 receive content of array[i]
		lw	$t1, 0($a2)		# $t1 receive content of array[i + 1]
		sw	$t0, 0($a2)		# Address of array[i + 1] receive content of array[i]
		sw	$t1, 0($a1)		# Address of array[i] receive content of array[i + 1]
		lw	$t0, 0($sp)		# $t0 restore their content for stack
		lw	$t1, 4($sp)		# $t1 restore their content for stack
		addi	$sp, $sp, 8		# Free space allocated in stack
		jr	$ra			# Return to main function
#------------------------------------------------------------------------------
# Routine 	show_array
#		Show the elements in array calling subroutine for adding colors to elements
# Algorithm:
#		for j = 0 ; j < n ; j++
#			show_element_array(j)
# Registers used:
#	$a0 = Register for index j
#	$t0 = Register for n
#	$t1 = Register for conditions
#	$sp = Stack store the content of $ra and temporary registers

		# Building function
show_array:	addi 	$sp, $sp, -12		# Allocating 3 spaces in stack
		sw	$t0, 0($sp)		# Store the value of $t0
		sw	$t1, 4($sp)		# Store the value of $t1
		sw	$ra, 8($sp)		# Store the value of $ra
		li 	$a0, 0 			# j = 0
		la 	$t0, n   		# Register $t0 receive the address of n
		lw 	$t0, 0($t0)  		# Register $t0 receive the content of n
Rstartfor:	slt 	$t1, $a0, $t0 		# j < n 
		beq 	$t1, $zero, Rendfor 	# Verifies if j < n is false
		jal 	show_element_array	# Call function show_element_array	
		addi 	$a0, $a0, 1		# Does j++
		j 	Rstartfor		# Return to start of for	
Rendfor:	lw	$t0, 0($sp)		# Restore old value of $t0
		lw	$t1, 4($sp)		# Restore old value of $t1
		lw	$ra, 8($sp)		# Restore old value of $ra
		addi	$sp, $sp, 12		# Free space allocated in stack
		jr   	$ra			# Return to main
#------------------------------------------------------------------------------
# Routine	show_element_array(index)
#		Show in display bitmap the color corresponding to element in array[index]
# Algorithm:
#		Save registers in stack
#		Read array[index] in memory
#		Read blue_escale[array[index]] for the memory(color with the element will be draw)
#		Calculate the address in displayer where the element of array must be draw: Initial address of displayer + Index * 4
#		Write the color in this postion on displayer
#		Restore the registers of the stack
# Parameters:
#		$a0: Index of element in array (between 0 and n , correspond the column on display which the element is draw)
# Registers used:
#		$t0: Initial address of array in memory
#		$t1: Addres of array[index] in memory
#		$t2: Array[index] (between 0 and n , correspond to index for color which the element is draw)
#		$t3: Initial address of the blue_escale in memory
#		$t4: Address of blue_escale[array[index]] in memory
#		$t5: Blue_escale[array[index]](color which the element must be draw)
#		$t6: Address in display where the element of array must be draw
#		$gp: Initial address of display

			# Prologue
show_element_array:	addi	$sp, $sp, -28	 # Allocate 7 spaces in stack
			sw	$t0, 0 ($sp)	 # Saves $t0, $t1, $t2, $t3, $t4, $t5, $t6 in stack
			sw	$t1, 4 ($sp)
			sw	$t2, 8 ($sp)
			sw	$t3, 12 ($sp)
			sw	$t4, 16 ($sp)
			sw	$t5, 20 ($sp)
			sw	$t6, 24 ($sp)
			# Read array[index] of the memory
			la	$t0, array	 # $t0 = Initial address of array in memory
			sll	$t1, $a0, 2	 # $t1 = Index * 4
			add	$t1, $t0, $t1	 # $t1 = Address of array[index] in memory
			lw	$t2, 0 ($t1)	 # $t2 = Array[index](index of the color which the element is draw)
						 # Read blue_escale[array[index]] of the memory
			la	$t3, blue_escale # $t3 = Initial address of the blue_escale in memory
			sll	$t4, $t2, 2	 # $t4 = Array[index] * 4
			add	$t4, $t3, $t4	 # $t4 = Address of blue_escale[array[index]] in memory
			lw	$t5, 0 ($t4)	 # $t5 = blue_escale[array[index]](color which the element is draw)
						 # Calculate address in display where the element of array must be draw
			sll	$t6, $a0, 2	 # $t6 = Index * 4
			add	$t6, $gp, $t6	 # $t6 = Initial address of display + index * 4
			sw	$t5, 0 ($t6)	 # Writing the color of element of array in memory area of display bitmap: showed in display
			# Epilogue
			lw	$t0, 0 ($sp)	 # Restore $t0, $t1, $t2, $t3, $t4, $t5, $t6 for stack
			lw	$t1, 4 ($sp)
			lw	$t2, 8 ($sp)
			lw	$t3, 12 ($sp)
			lw	$t4, 16 ($sp)
			lw	$t5, 20 ($sp)
			lw	$t6, 24 ($sp)
			addi	$sp, $sp, 28	 # Free space allocated in stack
			jr	$ra	 	 # Return for the routine
#------------------------------------------------------------------------------
.data		# Data Area
#------------------------------------------------------------------------------
										# Variables and data structures of program
n:				.word 16					# Numbers of elements in the array(max 16)
										# Array for sorting(elements with values between 0 and 15)
array:				.word 9 1 10 2 6 13 15 0 12 5 7 14 4 3 11 8
#array:				.word 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
#array:				.word 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
#array:				.word 9 1 10 2 9 6 13 15 13 0 12 5 6 0 5 7
										# Strings for printing messages
msg1:					.asciiz "\nSorting\n"
error:					.asciiz "Pass\n"
jump:					.asciiz "\n"
									 	# Escale with 16 colors in blue
blue_escale: .word 0x00CCFFFF, 0x00BEEEFB, 0x00B0DDF8, 0x00A3CCF4, 0x0095BBF1, 0x0088AAEE, 0x007A99EA, 0x006C88E7, 0x005F77E3, 0x005166E0, 0x004455DD, 0x003644D9, 0x002833D6, 0x001B22D2, 0x000D11CF, 0x000000CC
#------------------------------------------------------------------------------
