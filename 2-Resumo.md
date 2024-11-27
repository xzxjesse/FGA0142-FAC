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

## **Inteiros Binários**
- **Arquitetura 32 bits:** Inteiros representados com 32 bits.
1. **Sem sinal:** 
   - Valores de 0 a \(2^{32} - 1\) (0 a 4.294.967.295).

2. **Com sinal (Complemento de 2):** 
   - Valores de \(-2^{31}\) a \(2^{31} - 1\) (-2.147.483.648 a 2.147.483.647).

## **Formatos de Instruções**
1. **Tipo-R:** Operações aritméticas e lógicas.
   - Estrutura: `op | rs | rt | rd | shamt | funct`.

2. **Tipo-I:** Operações com constantes ou acessos à memória.
   - Estrutura: `op | rs | rt | const/offset`.

3. **Tipo-J:** Instruções de salto.
   - Estrutura: `op | endereço`.

## **Operações Lógicas**
- **Deslocamentos:**
  - `sll` (esquerda): Multiplica por \(2^i\).
  - `srl` (direita): Divide por \(2^i\).

- **Operações bit a bit:** `and`, `or`, `xor`, `nor`.

## **Instruções de Desvio**
1. **Condicional:** 
    - `beq`: rs = rt
    - `bne`: rs =/= rt
    - `slt`: r1 < r2
        - `sltu`: slt sem sinal
        - `slti`: reg < const
2. **Incondicional:** 
   - `j`

## **Laços:** 
Utilizam instruções de desvio para criar repetições.

## **Procedimentos:**
Usam `$a0-$a3` para argumentos e `$v0` para retornos.
  - Exemplo: `jal label` para desvio e `jr $ra` para retorno.

## **Memória**
- **Pilha:** Gerenciada pelo registrador `$sp` (cresce para baixo).
- **Tipos de dados:** Dinâmicos, estáticos, e reservados.

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

6. **Extrair um bit de um registrador:**
        
        Suponha que desejamos extrair o quinto bit menos significativo de $s0:

        $s0 = 0000 ... 0001 0010
        $t0 = 0000 ... 0001 0000

        ```assembly
        # and com 1:
        addi $t0, $zero, 1
        sll  $t0, $t0, 4      # $t0 é a máscara
        and  $t0, $t0, $s0    # $t0 é o resultado, $t0 e $s0 são operandos
        ```

7. **Modificar o valor de um bit:**

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

8. **Desviar para a instrução rotulada por label**

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

9. **Laços**
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

10. **Procedimentos**

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
