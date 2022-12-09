TITLE VINÍCIUS BORGES DE GODOY (RA:22006132)

.model small
stack 100h

    ;Ajuda na Formatação da Tabela do Sudoku
Distanciamento2 MACRO
    MOV DL, ' '
    MOV AH, 02
    INT 21H
    INT 21H
    INT 21H
endm

    ;Limpa a Tela para um melhor conforto
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

    ;Pula duas linhas na tela
PulaL2 MACRO
    MOV DL, 10
    MOV AH, 02
    INT 21H
    INT 21H
endm

    ;Ajuda na Formatação da Tabela do Sudoku
Distanciamento MACRO
    MOV DL, ' '
    MOV AH, 02
    INT 21H
endm

    ;Quando Precionar o 'Esc' o programa se encerra de imediato
EscFora MACRO

    CMP AL, 27
    JE Finaliza
endm

    ;Pula somente uma linha na tela
PulaL MACRO
    MOV DL, 10
    MOV AH, 02
    INT 21H
endm

    ;Enfeites e Matriz
.data
    Cima DB '                                __________           $'
    Começo DB '=============================== < SUDOKU > ===================================== $'
    BV DB ' -> Bem-vindo ao Sudoku em Assemlby, boa sorte e diversao! <- $'
    Baixo DB '_______________________________________________________________________________ $'
    EnterStart DB ' -> Aperte ENTER para INICIAR! $'
    EnterSPACE DB ' -> Aperte ESC para SAIR DO JOGO: $'
    EscOut DB ' -> FIM DE JOGO! Obrigado por jogar :D <- $'
    Coluna DB '       A   B   C   D   E   F   G   H   I                                       $'
    Linha DB ?
    MudaLinha DB ' -> Qual linha gostaria de alterar: $'
    MudaColuna DB ' -> Qual coluna gostaria de alterar: $'
    EscolheNum DB ' -> Escolha um numero entre 1-9: $'
    pBX DW ?
    pSI DW ?

    m1  DB 33h,34h,30h,37h,30h,36h,30h,30h,31h ;1  
        DB 38h,37h,30h,30h,34h,35h,39h,32h,36h ;2  
        DB 32h,30h,30h,38h,39h,31h,30h,30h,30h ;3  
        DB 34h,30h,30h,39h,30h,33h,35h,36h,33h ;4  
        DB 36h,30h,30h,30h,30h,30h,30h,39h,37h ;5  
        DB 30h,31h,35h,36h,30h,37h,33h,30h,30h ;6
        DB 30h,33h,32h,30h,37h,30h,32h,38h,30h ;7
        DB 35h,30h,30h,31h,30h,30h,37h,30h,30h ;8
        DB 37h,30h,30h,35h,30h,38h,30h,31h,39h ;9   

.code

    ;Main do Programa onde todos os procedimentos são colocados
main proc

    MOV AX, @DATA   ;Inicia o Programa
    MOV DS, AX

    CALL Titulo     ;Chama a Cabeçalho

Continua:       ;Looping para colocar todos os numeros que seram preciosos para completar o quadrp

    CALL Sudoku     ;Chama a proc do Sudoku

    CALL Resposta   ;Chama a proc que permite o usuário responder a tabela do Sudoku

    JMP Continua

Final:

    CALL Encerramento   ;Chama a proc para Finalizar o Programa

main endp

    ;Procedimento onde o Cabeçalho é feito
Titulo proc

    limpa_tela
    PulaL

    LEA DX, Cima            ;Estética
    MOV AH, 09
    INT 21H

    PulaL

    LEA DX, Começo          ;Estética
    MOV AH, 09
    INT 21H

    PulaL

    LEA DX, BV              ;Estética
    MOV AH, 09
    INT 21H

    PulaL

    LEA DX, Baixo           ;Estética
    MOV AH, 09
    INT 21H

    PulaL2

    LEA DX, EnterStart      ;Confere se foi apertado o Enter para continuar
    MOV AH, 09
    INT 21H

    MOV AH, 01              ;Recebe o digito esperando um 'Enter'
    INT 21H

    CMP AL, 13              ;Compara na Tabela ASCII para ver se é realmente o Enter
    JE Foi

Foi:         ;Caso seja o enter
    RET     ; Retorna

Titulo endp

    ;Procedimento que cria o jogo Sudoku e printa ele na tela
Sudoku proc
    
        ;Usa o sistema de incrementação para geras os números de Linhas
    limpa_tela
    PulaL
    MOV BX, 0
    MOV SI, 0
    MOV Linha, 30H
    LEA DX, Coluna
    MOV AH, 09
    INT 21H
    PulaL
    MOV CX, 9

    ;Cria as Colunas ao Lado Númeradas de 1 a 9 para ajudar o jogador a saber o numero da linha
SequênciaL:

    PulaL
    Distanciamento

    INC Linha
    MOV DL, Linha
    MOV AH, 02
    INT 21H

    MOV DL, '>'     ;Printa uma 'seta' na frente dos numeros das linhas para diferenciar dos numeros do Quadro Sudoku
    MOV AH, 02
    INT 21H

    Distanciamento2
    Distanciamento
    MOV DH, 9
    
    ;Preenche os lugares que possuem numeros da Matriz apresentada acima
SequênciaC:

    CMP m1[BX][SI], 30H
    JNE Preenchido
    MOV DL, ' '
    MOV AH, 02
    INT 21H

    JMP Nada

Preenchido:

    MOV DL, m1[BX][SI]      ;Imprime o numero que já existe no quadro Suduku
    MOV AH, 02
    INT 21H

Nada:

    Distanciamento2
    INC SI
    DEC DH

    JNZ SequênciaC
    LOOP SequênciaL     ;Repete até todas as linhas terem sido completadas pelos numeros da Matriz apresentada
    RET
Sudoku endp

    ;Procedimento que finaliza o Programa e agradece por jogar quando a tecla Esc é apertada
Encerramento proc

    limpa_tela
    PulaL
    
    LEA DX, EscOut
    MOV AH, 09
    INT 21H

    MOV AH, 4CH
    INT 21H

Encerramento endp

    ;Procedimento que permite o jogogador selecionar linha e coluna para colocar o resultado no Sudoku
Resposta proc

    PulaL2
    PulaL

    LEA DX, MudaLinha
    MOV AH, 09
    INT 21H

    MOV AH, 01      ;Coloca qual linha deseja alterar
    INT 21H

    EscFora         ;Verifica se o Jogador deseja encerrar o jogo

    SUB AL, 31H
    XOR AH, AH
    MOV CH, 9  
    MUL CH
    MOV pBX, AX
    PulaL

    LEA DX, MudaColuna
    MOV AH, 09
    INT 21H

    MOV AH, 01      ;Coloca qual coluna deseja alterar
    INT 21H

    EscFora

    SUB AL, 41H
    XOR AH, AH
    MOV pSI, AX
    PulaL

    LEA DX, EscolheNum
    MOV AH, 09
    INT 21H

    MOV AH, 01      ;Coloca o Numero que deseja colocar na posição que selecionou
    INT 21H

    EscFora

    MOV BX, pBX         ;Pega as posições da Coluna e Linha para colocar o Numero digitado
    MOV SI, pSI

    MOV m1[BX][SI], AL          ;Faz a nova matriz do Suduku com o numero novo inserido pelo jogador
    JMP MandaDVolta

Finaliza:

    JMP Final       ;Salto para Finalizar o Jogo

MandaDVolta:

    RET         ;Retorna

Resposta endp
END main
