# Divisão

```assembly
# Divisão otimizada
# Entradas: 
#   $a0 = dividendo (32 bits)
#   $a1 = divisor (32 bits)
# Saídas:
#   $v0 = quociente (32 bits)
#   $v1 = resto (32 bits)

    .data
dividendo: .word 7      # Exemplo de dividendo (7)
divisor:    .word 3      # Exemplo de divisor (3)

    .text
    .globl main
main:
    # Carregar os valores de dividendo e divisor
    la $t0, dividendo
    lw $t0, 0($t0)         # $t0 = dividendo
    la $t1, divisor
    lw $t1, 0($t1)         # $t1 = divisor

    # Inicializar o resto com o dividendo
    move $v1, $t0          # $v1 = resto = dividendo
    move $v0, $zero        # $v0 = quociente = 0

    # Inicialização do loop
    li $t2, 33             # Contador de iterações (33 vezes)
loop:
    # Deslocar o resto à esquerda (R << 1)
    sll $v1, $v1, 1        # $v1 = resto << 1

    # Subtrair divisor de R[63..32] (simulando 64 bits)
    sub $t3, $v1, $t1      # $t3 = resto - divisor

    # Verificar se o resto >= 0
    bltz $t3, step_b       # Se resto < 0, vai para passo B

    # Passo A: Resto >= 0
    or $v0, $v0, 1         # R[0] = 1 (quociente)
    j next_iteration

step_b:
    # Passo B: Resto < 0
    add $v1, $v1, $t1      # resto = resto + divisor

next_iteration:
    # Decrementar o contador de iterações
    subi $t2, $t2, 1       # Decrementar iteração
    bgtz $t2, loop         # Se ainda não foi a 33ª iteração, volta ao loop

    # Finalizar e sair
    li $v0, 10             # Código para terminar o programa
    syscall
```

### Explicação:

1. **Carregamento de dados**: O dividendo e o divisor são carregados da memória para os registradores `$t0` e `$t1`.
2. **Inicialização**: O resto é inicializado com o dividendo e o quociente é inicialmente zero.
3. **Deslocamento à esquerda (R << 1)**: O resto é deslocado à esquerda uma vez a cada iteração.
4. **Subtração do divisor**: A subtração do divisor é realizada e verificada para determinar se o resto é negativo ou não.
5. **Passo A ou Passo B**: Dependendo do sinal do resto, ajustamos o quociente e o resto conforme as regras fornecidas.
6. **Iterações**: O loop continua até completar 33 iterações.
7. **Saída**: O programa termina após as iterações.

### Observações:
- O MIPS não possui um comando de 64 bits diretamente, então usamos dois registros de 32 bits para simular 64 bits.
- O código assume que o número de iterações será sempre 33, conforme o exemplo dado.
- O quociente é armazenado em `$v0` e o resto em `$v1`.