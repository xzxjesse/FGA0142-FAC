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
        - máximo: 2^31 = 2.147.483.647

    O zero é considerado positivo para a computação pois em binário é só 0s e o sinal de positivo é 0.

### Extensão de sinal
Replica o bit de sinal a esquerda, na quantidade de vezes que for necessário.
- Em 4 bits:
    - -5: 1011
- Em 8 bits:
    - -5: 11111011

## Representação de instruções em linguagem de máquina

Toda instrução é traduzida para linguagem de máquina, ou seja, são codificadas em binário. Os binários possuem 32 bits e seguem alguns formatos padrão.

1. **Formato Tipo-R**

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

2. **Formato Tipo-I**

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

3. **Formato Tipo-J**

    |op|endereço|
    |:---:|:---:|
    |6 bits|26 bits|

## Operações lógicas
As principais são:
- sll: shift left logical (deslocamento a esquerda)
- srl: shift right logical (deslocamento a direita)
- and: e logico (bit a bit)
- or: ou logico (bit a bit)
- nor: negação do ou
- xor: pi exclusivo (bit a bit)

1. **Deslocamentos:**

    Usam o campo shamb do formato Tipo-R (única exceção do tipo-R).
    
    - À esquerda desloca o número a esquerda
        - Preesnche com zero à direita;
        - Descarta bits mais significativos;
        - Deslocar i vezes é multiplicar por 2^i.
    
        - Exemplo:
        ```assembly
        sll $t0, $s0, 4
        # $s0 = 0000 1001
        # $t0 = 1001 0000
        ```

    - À direita desloca o número a direita
        - Preesnche com zero à esquerda;
        - Descarta bits menos significativos;
        - Deslocar i vezes é dividir por 2^i:
            - Divisão inteira, bits descartados é o resto.
    
        - Exemplo:
        ```assembly
        srl $t1, $s0, 2
        # $s0 = 0010 1001
        # $t0 = 0000 1010
        ```

2. **E, ou e negação:**

    ```assembly
    and $t0, $s0, $s1
    or  $t0, $s0, $s1
    ```

    As operações são feitas bit a bit. São particurlamente úteis para aplicar máscaras ao dado. Algumas mais conhecidas são:
    
    - **Extrair um bit de um registrador:**
        
        Suponha que desejamos extrair o quinto bit menos significativo de $s0:

        $s0 = 0000 ... 0001 0010
        $t0 = 0000 ... 0001 0000

        ```assembly
        # and com 1:
        addi $t0, $zero, 1
        sll  $t0, $t0, 4      # $t0 é a máscara
        and  $t0, $t0, $s0    # $t0 é o resultado, $t0 e $s0 são operandos
        ```

    - **Modificar o valor de um bit:**

    1. Definir o sétimoo bit de $s0 como 1:

        $s0 = 0000 ... 1000 1011
        $t0 = 0000 ... 0100 0000

        ```assembly
        addi $t0, $zero, 1
        sll  $t0, $t0, 6      
        or   $s0, $t0, $s0   
        ```

    2. Definir o sexto bit como 0:

        $s0 = 0000 ... 0010 0101
        $t0 = 1111 ... 1101 1111
        e   = 0000 ... 0000 0101

    3. Saber se dois números possuem o mesmo sinal:

        $s0 = 0010 0011 ... 1010 0110
        $s1 = 1011 0110 ... 1111 0100

        ```assembly
        xor $t0, $s0, $s1
        # se $t0 < 0, sinais opostos, senão, mesmo sinal.
        ```

        ```assembly
        nor $t0, $s0, $zero
        ```

    4. Carregar a máscara:

        $t0 = 1111 1111 ... 1101 1111

        ```assembly
        addi $t0, $zero, 1
        sll $t0, $t0, 5
        nor $t0, $t0, $zero
        ```

## Instruções de desvio

Fazem o desvio da execução para uma instrução identificada por um rótulo. Há dois tipos:

1. **Desvio condicional:**
    #### `beq rs, rt, label`
    - branch if equal: desvia para a instrução rotulada por label se **rs = rt**.

    #### `bne rs, rt, label`
    - branch if note equal: desvia para a instrução rotulada por label se **rs =/= rt**.

    #### `slt rd, r1, r2`
    - set on less than: se r1<r2, define rd=1, senão rd=0
    - essa instrução possui variantes imediatas e sem sinal:
        - `slti rd, reg, const`
            - se reg<const, rd=1, senão rd=0
        - `sltu rd, r1, r2`
            - faz o mesmo que slt, considerando números sem sinal

2. **Desvio incondicional:**
    #### `j label`
        - jump: desvia para a instrução rotulada por label.

### Exemplos: 

#### Desviar para a instrução rotulada por label:
- Se $s0 < $s1

    ```assembly
    slt $t0, $s0, $s1
    bne $t0, $zero, label # se $t0 =/= 0, então $t0 = 1, logo $s0 < $s1
    ```

    ```assembly
    li $t1, 1
    slt $t0, $s0, $s1
    beq $t0, $t1, label
    ```

- Se $s0 > $s1
    ```assembly
    slt $t0, $s1, $s0 # se $s0 > $s1, $t0=1
    bne $t0, $zero, label 
    ```

- Se $s0 >= $s1
    - em 2 etapas: verifica um sinal por vez e direciona de acordo com o resultado

    - só se é menor
        ```assembly
        slt $t0, $s0, $s1 # se $s0 </ $s1, $s0 >= $s1
        beq $t0, $zero, label 
        ```

- Se $s0 <= $s1
    ```assembly
    slt $t0, $s1, $s0 
    beq $t0, $zero, label # se $t0 = 0, então $s0 não é maior que $s1, $s0 <= $s1
    ```

#### Resultado das instruções

$s0 = 1111 ... 1111 1111

$s1 = 0000 ... 0000 0000

- `slt $t0, $s0, $s1`
    - $t0 = 1, $s0 < 0, considera sinal

- `sltu $t0, $s0, $s1`
    - $t0 = 0, $s0 = 2^32 - 1, não considera sinal

#### Se $t0 tiver o valor 1, imprime "verdadeiro" na tela.

```assembly
.data
v: .asciiz "verdadeiro\n"  # mensagem a ser exibida

.text

main: 
    [mascara para carregar $t0]  # aqui você define o valor de $t0
    li $t1, 1            # carrega o valor 1 em $t1
    beq $t0, $t1, imprime # se $t0 e $t1 são iguais, vá para imprime
    j encerra             # caso contrário, pule para o encerramento

imprime:
    li $v0, 4            # código de sistema para impressão de string
    la $a0, v            # carrega o endereço de v em $a0
    syscall              # executa a impressão

encerra:
    li $v0, 10           # código de sistema para encerrar o programa
    syscall

```

## Laços
São cindicionais que se repetem enquanto satisfizer uma condição.

### Exemplo:
```C
i = 0, a = 0;
while (i < 10){
    a = a + 1;
    i++;
}
```

```assembly
    move $t0, $zero # i
    move $s0, $zero # a

loop:
    slti $t1, $t0, 10 # i<10?
    beq $t1, $zero, exist 
    add $s0, $s0, $t0 # a=a+i
    addi $t0, $t0, 1 #i++
    j loop

exit:...
```

## Procedimentos

Na chamada a procedimento, temos:

- **Caller**: programa que chama o procedimento
- **Callee**: procesimento que é chamado

### Etapas de chamada a um procedimento:

1. Coloque os parâmetros nos registradores;
2. Desvie a execução para a primeira linha do procedimento;
3. Ajuste o armazenamento para o procesimento;
4. Execute o procedimento;
5. Salve o resultado no registrador de retorno;
6. Retorne ao caller.

### Convenções:

1. Um procedimento nunca deve sobrescrever o valor dos registradores $s0 a $s7;
2. Chamadas aninhadas devem salvar o endereço de retorno;
3. Argumentos são passados nos registradores $a0 a $s3. Excedentes devem usar a memória;
4. O valor de retorno deve ser armazenado em $v0.

### Desvio para um procedimento:

`jal rotulo`
- jump and link: Salva o endereço da próxima instrução em $ra

`jr $ra`
- jump register: Retorna ao endereço de $ra 

### Memória

1. Pilha
    - Cresce para baixo
    - **$sp:** Aponta para o topo da pilha
    - Deve ser devolvida como foi recebida
2. Dados dinâmicos
3. Dados estáticos
4. Reservados

- Como usar a pilha:
    - Abre espaço **decrementando** o $sp
    - Salva os dados
- Como restaurar a pilha:
    - Lê os dados da pilha
    - Restaura o espaço **incrementando** o $sp

### Exemplos:

1. Soma

    ```C
    int main (){
        int a = 10, b = 5;
        int c;

        c = soma (a, b);
        printf ("%d", c);
        return 0;
    }

    int soma (int a, int b){
        return a + b;
    }
    ```

    Onde:
    - main: Caller
    - soma: Callee
    - `c = soma (a, b);`: Program Counter

    ```Assembly
    li $s0, 10
    li $s1, 5

    move $a0, $s0
    move $a1, $s1

    jal soma
    move $a0, $v0 # $ra
    li $s0, 5
    syscall
    li $v0, 10
    syscall

    soma:
        add $v0, $a0, $a1
        jr $ra
    ```

2. Media

    ```C
    int main (){
        int a = 10, b = 5;
        int c;

        c = media (a, b);
        printf ("%d", c);
        return 0;
    }

    int media (int a, int b){
        return soma (a, b)/2;
    }

    int soma (int a, int b){
        return a + b;
    }
    ```

    ```Assembly
    li $a0, 10
    li $a1, 5

    jal media
    move $a0, $v0 # $ra
    li $s0, 5
    syscall
    li $v0, 10
    syscall

    media:
        addi $sp, $sp, -4
        sw $ra, 0 ($sp)
        jal soma
        lw $ra, 0 ($sp)
        addi $sp, $sp, 4
        srl $v0, $v0, 1
        jr $ra

    soma:
        add $v0, $a0, $a1
        jr $ra
    ```

3. Recursiva
    
    ```C
    int fatorial (int n){
        if (n<1) return 1;
        else return n*fatorial(n-1);
    }
    ```

    ```Assembly
    fatorial:
        addi $sp, $sp, -4
        sw $ra, 0($sp)

        slti $t0, $a0, 1
        bne $t0, $zero, ret1

        addi $a0, $a0, -1
        jal fatorial

        addi $a0, $a0, 1
        mul $v0, $a0, $v0 # retorna n*fatorial(n-1)

        lw $ra, 0($sp)
        addi $sp, $sp, 4

        jr $ra

    ret1:
        li $v0, 1
        addi $sp, $sp, 4
        jr $ra
    ```
