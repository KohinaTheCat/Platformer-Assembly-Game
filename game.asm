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
.eqv LEFT 97
.eqv RIGHT 100
.eqv UP 119
.eqv DOWN 115
.eqv P 112
.eqv GREEN 0x00FF00
.eqv BLACK 0x000000

.data
	PLAYER: .word 1284
	nl: 	.word '\n'

.text

.globl main
	
main:
	li $t0, BASE_ADDRESS
	li $t1, BLACK
	li $t4, GREEN
	
	# Draw inital player
	sw $t4,	1284($t0)
	
	j loop
	
	# Terminate the program gracefully, but should never reach this
	li $v0, 10
	syscall
	
loop:
	# Check for  keypress
	li $t9, 0xffff0000  
	lw $t8, 0($t9) 
	beq $t8, 1, keypress_happened  
	
	j loop

keypress_happened:
	# Check to see what key was pressed
	lw $t2, 4($t9)
	
	# Check left
	beq $t2, LEFT, on_left
	# Check right
	beq $t2, RIGHT, on_right
	# Check up
	beq $t2, UP, on_up
	# Check down
	beq $t2, DOWN, on_down
	# Check p
	beq $t2, P, on_p
	
	j loop
	
on_left:
	# Get location of player
	la $t5, PLAYER
	
	# Read location of player, let $a1 store the offset
	lw $a1, 0($t5)
	
	# Colour old location as black, let $t3 the address to draw on
	add $t3, $a1, $t0
	sw $t1, 0($t3)

	# Redraw player in new location
	addi $a1, $a1, -4 # Get new offset
	add $t3, $a1, $t0 # Get new address
	sw $a1, 0($t5) # Save new location to array
	sw $t4,	0($t3)# Draw player
	
	j loop

on_right:
	# Get location of player
	la $t5, PLAYER
	
	# Read location of player, let $a1 store the offset
	lw $a1, 0($t5)
	
	# Colour old location as black, let $t3 the address to draw on
	add $t3, $a1, $t0
	sw $t1, 0($t3)

	# Redraw player in new location
	addi $a1, $a1, 4 # Get new offset
	add $t3, $a1, $t0 # Get new address
	sw $a1, 0($t5) # Save new location to array
	sw $t4,	0($t3)# Draw player
	
	j loop

on_up:
	# Get location of player
	la $t5, PLAYER
	
	# Read location of player, let $a1 store the offset
	lw $a1, 0($t5)
	
	# Colour old location as black, let $t3 the address to draw on
	add $t3, $a1, $t0
	sw $t1, 0($t3)

	# Redraw player in new location
	addi $a1, $a1, -128 # Get new offset
	add $t3, $a1, $t0 # Get new address
	sw $a1, 0($t5) # Save new location to array
	sw $t4,	0($t3)# Draw player
	
	j loop

on_down:
	# Get location of player
	la $t5, PLAYER
	
	# Read location of player, let $a1 store the offset
	lw $a1, 0($t5)
	
	# Colour old location as black, let $t3 the address to draw on
	add $t3, $a1, $t0
	sw $t1, 0($t3)

	# Redraw player in new location
	addi $a1, $a1, 128 # Get new offset
	add $t3, $a1, $t0 # Get new address
	sw $a1, 0($t5) # Save new location to array
	sw $t4,	0($t3)# Draw player
	
	j loop

on_p:
	j loop
	
	
	