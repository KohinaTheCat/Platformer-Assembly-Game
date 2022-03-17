##################################################################### 
# 
# CSCB58 Winter 2022 Assembly Final Project 
# University of Toronto, Scarborough 
# 
# Student: Clara Chick, 1005946764, chickcla, clara.chick@mail.utoronto.ca
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 4 (update this as needed)  
# - Unit height in pixels: 4 (update this as needed) 
# - Display width in pixels: 256 (update this as needed) 
# - Display height in pixels: 256 (update this as needed) 
# - Base Address for Display: 0x10008000 ($gp) 
# 
# Which milestones have been reached in this submission? 
# (See the assignment handout for descriptions of the milestones) 
# - Milestone 3
# 
# Which approved features have been implemented for milestone 3? 
# (See the assignment handout for the list of additional features) 
# 1. (fill in the feature, if any) 
# 2. (fill in the feature, if any) 
# 3. (fill in the feature, if any) 
# ... (add more if necessary) 
# 
# Link to video demonstration for final submission: 
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it! 
# 
# Are you OK with us sharing the video with people outside course staff? 
# - yes, and please share this project github link as well! 
# 
# Any additional information that the TA needs to know: 
# - (write here, if any) 
# 
##################################################################### 

# Define my constants
.eqv BASE_ADDRESS 0x10008000
.eqv JUMP_FALL_TIME 50
.eqv LEFT 97
.eqv RIGHT 100
.eqv UP 119
.eqv DOWN 115
.eqv P 112
.eqv GREEN 0x00FF00
.eqv BLACK 0x000000
.eqv GREY 0xC0C0C0
.eqv PINK 0xFFC0CB
.eqv C_PINK 0xFFC0CC
.eqv RED 0xFF0000

.data
	PLAYER: .word 3840 3844 3968 3972
	nl: 	.word '\n'
	HEALTH: .word 2

.text

.globl main
	
main:
	li $t0, BASE_ADDRESS
	li $t1, BLACK
	
	# Draw Objects
	# Heart 1
	li $t2, PINK
	sw $t2,	3236($t0)
	sw $t2,	3244($t0)
	li $t2, C_PINK
	sw $t2,	3368($t0)
	# Heart 2
	li $t2, PINK
	sw $t2,	2880($t0)
	sw $t2,	2888($t0)
	li $t2, C_PINK
	sw $t2,	3012($t0)
	
	li $t2, GREEN
	
	# Init. double jump flag
	addi $s0 $zero, 0
	
	# Draw inital player
	sw $t2,	3840($t0)
	sw $t2,	3844($t0)
	sw $t2,	3968($t0)
	sw $t2,	3972($t0)
	
	j loop
	
	# Terminate the program gracefully, but should never reach this
	li $v0, 10
	syscall
	
reset:
	# Reset player:
	# Get player offset
	lw $t6, 0($t5)
	lw $t7, 4($t5)
	lw $t8, 8($t5)
	lw $t9, 12($t5)
	# Colour old player black
	add $t3, $t6, $t0
	sw $t1, 0($t3)
	add $t3, $t7, $t0
	sw $t1, 0($t3)
	add $t3, $t8, $t0
	sw $t1, 0($t3)
	add $t3, $t9, $t0
	sw $t1, 0($t3)
	# Set init. player values
	addi $t6, $zero, 1280
	addi $t7, $zero, 1284
	addi $t8, $zero, 1408
	addi $t9, $zero, 1412
	# Save to array
	sw $t6, 0($t5)
	sw $t7, 4($t5)
	sw $t8, 8($t5)
	sw $t9, 12($t5)
	# Colour init. player values
	sw $t2,	1280($t0)
	sw $t2,	1284($t0)
	sw $t2,	1408($t0)
	sw $t2,	1412($t0)
	
	j loop
	
loop:
	# Check for  keypress
	li $t9, 0xffff0000  
	lw $t8, 0($t9) 
	beq $t8, 1, keypress_happened  
	
	# Draw platforms
	li $t2, GREY
	# Platform 1
	sw $t2,	3488($t0)
	sw $t2,	3492($t0)
	sw $t2,	3496($t0)
	sw $t2,	3500($t0)
	# Platform 2
	sw $t2,	3132($t0)
	sw $t2,	3136($t0)
	sw $t2,	3140($t0)
	sw $t2,	3144($t0)
	# Platform 3
	sw $t2,	2776($t0)
	sw $t2,	2780($t0)
	sw $t2,	2784($t0)
	sw $t2,	2788($t0)
	
	li $t2, GREEN
	
	jal gravity 
	
	j loop

keypress_happened:
	# Check to see what key was pressed
	lw $t3, 4($t9)
	
	# Check up
	beq $t3, UP, on_up
	# Check left
	beq $t3, LEFT, on_left
	# Check right
	beq $t3, RIGHT, on_right
	
	# Check p
	beq $t3, P, on_p
	
	j loop
	
on_left:
	# Get location of player
	la $t5, PLAYER
	
	# Read location of player, let $t6-9 store the offset
	# [ t6 | t7 ]
	# [ t8 | t9 ]
	lw $t6, 0($t5)
	lw $t7, 4($t5)
	lw $t8, 8($t5)
	lw $t9, 12($t5)
	
	# If player is at the border, do not do anything
	addi $t3, $zero, 128
	div $t6, $t3
	mfhi $t3
	beq $t3, $zero, loop
	
	# If player is about to touch the center of the heart
	li $t4, C_PINK
	# Check t8
	add $t3, $t8, $t0
	add $t3, $t3, -4
	addi $a0, $t3, 0 # Load addr of 'center' into a0
	lw $t3 0($t3)
	bne $t3, $t4, check_next_left
	jal obtain_heart
check_next_left:
	# Check t6
	add $t3, $t6, $t0
	add $t3, $t3, -4
	addi $a0, $t3, 0 # Load addr of 'center' into a0
	lw $t3 0($t3)
	bne $t3, $t4, continue_left
	# Push offset of center of heart to stack
	jal obtain_heart
	
continue_left:
	# Colour old location as black, let $t3 the address to draw on
	add $t3, $t7, $t0
	sw $t1, 0($t3)
	add $t3, $t9, $t0
	sw $t1, 0($t3)

	# Redraw player in new location
	# Store new offset
	addi $t6, $t6, -4
	addi $t7, $t7, -4
	addi $t8, $t8, -4
	addi $t9, $t9, -4
	
	# Save new location to array
	sw $t6, 0($t5)
	sw $t7, 4($t5)
	sw $t8, 8($t5)
	sw $t9, 12($t5)
	
	# Get new address and draw new player
	add $t3, $t6, $t0 
	sw $t2,	0($t3)
	add $t3, $t8, $t0
	sw $t2,	0($t3)
	
	j loop

on_right:
	# Get location of player
	la $t5, PLAYER
	
	# Read location of player, let $t6-9 store the offset
	# [ t6 | t7 ]
	# [ t8 | t9 ]
	lw $t6, 0($t5)
	lw $t7, 4($t5)
	lw $t8, 8($t5)
	lw $t9, 12($t5)
	
	# If player is at the border, do not do anything
	addi $t3, $zero, 128
	subi $t4, $t7, 124
	div $t4, $t3
	mfhi $t4
	beq $t4, $zero, loop
	
	# If player is about to touch the center of the heart
	li $t4, C_PINK
	# Check t7
	add $t3, $t7, $t0
	add $t3, $t3, 4
	addi $a0, $t3, 0 # Load addr of 'center' into a0
	lw $t3 0($t3)
	bne $t3, $t4, check_next_right
	jal obtain_heart
check_next_right:
	# Check t9
	add $t3, $t9, $t0
	add $t3, $t3, 4
	addi $a0, $t3, 0 # Load addr of 'center' into a0
	lw $t3 0($t3)
	bne $t3, $t4, continue_right
	# Push offset of center of heart to stack
	jal obtain_heart
	
continue_right:
	# Colour old location as black, let $t3 the address to draw on
	add $t3, $t6, $t0
	sw $t1, 0($t3)
	add $t3, $t8, $t0
	sw $t1, 0($t3)
	
	# Redraw player in new location
	# Store new offset
	addi $t6, $t6, 4
	addi $t7, $t7, 4
	addi $t8, $t8, 4
	addi $t9, $t9, 4
	
	# Save new location to array
	sw $t6, 0($t5)
	sw $t7, 4($t5)
	sw $t8, 8($t5)
	sw $t9, 12($t5)
	
	# Get new address and draw new player
	add $t3, $t7, $t0 
	sw $t2,	0($t3)
	add $t3, $t9, $t0
	sw $t2,	0($t3)
	
	j loop


jump:		
	# Get location of player
	la $t5, PLAYER
	
	# Read location of player, let $t6-9 store the offset
	# [ t6 | t7 ]
	# [ t8 | t9 ]
	lw $t6, 0($t5)
	lw $t7, 4($t5)
	lw $t8, 8($t5)
	lw $t9, 12($t5)
	
	# If player is at the border, do not do anything
	subi $t3, $t6, 128
	blez $t3, loop
	
	# Colour old location as black, let $t3 the address to draw on
	add $t3, $t8, $t0
	sw $t1, 0($t3)
	add $t3, $t9, $t0
	sw $t1, 0($t3)

	# Redraw player in new location
	# Store new offset
	addi $t6, $t6, -128
	addi $t7, $t7, -128
	addi $t8, $t8, -128
	addi $t9, $t9, -128
	
	# Save new location to array
	sw $t6, 0($t5)
	sw $t7, 4($t5)
	sw $t8, 8($t5)
	sw $t9, 12($t5)
	
	# Get new address and draw new player
	add $t3, $t6, $t0 
	sw $t2,	0($t3)
	add $t3, $t7, $t0
	sw $t2,	0($t3)
	
	# Timer to "animate" jump
	li $v0, 32
        li $a0, JUMP_FALL_TIME
        syscall
	
	jr $ra


on_up:
	# Add to jump counter
	addi $s0 $s0, 1
	addi $t3 $zero, 2
	# If jump counter == 2 then don't jump further
	bgt $s0 $t3 loop
	
	jal jump
	jal jump
	jal jump
	jal jump
	
	j loop

obtain_heart:
	sw $t1, 0($a0)
	subi $a0, $a0, 132
	sw $t1, 0($a0)
	addi $a0, $a0, 8
	sw $t1, 0($a0)
	
	# Add one heart to health
	la $t4, HEALTH	
	lw $t3, 0($t4)	
	addi $t3 $t3 1
	sw $t3 0($t4)

	jr $ra
	

gravity:
	# Get location of player
	la $t5, PLAYER
	
	# Read location of player, let $t6-9 store the offset
	# [ t6 | t7 ]
	# [ t8 | t9 ]
	lw $t6, 0($t5)
	lw $t7, 4($t5)
	lw $t8, 8($t5)
	lw $t9, 12($t5)
	
	# If player is at the border, do not do anything
	subi $t3, $t8, 3968
	bgez $t3, hit_ground
	
	# Check if pixel below is a GREY platform
	add $t3, $t9, $t0
	add $t3, $t3, 128
	lw $t3 0($t3)
	li $t4, GREY
	beq $t3, $t4, hit_ground
	
	add $t3, $t8, $t0
	add $t3, $t3, 128
	lw $t3 0($t3)
	li $t4, GREY
	beq $t3, $t4, hit_ground
	
	# Colour old location as black, let $t3 the address to draw on
	add $t3, $t6, $t0
	sw $t1, 0($t3)
	add $t3, $t7, $t0
	sw $t1, 0($t3)

	# Redraw player in new location
	# Store new offset
	addi $t6, $t6, 128
	addi $t7, $t7, 128
	addi $t8, $t8, 128
	addi $t9, $t9, 128
	
	# Save new location to array
	sw $t6, 0($t5)
	sw $t7, 4($t5)
	sw $t8, 8($t5)
	sw $t9, 12($t5)
	
	# Get new address and draw new player
	add $t3, $t8, $t0 
	sw $t2,	0($t3)
	add $t3, $t9, $t0
	sw $t2,	0($t3)
	
	# Timer to "animate" fall
	li $v0, 32
        li $a0, JUMP_FALL_TIME
        syscall
        
	jr $ra
	
hit_ground:
	# Reset jump counter
	addi $s0 $zero, 0
	
	j loop
	

on_p:
	j reset
	j loop
	
	
	