# Multiplicação

```assembly
# Multiplicação otimizada
# Entradas:
#   $a0 = multiplicando (M)
#   $a1 = multiplicador (Q)
# Saídas:
#   $v0 = produto (P)

    .data
multiplicando: .word 10     # Exemplo de multiplicando (10)
multiplicador: .word 3      # Exemplo de multiplicador (3)

    .text
    .globl main
main:
    # Carregar os valores de multiplicando e multiplicador
    la $t0, multiplicando
    lw $t0, 0($t0)         # $t0 = multiplicando (M)
    la $t1, multiplicador
    lw $t1, 0($t1)         # $t1 = multiplicador (Q)

    # Inicializar o produto P = 0
    move $v0, $zero        # $v0 = P = 0

    # Inicializar contador de iterações
    li $t2, 32             # Contador de iterações (32 vezes)
    
loop:
    # Verificar o bit menos significativo de Q (Q0)
    andi $t3, $t1, 1       # $t3 = Q0 (bit menos significativo de Q)
    beqz $t3, no_addition  # Se Q0 = 0, não acumula o multiplicando

    # Acumular o multiplicando na parte mais significativa de P
    addu $v0, $v0, $t0     # P = P + M

no_addition:
    # Deslocar P à direita (P >> 1)
    srl $v0, $v0, 1        # P = P >> 1

    # Deslocar Q à direita (Q >> 1)
    srl $t1, $t1, 1        # Q = Q >> 1

    # Decrementar o contador de iterações
    subi $t2, $t2, 1       # Decrementar iteração
    bgtz $t2, loop         # Se ainda não foi a 32ª iteração, volta ao loop

    # Finalizar e sair
    li $v0, 10             # Código para terminar o programa
    syscall
```

### Explicação:

1. **Carregamento de dados**: O multiplicando (M) e o multiplicador (Q) são carregados da memória para os registradores `$t0` e `$t1`, respectivamente.
2. **Inicialização do produto (P)**: O produto é inicialmente zero (`$v0 = 0`).
3. **Loop de multiplicação**:
   - **Verificação do bit menos significativo de Q**: O bit menos significativo de Q (Q0) é verificado usando a operação `andi` e, se for 1, o multiplicando (M) é somado à parte mais significativa de P (`$v0`).
   - **Deslocamento de P e Q**: O produto P é deslocado à direita (`P >> 1`), e o multiplicador Q também é deslocado à direita (`Q >> 1`).
4. **Contagem de iterações**: O loop é repetido 32 vezes (uma para cada bit do multiplicador Q).
5. **Saída**: Após 32 iterações, o programa termina.

### Observações:
- O código assume que os números são inteiros de 32 bits e que o multiplicador é tratado como um número binário.
- O produto final é armazenado no registrador `$v0`.
- O programa termina após 32 iterações, o que é típico para multiplicação binária de números de 32 bits.