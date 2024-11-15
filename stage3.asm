promptname:
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

	
	BL askremovedsticks

	BL computersturn
	
	finishedwin:
	MOV R4, #inputName
	STR R4, .WriteString
	MOV R12, #win
	STR R12, .WriteString
	BL convertuptolow

	finishedlose:
	MOV R4, #inputName
	STR R4, .WriteString
	MOV R12, #lose
	STR R12, .WriteString
	BL convertuptolow

	finisheddraw:

	MOV R12, #draw
	STR R12, .WriteString
	BL convertuptolow
	end:
HALT



askremovedsticks:
	STR R5, .WriteString
	STR R4, .WriteString
	MOV R9, #remove
	STR R9, .WriteString
	LDR R11, .InputNum
	CMP R11, #1
	BLT askremovedsticks
	CMP R11, #7
	BGT askremovedsticks
	CMP R11, R6
	BGT game
	CMP R6, #1
	BNE drawcondition1
	STR R11, .WriteUnsignedNum
	MOV R12, #youtake
	STR R12, .WriteString
	SUB R6, R6, R11
	CMP R6, #0
	BEQ finishedlose

drawcondition1:
	STR R11, .WriteUnsignedNum
	MOV R12, #youtake
	STR R12, .WriteString
	SUB R6, R6, R11
	CMP R6, #0
	BEQ finisheddraw

	;;
	;STR R7, .WriteString
	;MOV R5, #player
	;STR R5, .WriteString
	;STR R4, .WriteString
	;MOV R10, #thereare
	;STR R10, .WriteString
	;STR R6, .WriteUnsignedNum
	;MOV R8, #remaining
	;STR R8, .WriteString
	;STR R7, .WriteString
	RET

computersturn:
	push {R3, R4, R5, R9}
	MOV R5, #computer
	STR R5, .WriteString
computerroll:
	LDR R4, .Random
    AND R4, R4, #7
    CMP R4, #0
    BEQ computerroll
    CMP R4, R6
    BGT computerroll

    CMP R6, #1
    BNE drawcondition2

    SUB R6, R6, R4
    STR R4, .WriteUnsignedNum
    MOV R9, #computertakes
    STR R9, .WriteString
    pop {R3, R4, R5}
    CMP R6, #0
    BEQ finishedwin
    BNE game

drawcondition2: 
	SUB R6, R6, R4
    STR R4, .WriteUnsignedNum
    MOV R9, #computertakes
    STR R9, .WriteString
    pop {R3, R4, R5}
    CMP R6, #0
    BEQ finisheddraw
    BNE game
    RET

convertuptolow:
	push {R2, R3, R4, R5, R6}
	MOV R2, #0
	MOV R3, #playagain
	STR R3, .WriteString
	MOV R4, #yesno
	STR R4, .ReadString
	LDRB R5, [R4 + R2]
	CMP R5, #89
	BEQ promptname
	CMP R5, #78
	BEQ end
	CMP R5, #121
	BEQ promptname
	CMP R5, #110
	BEQ end
	B convertuptolow
	pop {R3, R4, R5, R6}
RET




;;;;;;
askName: .ASCIZ "Please enter your name\n"
askMatchsticks: .ASCIZ "How many matchsticks (10-100)\n"
newline: .ASCIZ "\n"
inputName: .BLOCK 128
myName: .ASCIZ "Player 1 is: "
matchsticksNum: .ASCIZ "Matchsticks: "
player: .ASCIZ "Player "
thereare: .ASCIZ ", there are "
remaining: .ASCIZ " matchsticks remaining\n"
remove: .ASCIZ ", how many do you want to remove(1-7)\n"
gameover: .ASCIZ "Game Over"
computer: .ASCIZ "Computer Player's turn\n"
win: .ASCIZ ", YOU WIN!\n"
lose: .ASCIZ ", YOU LOSE\n"
draw: .ASCIZ "It's a draw!\n"
computertakes: .ASCIZ "has been taken by computer\n"
youtake: .ASCIZ "has been taken by you\n"
playagain: .ASCIZ "Play again (y/n)?\n"
yesno: .BLOCK 128