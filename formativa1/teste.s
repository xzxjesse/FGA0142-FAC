.data
nl: .asciiz "\n"
falso: .word 1
verdadeiro: .word 2
resultados: .space 100 # Espaço para armazenar até 50 resultados (assumindo que cada resultado ocupa 2 bytes)

.text
main:
    li $v0, 5          # Leitura de um inteiro
    syscall
    move $s0, $v0      # Armazena o número de operações em $s0

    # Inicia o índice para armazenar os resultados
    li $s3, 0

qtd:
    bne $s0, $zero, xor_loop  # Se $s0 != 0, vai para xor

    # Imprime os resultados ao final
    li $t0, 0          # Usado como contador para percorrer os resultados

imprimir_resultados:
    li $v0, 1          # Imprime inteiro
    la $a0, resultados
    add $a0, $a0, $t0  # Acessa o resultado armazenado
    syscall

    li $v0, 4          # Imprime nova linha
    la $a0, nl
    syscall

    addi $t0, $t0, 4   # Incrementa para acessar o próximo resultado
    bne $t0, $s3, imprimir_resultados # Continua enquanto houver resultados

    li $v0, 10         # Finaliza o programa
    syscall

xor_loop:
    li $v0, 12         # Leitura de um caractere (primeiro número)
    syscall
    move $s1, $v0
    addi $s1, $s1, -48 # Converte de ASCII para inteiro

    li $v0, 12
    syscall

    li $v0, 12         # Leitura de outro caractere (segundo número)
    syscall
    move $s2, $v0
    addi $s2, $s2, -48 # Converte de ASCII para inteiro

    li $v0, 12
    syscall

    # Verifica a operação XOR:
    # Se X == Y, o resultado é 1 (falso), senão o resultado é 2 (verdadeiro)
    beq $s1, $s2, resultado_1   # Se X == Y, vai para resultado_1
    li $t0, 2            # Verdadeiro
    j armazena_resultado

resultado_1:
    li $t0, 1            # Falso

armazena_resultado:
    # Armazena o resultado no vetor de resultados
    la $t1, resultados   # Endereço base dos resultados
    add $t1, $t1, $s3    # Offset com o índice
    sw $t0, 0($t1)       # Armazena o resultado (1 ou 2) no vetor
    addi $s3, $s3, 4     # Incrementa o índice para o próximo resultado

    addi $s0, $s0, -1    # Decrementa a quantidade de operações
    bne $s0, qtd        # Se $s0 != 0, vai para qtd para repetir
