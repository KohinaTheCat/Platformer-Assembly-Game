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
.eqv JUMP_FALL_TIME 100
.eqv PLATFORM_MOVE_TIME 100
.eqv LEFT 97
.eqv RIGHT 100
.eqv UP 119
.eqv DOWN 115
.eqv P 112
.eqv GREEN 0xc8fcb6
.eqv BLACK 0x000000
.eqv GREY 0xC0C0C0
.eqv LIGHT_GREY 0x63454b
.eqv PINK 0xFFC0CB
.eqv C_PINK 0xFFC0CC
.eqv YELLOW 0xecdb6f
.eqv RED 0xFF0000
.eqv P_RED 0xec6f6f

.data
	PLAYER: .word 3840 3844 3968 3972
	nl: 	.word '\n'
	HEALTH: .word 2
	HEALTH_BAR:	.word 244
	ENEMY:	.word 692 720
	ENEMY2:	.word	720

.text

.globl main
	
main:
	li $t0, BASE_ADDRESS
	li $t1, BLACK
	li $a3, YELLOW
	
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
	
	# Health bar
	sw $t2,	248($t0)
	sw $t2,	244($t0)
	li $t2, LIGHT_GREY
	sw $t2,	240($t0)
	sw $t2,	236($t0)
	
	# Win Object
	li $t2, YELLOW
	sw $t2,	2528($t0)
	
	# Enemies
	li $t2, RED
	# Enemy 1
	sw $t2, 692($t0)
	sw $t2, 560($t0)
	sw $t2, 568($t0)
	# Enemy 2
	sw $t2,	720($t0)
	sw $t2,	588($t0)
	sw $t2,	596($t0)
	
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
	# Colour background black
	add $t3, $t0, 4096
	add $t4, $t0, 0
	reset_loop:
	bge $t4, $t3, reset_loop_done
	sw $t1, 0($t4)
	add $t4, $t4, 4
	j reset_loop
	
	reset_loop_done:
	
	# Reset player
	# Set init. player values
	# Get location of player
	la $t5, PLAYER
	addi $t6, $zero, 3840
	addi $t7, $zero, 3844
	addi $t8, $zero, 3968
	addi $t9, $zero, 3972
	# Save to array
	sw $t6, 0($t5)
	sw $t7, 4($t5)
	sw $t8, 8($t5)
	sw $t9, 12($t5)
	
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
	
	# Health bar
	sw $t2,	248($t0)
	sw $t2,	244($t0)
	li $t2, LIGHT_GREY
	sw $t2,	240($t0)
	sw $t2,	236($t0)
	
	# Win Object
	li $t2, YELLOW
	sw $t2,	2528($t0)
	
	li $t2, GREEN
	# Colour init. player values
	sw $t2,	3840($t0)
	sw $t2,	3844($t0)
	sw $t2,	3968($t0)
	sw $t2,	3972($t0)
	
	# Save $ra onto the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal draw_platforms
	# Pop saved $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# Reset Health
	la $t5, HEALTH
	addi $t6, $zero, 2
	sw $t6, 0($t5)
	
	# Reset Health Bar
	la $t5, HEALTH_BAR
	addi $t6, $zero, 244
	sw $t6, 0($t5)
	
	# Reset Enemies
	la $t5, ENEMY
	addi $t6, $zero, 692
	sw $t6, 0($t5)
	la $t5, ENEMY2
	addi $t6, $zero, 720
	sw $t6, 0($t5)
	
	# Reset vars
	li $t0, BASE_ADDRESS
	li $t1, BLACK
	li $t2, GREEN
	li $a3, YELLOW
	
	j loop
	
loop:
	# Check for  keypress
	li $t9, 0xffff0000  
	lw $t8, 0($t9) 
	beq $t8, 1, keypress_happened  
	
	jal draw_platforms
	
	# Get location of enemy
	la $t5, ENEMY
	jal enemy_fall
	# Get location of enemy
	la $t5, ENEMY2
	jal enemy2_fall
	
	# Timer to "animate" fall
	li $v0, 32
        li $a0, JUMP_FALL_TIME
        syscall
	
	jal gravity 
	
	j loop
	

draw_platforms:
	# Draw platforms
	li $t2, GREY
	lw $t3 ENEMY
	
	# Platform 1
	sw $t2,	3488($t0)
	sw $t2,	3492($t0)
	sw $t2,	3496($t0)
	sw $t2,	3500($t0)
	
	bgt $t3, 2000, show_middle
	
	# Platform 2
	sw $t2,	3132($t0)
	sw $t2,	3136($t0)
	sw $t2,	3140($t0)
	sw $t2,	3144($t0)
	li $t2, BLACK
	# Platform 3
	sw $t2,	2776($t0)
	sw $t2,	2780($t0)
	sw $t2,	2784($t0)
	sw $t2,	2788($t0)
	
	li $t2, GREEN
	
	jr $ra

show_middle: bgt $t3, 3000, show_odd
	# Platform 3
	sw $t2,	2776($t0)
	sw $t2,	2780($t0)
	sw $t2,	2784($t0)
	sw $t2,	2788($t0)
	# Platform 2
	sw $t2,	3132($t0)
	sw $t2,	3136($t0)
	sw $t2,	3140($t0)
	sw $t2,	3144($t0)
	
	li $t2, GREEN
	
	jr $ra
	
show_odd:
	# Platform 3
	sw $t2,	2776($t0)
	sw $t2,	2780($t0)
	sw $t2,	2784($t0)
	sw $t2,	2788($t0)
	li $t2, BLACK
	# Platform 2
	sw $t2,	3132($t0)
	sw $t2,	3136($t0)
	sw $t2,	3140($t0)
	sw $t2,	3144($t0)
	
	li $t2, GREEN
	
	jr $ra

keypress_happened:
	li $t9, 0xffff0000 
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
	beq $t3, $a3, win
	bne $t3, $t4, check_next_right
	jal obtain_heart
check_next_right:
	# Check t9
	add $t3, $t9, $t0
	add $t3, $t3, 4
	addi $a0, $t3, 0 # Load addr of 'center' into a0
	lw $t3 0($t3)
	beq $t3, $a3, win
	bne $t3, $t4, continue_right
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
	
	# If player is about to touch the center of the heart
	li $t4, C_PINK
	# Check t7
	add $t3, $t7, $t0
	add $t3, $t3, -128
	addi $a0, $t3, 0 # Load addr of 'center' into a0
	lw $t3 0($t3)
	bne $t3, $t4, check_next_jump
	# Save $ra onto the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal obtain_heart
	# Pop saved $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
check_next_jump:
	# Check t6
	add $t3, $t6, $t0
	add $t3, $t3, -128
	addi $a0, $t3, 0 # Load addr of 'center' into a0
	lw $t3 0($t3)
	bne $t3, $t4, continue_jump
	
	# Save $ra onto the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal obtain_heart
	# Pop saved $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
continue_jump:
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
	
	# Draw Platform
	# Save $ra onto the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal draw_platforms
	
	# Pop saved $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
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
	
tick:
	li $v0, 32
        li $a0, JUMP_FALL_TIME
        syscall
        
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
	
	# If player is about to touch the center of the heart
	li $t4, C_PINK
	# Check t9
	add $t3, $t9, $t0
	add $t3, $t3, 128
	addi $a0, $t3, 0 # Load addr of 'center' into a0
	lw $t3 0($t3)
	bne $t3, $t4, check_next_gravity
	# Save $ra onto the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal obtain_heart
	# Pop saved $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
check_next_gravity:
	# Check t8
	add $t3, $t8, $t0
	add $t3, $t3, 128
	addi $a0, $t3, 0 # Load addr of 'center' into a0
	lw $t3 0($t3)
	bne $t3, $t4, continue_gravity
	# Save $ra onto the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal obtain_heart
	# Pop saved $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
continue_gravity:
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
	
enemy_fall:	
	# Read location of enemy, let $t6 store the offset
	lw $t6, 0($t5)
	
	# Colour old location as black, let $t3 the address to draw on
	add $t3, $t6, $t0
	sw $t1, 0($t3)
	add $t3, $t3, -132
	sw $t1, 0($t3)
	add $t3, $t3, 8
	sw $t1, 0($t3)
	
	# If player is at the border, reset position to the top
	subi $t3, $t6, 3968
	bltz $t3, continue_enemy_fall

	addi $t6, $zero, 692
	sw $t6, 0($t5)
	
continue_enemy_fall:
	# Redraw enemy in new location and save new offset
	addi $t6, $t6, 128
	sw $t6, 0($t5)
	
	# Get new address and draw new player
	li $t2, RED
	li $t4, GREEN
	
	add $t6, $t6, $t0
	# If enemy head is about to touch player
	lw $t3 0($t6)
	beq $t3, $t4, lose_heart
	# Else colour head
	sw $t2,	0($t6)
	
	add $t6, $t6, -132
	# If enemy head is about to touch player
	lw $t3 0($t6)
	beq $t3, $t4, lose_heart
	sw $t2,	0($t6)
	
	add $t6, $t6, 8
	# If enemy head is about to touch player
	lw $t3 0($t6)
	beq $t3, $t4, lose_heart
	sw $t2,	0($t6)
        
        li $t2, GREEN
        
	jr $ra

enemy2_fall:	
	# Read location of enemy, let $t6 store the offset
	lw $t6, 0($t5)
	
	# Colour old location as black, let $t3 the address to draw on
	add $t3, $t6, $t0
	sw $t1, 0($t3)
	add $t3, $t3, -132
	sw $t1, 0($t3)
	add $t3, $t3, 8
	sw $t1, 0($t3)
	
	# If player is at the border, reset position to the top
	subi $t3, $t6, 3968
	bltz $t3, continue_enemy2_fall

	addi $t6, $zero, 720
	sw $t6, 0($t5)
	
continue_enemy2_fall:
	# Redraw enemy in new location and save new offset
	addi $t6, $t6, 128
	sw $t6, 0($t5)
	
	# Get new address and draw new player
	li $t2, RED
	li $t4, GREEN
	
	add $t6, $t6, $t0
	# If enemy head is about to touch player
	lw $t3 0($t6)
	beq $t3, $t4, lose_heart
	# Else colour head
	sw $t2,	0($t6)
	
	add $t6, $t6, -132
	# If enemy head is about to touch player
	lw $t3 0($t6)
	beq $t3, $t4, lose_heart
	sw $t2,	0($t6)
	
	add $t6, $t6, 8
	# If enemy head is about to touch player
	lw $t3 0($t6)
	beq $t3, $t4, lose_heart
	sw $t2,	0($t6)
        
        li $t2, GREEN
        
	jr $ra

lose_heart:
	# Enemy1
	# Colour previous enemy black
	# Read location of enemy, let $t6 store the offset
	la $t5, ENEMY
	lw $t6, 0($t5)
	add $t6, $t6, $t0
	sw $t1,	0($t6)
	add $t6, $t6, -132
	sw $t1,	0($t6)
	add $t6, $t6, 8
	sw $t1,	0($t6)

	# Reset enemies to the top
	addi $t6, $zero, 692
	sw $t6, 0($t5)
	
	# Enemy2
	la $t5, ENEMY2
	addi $t6, $zero, 720
	lw $t6, 0($t5)
	add $t6, $t6, $t0
	sw $t1,	0($t6)
	add $t6, $t6, -132
	sw $t1,	0($t6)
	add $t6, $t6, 8
	sw $t1,	0($t6)
	# Reset enemies to the top
	addi $t6, $zero, 720
	sw $t6, 0($t5)
	
	# Subtract one health from player
	la $t4, HEALTH	
	lw $t3, 0($t4)	
	subi $t3 $t3 1
	sw $t3 0($t4)
	
	# Update Health Bar
	la $t4, HEALTH_BAR
	lw $t3, 0($t4)
	addi $t3, $t3 4 # New offset
	sw $t3 0($t4) # Save new offset
	subi $t3, $t3 4 # Draw old offset
	add $t3, $t3, $t0 # New location
	li $t2, LIGHT_GREY
	sw $t2 0($t3) # Draw to Health Bar
	
	# Animate player
	# Get location of player
	la $t5, PLAYER
	# Read location of player, let $t6-9 store the offset
	# [ t6 | t7 ]
	# [ t8 | t9 ]
	lw $t6, 0($t5)
	lw $t7, 4($t5)
	lw $t8, 8($t5)
	lw $t9, 12($t5)
	
	li $t2, P_RED
	add $t3, $t6, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t7, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t9, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t8, $t0
	sw $t2,	0($t3)
	
	li $t2, GREEN
	jal tick
	add $t3, $t6, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t7, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t9, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t8, $t0
	sw $t2,	0($t3)
	jal tick
	
	# Check if health is 0
	la $t4, HEALTH
	lw $t3, 0($t4)	
	beqz $t3, lose
	
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
	
	# Update Health Bar
	la $t4, HEALTH_BAR
	lw $t3, 0($t4)
	addi $t3, $t3 -4 # New offset
	sw $t3 0($t4) # Save new offset
	
	add $t3, $t3, $t0 # New location
	li $t2, C_PINK
	sw $t2 0($t3) # Draw to Health Bar
	
	# Save $ra onto the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# Animate Player
	li $t2, YELLOW
	add $t3, $t6, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t7, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t9, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t8, $t0
	sw $t2,	0($t3)
	
	li $t2, GREEN
	jal tick
	add $t3, $t6, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t7, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t9, $t0
	sw $t2,	0($t3)
	jal tick
	add $t3, $t8, $t0
	sw $t2,	0($t3)
	jal tick
	
	# Pop saved $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra

hit_ground:
	# Reset jump counter
	addi $s0 $zero, 0
	
	j loop

win:
	li $t9, 0xffff0000 
	# Check to see what key was pressed
	lw $t3, 4($t9)

	# Check p
	beq $t3, P, on_p
	
	# Draw i
	sw $a3,	1852($t0)
	sw $a3,	2108($t0)
	sw $a3,	2236($t0)
	# Drawn n
	sw $a3,	2116($t0)
	sw $a3,	2244($t0)
	sw $a3,	2120($t0)
	sw $a3,	2124($t0)
	sw $a3,	2252($t0)
	# Draw w
	sw $a3,	2100($t0)
	sw $a3,	2092($t0)
	sw $a3,	2084($t0)
	sw $a3,	2224($t0)
	sw $a3,	2216($t0)
	# Draw !
	sw $a3,	2260($t0)
	sw $a3,	1876($t0)
	sw $a3,	2004($t0)
	
	j win
	
lose:

	li $t9, 0xffff0000 
	# Check to see what key was pressed
	lw $t3, 4($t9)

	# Check p
	beq $t3, P, on_p
	
	li $t2, RED
	# Draw a
	sw $t2,	2236($t0)
	sw $t2,	2232($t0)
	sw $t2,	2228($t0)
	sw $t2,	2104($t0)
	sw $t2,	2100($t0)
	# Draw f
	sw $t2,	2216($t0)
	sw $t2,	2088($t0)
	sw $t2,	1960($t0)
	sw $t2,	1832($t0)
	sw $t2,	1836($t0)
	sw $t2,	1956($t0)
	# Draw i
	sw $t2,	2244($t0)
	sw $t2,	2116($t0)
	sw $t2,	1860($t0)
	# Draw l
	sw $t2,	2252($t0)
	sw $t2,	2124($t0)
	sw $t2,	1996($t0)
	sw $t2,	1868($t0)
	# Draw .
	sw $t2,	2260($t0)
	
	j lose

on_p:
	j reset
	j loop
	
	
	
