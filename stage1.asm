
MOV R5, #askMatchsticks
MOV R7, #downaline

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
HALT

askName: .ASCIZ "Please enter your name\n"
askMatchsticks: .ASCIZ "How many matchsticks (10-100)\n"
downaline: .ASCIZ "\n"
inputName: .BLOCK 128
myName: .ASCIZ "Player 1 is: "
matchsticksNum: .ASCIZ "Matchsticks: "
