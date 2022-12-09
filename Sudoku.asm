Tittle Sudoku em Assembly x86
.model small
.stack 100h

    ;Macro para Pular linha
pula_linha  MACRO 
    mov ah,02
    mov dl,10
    int 21H
endm

    ;Macro para Limpar a Tela do Terminal
limpa_tela MACRO
    MOV DL, 10
    MOV AH, 02
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
endm

    ;Macro para realizar a impressão da Linha do Sudoku
LinhaIM MACRO
    MOV DL, 20H
    MOV AH, 02
    INT 21H

    MOV DL, 20H
    MOV AH, 02
    INT 21H

    INC Linha
    MOV DL, Linha
    MOV AH, 02
    INT 21H

    MOV DL, 29H
    MOV AH, 02
    INT 21H

    MOV DL, 20H
    MOV AH, 02
    INT 21H 

    MOV DL, 20H
    MOV AH, 02
    INT 21H
endm

.DATA

  ;Estéticas e Matrizes:
    Cima DB '                                ______________           $'
    Começo DB '=============================== < SUDOKU > =============================== $'
    BV DB ' -> Bem-vindo ao Sudoku em Assemlby, boa sorte e diversao! <- $'
    Baixo DB '_______________________________________________________________________________ $'
    EnterStart DB ' -> Aperte ENTER para INICIAR! $'
    EnterSPACE DB ' -> Aperte ESPAÇO para CONTINUAR o Sudoku ou aperte outra tecla para finalizar o jogo: $'
    EnterOut DB ' -> FIM DE JOGO! Obrigado por jogar :D <- $'
    Coluna DW '','','','C1','','C2','','C3','','C4','','C5','','C6','','C7','','C8','','C9','$'
    Linha DB ?
    MudaLinha DB ' -> Qual linha gostaria de alterar: $'
    MudaColuna DB ' -> Qual coluna gostaria de alterar: $'
    EscolheNum DB ' -> Escolha um numero entre 1-9: $'
    SENter DB ' -> OPA! ISSO NAO E UM ENTER >:) $ '
    OP DW ?
        DW '$'
    pBX DW ?
        DW '$'
    pSI DW ?
        DW '$'

    m1  DW 35h,33h,30h,30h,37h,30h,30h,30h,30h ;1  
        DW 36h,30h,30h,31h,39h,35h,30h,30h,30h ;2  
        DW 30h,39h,38h,30h,30h,30h,30h,36h,30h ;3  
        DW 38h,30h,30h,30h,36h,30h,30h,30h,33h ;4  
        DW 34h,30h,30h,38h,30h,33h,30h,30h,31h ;5  
        DW 37h,30h,30h,30h,32h,30h,30h,30h,36h ;6
        DW 30h,36h,30h,30h,30h,30h,32h,38h,30h ;7
        DW 30h,30h,30h,34h,31h,39h,30h,30h,35h ;8
        DW 30h,30h,30h,30h,38h,30h,30h,37h,39h ;9  

.CODE

main proc

        ;Começa o Programa
    MOV AX,@DATA
    MOV DS, AX

        ;Limpa tela
    limpa_tela
    limpa_tela

        ;Imprime uma mensagem
    LEA DX, Cima 
    MOV AH, 09
    INT 21H
 
        ;Print Pula
    pula_linha

    LEA DX, Começo
    MOV AH, 09
    INT 21H
 
    pula_linha

    LEA DX, BV
    MOV AH, 09
    INT 21H
 
    pula_linha

    LEA DX, Baixo
    MOV AH, 09
    INT 21H

EnterDNV:

    LEA DX, EnterStart
    MOV AH, 09
    INT 21H

    MOV AH, 01
    INT 21H

    CMP AL, 13D
    JNE SemEnter
Continua:

    limpa_tela

    LEA DX, Coluna
    MOV AH, 09
    INT 21H
    
    pula_linha
    
    CALL Matriz
    CALL Resultado
    CALL Matriz

    LEA DX, EnterSPACE
    MOV AH, 09
    INT 21H

    MOV AH, 01
    INT 21H

    CMP AL, 8
    JE Continua

    pula_linha

    LEA DX, EnterOut
    MOV AH, 09
    INT 21H

    MOV AH, 4CH
    INT 21H

SemEnter:
    limpa_tela
    LEA DX, SemEnter
    MOV AH, 09
    INT 21H
    limpa_tela
    JMP EnterDNV
    
main endp

Resultado proc
    pula_linha
    XOR SI, SI

    MOV DL, 175D
    MOV AH, 02
    INT 21H

    LEA DX, MudaLinha
    MOV AH, 09
    INT 21H

    MOV AH, 01
    INT 21H

    SUB AL, 40H
    SHL AL, 1
    SUB AL, 2
    MOV BL, AL

    pula_linha

    MOV DL, 175D
    MOV AH, 02
    INT 21H

    LEA DX, MudaColuna
    MOV AH, 09
    INT 21H

    MOV AH, 01
    INT 21H

    XOR CX, CX
    MOV CL, AL

    MOV AX, 12h
    SUB CL, 31H
    MUL CL

    MOV SI, AX

    pula_linha

    MOV DL, 175D
    MOV AH, 02
    INT 21H

    LEA DX, EscolheNum
    MOV AH, 09
    INT 21H

    XOR AX, AX

    MOV AH, 01
    INT 21H

    MOV pBX, BX
    MOV pSI, SI

    MOV m1[BX][SI], AX

    limpa_tela
    pula_linha

    LEA DX, Coluna
    MOV AH, 09
    INT 21H

    pula_linha
    RET
Resultado endp

Matriz proc
    MOV BX, 0
    MOV SI, 0
    MOV Linha, 30H

    JMP BX_ZERO

IMP:
    XOR CX, DX
    ADD BX, 02

BX_ZERO:
    CMP BX, 0
    JE LinhaIMP01
    JMP Pula

LinhaIMP01:
    LinhaIM

Pula:

PulaV2:
    CMP SI, 0
    JG DX_M

    JMP PulaV3

BX_UM:
    JMP BX_ZERO

DX_M:
    MOV DL, 7CH
    MOV AH, 02
    INT 21H

    MOV DX, m1[BX][SI]
    CMP DL, 0
    JNE PulaV4

    XCHG DH, DL

    JMP PulaV4

PulaV3:
    MOV DL, 7CH
    MOV AH, 02
    INT 21H
    
    MOV DX, m1[BX][SI]

ForaDeAlcance:
    CMP BX, 16
    JNE IMP

PulaV4:
    CMP DL, 30H
    JE PulaV5

    JMP PulaV6

PulaV5:
    CMP BX, pBX
    JE test_SI

    JMP PulaV7

test_SI:
    CMP SI, pSI
    JE NV

    JMP PulaV7

NV:
    CMP OP, 0
    JG NV1

PulaV7:
    MOV DL, 20H
    JMP PulaV6

NV1:
    MOV DX, OP
    MOV OP, 0

PulaV6:
    MOV AH, 02
    INT 21H

    MOV DL, 7CH
    MOV AH, 02
    INT 21H

    XOR DX, DX

    MOV DX, 20h
    MOV AH, 02
    INT 21H

    JMP ForaDeAlcance

    MOV DL, 10
    MOV AH, 02
    INT 21H

    XOR BX, BX

    ADD SI, 12h
    CMP SI, 162
    JNE BX_UM
    RET
Matriz endp
END main
