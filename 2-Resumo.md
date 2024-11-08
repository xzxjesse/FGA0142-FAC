# Linguagem de Montagem

As instruções, com exceção das que manipulam memória, operam com unidades de memória que ficam no próprio processador, chamadas de **registradores**.

## Arquitetura do MIPS

| ID  | Mnemônico | Descrição                  |
|:---:|:---------:|:---------------------------|
|  0  | $zero     | **A constante zero**           |
|  1  | $at       | Reservado (assembler)      |
| 2-3 | $v0-$v1   | **Retorno de funções**         |
| 4-7 | $a0-$a3   | **Argumentos**                 |
| 8-15| $t0-$t7   | **Temporários**                |
|16-23| $s0-$s1   | **Salvos**                     |
|24-25| $t8-$t9   | **Temporários**                |
|26-27| $k0-$k1   | Reservado para o Kernel    |
| 28  | $gp       | Ponteiro global            |
| 29  | $sp       | Ponteiro de pilha          |
| 30  | $fp       | Ponteiro para registro de ativação |
| 31  | $ra       | Endereço de retorno        |

- $:
    - v: retorno
        - 0-1
    - a: argumentos
        - 0-3
    - t: temporarios
        - 0-9
    - s: salvos
        - 0-1
        
## Estrutura De Um Programa Em Assembly MIPS

```assembly
.data
#declaração de variáveis

.text
#codigo MIPS

main:
#aqui inicia a execução
```

## Pseudo-Instruções

### `move`
```assembly
move $dest, $src
# faz a cópia do dado de $src em $dest
```

- Usando `add`:
    ```assembly
    add $dest, $src, $zero
    # $dest recebe o valor de $src (equivalente a copiar)
    ```

- Usando `or`:
    ```assembly
    or $dest, $src, $zero
    # $dest recebe o valor de $src (outra forma de copiar)
    ```

### `li`
```assembly
li $reg, const
# carrega uma constante no registrador $reg
```

- Usando `addi` (para constantes de até 16 bits):
    ```assembly
    addi $reg, $zero, const
    # $reg recebe o valor de const
    ```

- *Para valores maiores que 16 bits, o carregamento ocorre em duas etapas, usando as instruções `lui` e `ori`.*

### `la`
```assembly
la $reg, label
# carrega o endereço de memória do label em $reg
```

- Usando `lui` e `ori`:
    ```assembly
    lui $reg, high(label)    # carrega a parte alta do endereço
    ori $reg, $reg, low(label)  # carrega a parte baixa do endereço
    ```

## System Calls

|Serviço|Código|Argumentos|Resultado|
|---|:---:|:---:|:---:|
|**imprimir inteiro**|1|$a0=inteiro|n.a.|
|**imprimir string**|4|$a0 = endereço da string|n.a.|
|**ler um inteiro**|5|n.a.|$v0: valor lido|
|**ler uma string**|8|$a0= end. da string ou $a1= qtde de caracter|n.a.|
|**alocar memória**|9|$a0= num de bytes|$v0: endereço|
|**encerrar o programa**|10|n.a.|n.a.|
|**imprimir caracter**|11|$a0= código ASCII|n.a.|
|**ler caracter**|12|n.a.|$v0: caracter lido|

## Instruções imediatas
Operam com registrador e constante.

`addi $s0, $s0, 10`

Obs.:
- Usar o registrador $zero ao invés da constante
- As variações imediatas terminam com i.

## Instruções de acesso à memória

### `lw reg, offset(base)`
**Descrição**: Carrega no registrador `reg` o dado (de 4 bytes) que estiver no endereço calculado por `base + offset`.

### Variações
- **`lb`**: Load Byte (carrega 1 byte)
- **`lh`**: Load Half (carrega 2 bytes)

### `sw reg, offset(base)`
**Descrição**: Salva na memória, no endereço calculado como `base + offset`, o conteúdo do registrador `reg`.

### Variações
- **`sb`**: Store Byte (salva 1 byte)
- **`sh`**: Store Half (salva 2 bytes)

# Exemplos:
1. **Imprimir o inteiro que está em `$s0` na tela**
    ```assembly
    .text
    main:
        li $v0, 1          # syscall 1: imprimir um inteiro
        move $a0, $s0      # move o valor de $s0 para $a0
        syscall            # executa a syscall 1
        li $v0, 10         # syscall 10: encerrar o programa
        syscall            # executa a syscall 10
    ```

2. **Olá Mundo**
    ```assembly
    .data
    ola: .asciiz "ola mundo"  # define a string "ola mundo" no segmento de dados

    .text
    main:
        li $v0, 4          # syscall 4: imprimir string
        la $a0, ola        # carrega o endereço de "ola" em $a0
        syscall            # executa a syscall 4
        li $v0, 10         # syscall 10: encerrar o programa
        syscall            # executa a syscall 10
    ```

3. **Ler 2 números inteiros e imprimir a soma**
    ```assembly
    .text
    main:
        li $v0, 5          # syscall 5: ler um inteiro
        move $s0, $v0      # armazena o primeiro número em $s0
        syscall            # executa a syscall 5

        li $v0, 5          # syscall 5: ler outro inteiro
        syscall            # executa a syscall 5
        add $a0, $s0, $v0  # soma os dois números e armazena o resultado em $a0

        li $v0, 1          # syscall 1: imprimir um inteiro
        syscall            # executa a syscall 1
    ```

4. **g = h + A[8]**
    - **Registradores:**
        - g é armazenado em `$s0`
        - h é armazenado em `$s1`
        - O endereço base do vetor A está em `$s2`

        ```assembly
        lw $t0, 32($s2) 
            # Carrega A[8] em $t0
            # 32: 8 (posição no vetor) * 4 (tamanho de cada elemento)
        add $s0, $s1, $t0
            # Calcula g = h + A[8] e armazena em $s0
        ```

5. **A[12] = g + A[8]**
    1. Carregar A[8]
    2. Somar g com A[8] 
    3. Salvar o resultado em A[12]

        ```assembly
        lw $t0, 32($s2) 
            # Carrega A[8] em $t0
            # 32: 8 (posição no vetor) * 4 (tamanho de cada elemento)
        add $t0, $s0, $t0
            # Soma g com A[8] e armazena o resultado em $t0
        sw $t0, 48($s2)
            # Salva o resultado da soma em A[12]
        ```