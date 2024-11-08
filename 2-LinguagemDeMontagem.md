# Linguagem de Montagem

Nesta disciplina, usaremos o conjunto de instruções **MIPS**.

**Simulador:** SPIM

**Sugestão:**

1. Baixar o SPIM para linha de comando.
2. Usar o editor de sua preferência para programar.
3. Rodar via linha de comando:

    ```bash
    spim -f codigo.spim
    ```

# Operações Aritméticas
Realiza uma operação entre dois operandos.

## Soma

```assembly
add a, b, c # calcula a = b + c
```

Todas as instruções aritméticas possuem este formato.

**Exemplo:**
```assembly
f = (g+h) + (i+j)
add t0, g, h
add t1, i, j
add f, t0, t1
```

- **Observação:** Não existe prioridade de operadores.
- As instruções aritméticas (e as demais, com exceção das que manipulam memória) operam com unidades de memória que ficam no próprio processador, chamadas de registradores.

Um processador MIPS de 32 bits possui 32 registradores de 32 bits cada um.

- **OBS:** Um dado de 32 bits (4 bytes) é chamado de **palavra**.
- **OBS:** Os registradores são numerados de 0 a 31.

# Arquitetura do MIPS
"Conversa com o processador"

| ID  | Mnemônico | Descrição                  |
|:---:|:---------:|:---------------------------|
|  0  | $zero     | A constante zero           |
|  1  | $at       | Reservado (assembler)      |
| 2-3 | $v0-$v1   | Retorno de funções         |
| 4-7 | $a0-$a3   | Argumentos                 |
| 8-15| $t0-$t7   | Temporários                |
|16-23| $s0-$s1   | Salvos                     |
|24-25| $t8-$t9   | Temporários                |
|26-27| $k0-$k1   | Reservado para o Kernel    |
| 28  | $gp       | Ponteiro global            |
| 29  | $sp       | Ponteiro de pilha          |
| 30  | $fp       | Ponteiro para registro de ativação |
| 31  | $ra       | Endereço de retorno        |

- Registradores 0 e de 2 a 27 são os mais usados em programas.

**Exemplo:**
```assembly
add $t0, $s1, $s2 # $t0 = g + h
add $t1, $s3, $s4 # $t1 = i + j
add $s0, $t0, $t1 # $s0 = (g+h) + (i+j)
```

# Estrutura De Um Programa Em Assembly MIPS

```assembly
.data
#declaração de variáveis

.text
#codigo MIPS

main:
#aqui inicia a execução
```

- **Rótulo:** é um apelido para uma linha de código

## Tipos de dados

|nome|formato|tamanho|
|:---:|:---:|:---:|
|word|w1, w2,...,wn|32 bits|
|half|h1, h2,..., hn|16bits|
|byte|b1, b2,..., bn|8 bits|
|ascciz str|sting terminando em \n||

## Pseudo-Instruções
Pseudo-instruções são instruções que não fazem parte diretamente da ISA (Instruction Set Architecture) e são traduzidas em instruções nativas pelo assembler.

### `move`
A pseudo-instrução `move` copia o valor de um registrador para outro.

```assembly
move $dest, $src
# faz a cópia do dado de $src em $dest
```

**Implementação com instruções reais:**

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
A pseudo-instrução `li` carrega uma constante em um registrador.

```assembly
li $reg, const
# carrega uma constante no registrador $reg
```

**Implementação com instruções reais:**

Se a constante couber em 16 bits, ela pode ser carregada diretamente usando `addi`:

- Usando `addi` (para constantes de até 16 bits):
    ```assembly
    addi $reg, $zero, const
    # $reg recebe o valor de const
    ```

Para valores maiores que 16 bits, o carregamento ocorre em duas etapas, usando as instruções `lui` e `ori`.

### `la`
A pseudo-instrução `la` carrega o endereço de memória de um rótulo (label) em um registrador.

```assembly
la $reg, label
# carrega o endereço de memória do label em $reg
```

**Implementação com instruções reais:**

Para endereços de 32 bits, o carregamento ocorre em duas etapas:

- Usando `lui` e `ori`:
    ```assembly
    lui $reg, high(label)    # carrega a parte alta do endereço
    ori $reg, $reg, low(label)  # carrega a parte baixa do endereço
    ```

## System Calls

São chamadas que o processador faz ao sistema operacaional para executar tarefas que dependem dele.

- Exemplo: Aloca memória, lidar com entradas e saídas...

### Para executar uma system calls:

1. Carrega-se o código da syscall no registrador $v0.
2. Carrega-se os argumentos nos registradores $a0-$a3.
    - Depende da syscall
3. Executar a syscall.

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

#### Exemplos:

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
        syscall            # executa a syscall 5
        move $s0, $v0      # armazena o primeiro número em $s0

        li $v0, 5          # syscall 5: ler outro inteiro
        syscall            # executa a syscall 5
        add $a0, $s0, $v0  # soma os dois números e armazena o resultado em $a0

        li $v0, 1          # syscall 1: imprimir um inteiro
        syscall            # executa a syscall 1
    ```

# Instruções imediatas
Algumas instruções aritméticas possuem uma variação imediata que, ao invés de operar com dois registradores, operam com registrador e constante.

- Exemplo: `addi $s0, $s0, 10`

Obs.:
- Usar o registrador $zero ao invés da constante
- As variações imediatas terminam com i.

# Instruções de acesso a memória

A memória principal é usada para armazenar dados que não cabem nos registradores como, por exemplo, vetores. Por outro lado, as instruções aritméticas operam apenas com registradores. Por tanto, o assembly deve ser capaz de ler e escrever na memória.

A memória é endereçada por bytes e cada dado deve começar em um endereço múltiplo de 4 bytes (já que os registradores tem 4 bytes); isso é chamado de **restrição de alinhamento**.

| <center>0</center> | <center>1</center> | <center>2</center> | <center>3</center> | <center>4</center> | <center>5</center> | <center>6</center> | <center>7</center> | <center>8</center> | <center>9</center> | <center>10</center> | <center>11</center> | <center>12</center> | <center>13</center> | <center>14</center> | <center>15</center> |
|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
|.|.|.|.|.|.|.|.|---|---|---|---|.|.|.|.|

- Cada espaço tem 1 byte
- Variável inteira começa no 8 e termina no 11

## As principais instruções de acesso à memória

### `lw reg, offset(base)`
- **lw**: Load Word
- **reg**: Registrador onde o dado será carregado
- **offset**: Constante que indica um deslocamento
- **base**: Registrador que contém a base do endereço

**Descrição**: Carrega no registrador `reg` o dado (de 4 bytes) que estiver no endereço calculado por `base + offset`.

### Variações
- **`lb`**: Load Byte (carrega 1 byte)
- **`lh`**: Load Half (carrega 2 bytes)

### `sw reg, offset(base)`
- **sw**: Store Word
- **reg**: Registrador que contém o dado a ser salvo
- **offset**: Constante que indica um deslocamento
- **base**: Registrador que contém a base do endereço

**Descrição**: Salva na memória, no endereço calculado como `base + offset`, o conteúdo do registrador `reg`.

### Variações
- **`sb`**: Store Byte (salva 1 byte)
- **`sh`**: Store Half (salva 2 bytes)

#### Exemplos:

- **g = h + A[8]**
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

- **A[12] = g + A[8]**
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

### Por que os vetores começam em 0:

- **Endereço inicial:** 0
- **Tamanho do dado:** 4 bytes
- **Endereço da posição *i*:** endereço inicial + i x 4 

Para a máquina, a operação de multiplicar por 4 é tão simples quanto para um humano calcular uma multiplicação por 10. 

**Exemplos:**

- **Em decimal:**
  - 2 x 10 = 20

- **Em binário:**
  - 10 x 100 = 1000

## Inteiros binários

Numa arquitetura de 32 bits, os inteiros são representados por binários de 32 bits (devido ao tamanho dos registradorres).

Há duas formas de representar:
1. **Inteiros sem sinal**

    Representa números maiores ou iguais a zero.
    - 2^32 variações distintas:
        - mínimo: 0
        - máximo: 2^32 - 1 = 4.294.967.205

    No assembly, instruções aritméticas que lidam com inteiros sem sinal terminam com a letra u:

    ```assembly
    addu $s0, $s1, $s2
    ```
2. **Inteiros com sinal**

    Inclui números negativos:
    - **Complemento de 2:**
        - 5 (decimal)
        - 0101 (binário)
        - 1010 (invertido) + 1
        - 1011 = -5
    
    Para representar inteiros com sinal usamos 2^32 variações distintas, consideramos metade negativa e metade, positiva.
    - (2^32)/2 = 2^31
        - mínimo: -2^31 = -2.147.483.648 
        - máximo: -2^31 = -2.147.483.647

    O zero é considerado positivo para a computação pois em binário é só 0s e o sinal de positivo é 0.

### Extensão de sinal
Replica o bit de sinal a esquerda, na quantidade de vezes que for necessário.
- Em 4 bits:
    - -5: 1011
- Em 8 bits:
    - -5: 11011

## Representação de instruções em linguagem de máquina

Toda instrução é traduzida para linguagem de máquina, ou seja, são codificadas em binário. Os binários possuem 32 bits e seguem alguns formatos padrão.

1. Formato Tipo-R

|op|rs|rt|rd|shamt|funct|
|:---:|:---:|:---:|:---:|:---:|:---:|
|6 bits|5 bits|5 bits|5 bits|5bits|6bits|
|Código da operação|É o primero registrador operando|É o segundo registrador operando|É o registrador de destino|É o tamanho do deslocamento|É o código da função|

- Exemplo:
    ```assembly
    add $t0, $s0, $s1
    ```

    |op|rs|rt|rd|shamt|funct|
    |:---:|:---:|:---:|:---:|:---:|:---:|
    |aritmetica|$s0|$s1|$t0|0|add|
    |000000|10001|100010|01000|00000|100000|

2. Formato Tipo-I

    |op|rs|rt|const. endereço|
    |:---:|:---:|:---:|:---:|
    |6 bits|5 bits|5 bits|16bits|
    |Código da operação|É o primero registrador operando|É o segundo registrador operando|**Constante** de instruções imediátas ou **off set** em instruções de acesso a memória|

- Exemplo:
    ```assembly
    lw $s0, 48($s2)
    ```

    |op|rs|rt|const. endereço|
    |:---:|:---:|:---:|:---:|
    |lw|$s0|$s2|48|

3. Formato Tipo-J

## Operações lógicas
As principais são:
- sll: shift left logical (deslocamento a esquerda)
- srl: shift right logical (deslocamento a direita)
- and: e logico (bit a bit)
- or: ou logico (bit a bit)
- nor: negação do ou
- xor: pi exclusivo (bit a bit)

1. Deslocamentos:
- única exceção do tipo-R