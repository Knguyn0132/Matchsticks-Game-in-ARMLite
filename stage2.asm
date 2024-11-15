
MOV R5, #askMatchsticks
MOV R7, #newline

MOV R4, #askName
MOV R8, #myName
MOV R9, #matchsticksNum

STR R4, .WriteString
MOV R4, #inputName
STR R4, .ReadString


prompt:
STR R5, .WriteString
LDR R6, .InputNum
CMP R6, #10
BLT prompt
CMP R6, #100
BGT prompt

STR R8, .WriteString
STR R4, .WriteString
STR R7, .WriteString
STR R9, .WriteString
STR R6, .WriteUnsignedNum

game: 
	STR R7, .WriteString
	MOV R5, #player
	STR R5, .WriteString
	STR R4, .WriteString
	MOV R10, #thereare
	STR R10, .WriteString
	STR R6, .WriteUnsignedNum
	MOV R8, #remaining
	STR R8, .WriteString

	STR R7, .WriteString

	STR R5, .WriteString
	STR R4, .WriteString
	
askremovedsticks:
	MOV R9, #remove
	STR R9, .WriteString
	LDR R11, .InputNum
	CMP R11, #1
	BLT askremovedsticks
	CMP R11, #7
	BGT askremovedsticks
	CMP R11, R6
	BGT game
	SUB R6, R6, R11
	CMP R6, #0
	BNE game

	STR R7, .WriteString
	MOV R12, #gameover
	STR R12, .WriteString



HALT

askName: .ASCIZ "Please enter your name\n"
askMatchsticks: .ASCIZ "How many matchsticks (10-100)\n"
newline: .ASCIZ "\n"
inputName: .BLOCK 128
myName: .ASCIZ "Player 1 is: "
matchsticksNum: .ASCIZ "Matchsticks: "

player: .ASCIZ "Player "
thereare: .ASCIZ ", there are "
remaining: .ASCIZ " matchsticks remaning"
remove: .ASCIZ ", how many do you want to remove(1-7)"
gameover: .ASCIZ "Game Over"