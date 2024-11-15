MOV R0, #inputName
;;Promt name and number of matchsticks
prompt:
      BL promptname
      BL promptnum
;;Game start
game: 
      BL displayremain
      BL drawmatchsticks
      BL askremovedsticks
      BL makeAllPixelsWhite
      BL drawmatchsticks
      BL delay
      BL computersturn
      BL makeAllPixelsWhite
      B game
;;When player win
finishedwin:
      BL makeAllPixelsWhite 
      STR R0, .WriteString
      MOV R12, #win
      STR R12, .WriteString
      BL convertuptolow
;;When player lose
finishedlose:
      BL makeAllPixelsWhite
      STR R0, .WriteString
      MOV R12, #lose
      STR R12, .WriteString
      BL convertuptolow
;;When player draw
finishedtie:
      BL makeAllPixelsWhite
      MOV R12, #draw
      STR R12, .WriteString
      BL convertuptolow
end:
      HALT
;;Player's turn
askremovedsticks:
    push {R4, R5, R6, R7, R8, R9}
      MOV R4, R0
      MOV R5, R1

      MOV R6, #player
      STR R6, .WriteString
      STR R4, .WriteString
      MOV R7, #remove
      STR R7, .WriteString
      LDR R8, .InputNum
      CMP R8, #1
      BLT askremovedsticks
      CMP R8, #7
      BGT askremovedsticks
      CMP R8, R5
      BGT game
      CMP R5, #1
      BNE tiecondition1
      STR R8, .WriteUnsignedNum
      MOV R9, #youtake
      STR R9, .WriteString
      SUB R5, R5, R8
      CMP R5, #0
      MOV R1, R5
      MOV R2, R8
    pop {R4, R5, R6, R7, R8, R9}
      BEQ finishedlose
tiecondition1: ;;When the user's input is the remaining matchsticks (not 1)
      STR R8, .WriteUnsignedNum
      MOV R9, #youtake
      STR R9, .WriteString
      SUB R5, R5, R8
      CMP R5, #0
      MOV R1, R5
      MOV R2, R8
      BEQ finishedtie
    pop {R4, R5, R6, R7, R8, R9}
      RET
;;Computer's turn
computersturn:
      push {R4, R5, R6, R7}
      MOV R4, R1
      MOV R5, #computer
      STR R5, .WriteString
computerroll:
      LDR R6, .Random
      AND R6, R6, #7
      CMP R6, #0
      BEQ computerroll
      CMP R6, R4
      BGT computerroll
      CMP R4, #1
      BNE tiecondition2
      SUB R4, R4, R6
      STR R6, .WriteUnsignedNum
      MOV R7, #computertakes
      STR R7, .WriteString
      MOV R1, R4
      MOV R3, R6
      pop {R4, R5, R6, R7}
      CMP R1, #0
      BEQ finishedwin
      B end2
tiecondition2: ;;When the computer's take is the remaining matchsticks (not 1)
      SUB R4, R4, R6
      STR R6, .WriteUnsignedNum
      MOV R7, #computertakes
      STR R7, .WriteString
      MOV R1, R4
      MOV R3, R6
      pop {R4, R5, R6, R7}
      CMP R1, #0
      BEQ finishedtie
      B end2
end2:
      RET
;;Ask to replay
convertuptolow:
      push {R4, R5, R6}

      MOV R6, #0
      MOV R4, #playagain
      STR R4, .WriteString
      MOV R5, #yesno
      STR R5, .ReadString
      LDRB R6, [R5]
      CMP R6, #89 ;; ASCII value of "Y"
      BEQ prompt
      CMP R6, #78 ;; ASCII value of "N"
      BEQ end
      CMP R6, #121 ;; ASCII value of "y"
      BEQ prompt
      CMP R6, #110 ;; ASCII value of "n"
      BEQ end
      B convertuptolow
      pop {R4, R5, R6}
      RET
;;Draw matchsticks
drawmatchsticks:
      push {R4, R5, R6, R7, R8, R9, R10, R11, R12}
      MOV R4, R1
      MOV R5, #.PixelScreen 
      MOV R6, #.red
      MOV R7, #0
      MOV R8, #0
      MOV R9, #0
      MOV R10, #0
      MOV R11, #0
      
multiply: ;;multiply the remaning matchsticks by 4
      ADD R7, R7, R4
      ADD R8, R8, #1
      CMP R8, #4
      BNE multiply
draw10: 
      MOV R12, #0
      CMP R7, #0
      BEQ back
      SUB R7, R7, #4
      ADD R9, R9, #1
      CMP R9, #11
      BEQ downaline ;; move down a new line after draw 10 matchsticks
draw1:
      ADD R10, R5, R11 
      STR R6, [R10]
      ADD R11, R11, #4
      ADD R12, R12, #1
      CMP R12, #5
      BNE draw1
      ADD R11, R11, #4 ;space between each matchstick
      B draw10
downaline: 
      ADD R11, R11, #16
      ADD R11, R11, #256
      MOV R9, #1
      B draw1
      pop {R4, R5, R6, R7, R8, R9, R10, R1, R12}
back:
      RET
;;Make all pixels white
makeAllPixelsWhite: 
      push {R4, R5, R6, R7}
      MOV R4, #.PixelScreen 
      MOV R5, #.white 
      MOV R6, #0
makeWhiteLoop:
      ADD R7, R4, R6 
      STR R5, [R7]
      ADD R6, R6, #4
      CMP R6, #5120 
      BLT makeWhiteLoop
      pop {R4, R5, R6, R7}
      RET
;;Delay 2 seconds before the computer's turn
delay:
      push {R4, R5, R6, R7}
      MOV R7, #2       
      LDR R4, .Time     
timer:
      LDR R5, .Time    
      SUB R6, R5, R4    
      CMP R6, R7        
      BLT timer
      pop {R4,R5,R6,R7}
      RET
;;Prompt player's name
promptname:
    push {R4, R5}

     
      MOV R4, R0
     
      MOV R5, #askName
      
      STR R5, .WriteString
      STR R4, .ReadString
      MOV R0, R4
    pop {R4, R5}
      RET
;;Prompt the number of matchsticks  
promptnum:
    push {R4, R5, R6, R7, R8, R9, R10}
        MOV R7, R0
      MOV R4, #askMatchsticks
      STR R4, .WriteString
      LDR R5, .InputNum
      CMP R5, #10
      BLT promptnum
      CMP R5, #100
      BGT promptnum
      MOV R6, #myName
      STR R6, .WriteString
      STR R7, .WriteString
      MOV R10, #newline
      STR R10, .WriteString
      MOV R8, #matchsticksNum
      STR R8, .WriteString
      STR R5, .WriteUnsignedNum
      MOV R1, R5
    pop {R4, R5, R6, R7, R8, R9}
      RET
;;Display the remaning matchsticks
displayremain: 
    push {R4, R5, R6, R7, R8, R9}
      MOV R4, R0
      MOV R5, R1
      MOV R6, #newline
      STR R6, .WriteString
      MOV R7, #player
      STR R7, .WriteString
      STR R4, .WriteString
      MOV R8, #thereare
      STR R8, .WriteString
      STR R5, .WriteUnsignedNum
      MOV R9, #remaining
      STR R9, .WriteString
    pop {R4, R5, R6, R7, R8, R9}
      RET
    
;;;;;
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
win:  .ASCIZ ", YOU WIN!\n"
lose: .ASCIZ ", YOU LOSE\n"
draw: .ASCIZ "It's a draw!\n"
computertakes: .ASCIZ "has been taken by computer\n"
youtake: .ASCIZ "has been taken by you\n"
playagain: .ASCIZ "Play again (y/n)?\n"
yesno: .BLOCK 128
