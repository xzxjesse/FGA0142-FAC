# Aritmética Computacional

Sistema numérico posicional, o valor i-ésimo dígito vale Di x base^i, i=0, 1, ...

- O infinito que é representado, convencionalmente em linha, se torna um anel.

## Representação de sinais

### Magnitude

    Nesta representação, o MSB é o bit de sinal.

    ```
    +19 = 0001 0011
    -19 = 1001 0011
    ```

    - Problema: o zero é ambíguio

        ```
        +0 = 0000 0000
        -0 = 1000 0000
        ```

### Complemento a 1

    Todos os bits são negados na representação negativa.

    ```
    +19 = 0001 0011
    -19 = 1110 1100
    ```

    - Problema: o zero é ambíguo

        ```
        +0 = 0000 0000
        -0 = 1111 1111
        ```

### Complemento a 2

    Para transformar em negativo, nega-se e soma 1.

    ```
    +19 = 0001 0011
    -19 = 1110 1101
    ```

    - Com isso, elimina-se a ambiguidade do zero:

        ```
        +0 = 0000 0000
        -0 = 1 0000 0000 -> overflow
        ```

    - Obs.: O complement a dois de um número X numa arquitetura de n bits vale 2^n - x em sua representação sem sinal - por isso "complemento a 2" (na base 2).

        ```
        +6 = 0110
        -6 = 1010
        ```
        - 2^4 - 6 = 16
        - 16 - 6 = 10
        - +10 = 1010

### Excesso

    Considera-se um "deslocamento" d, os números são todos positivos, e seu real valor é seu valor positivo subtraindo-se d.

    ```
    Em um sistema de 4 bits, considerando d=8:

    representação (sempre positiva)
    0 -> 15
    
    valor real = representação - d
    -8 -> 7
    ```

## OverFlow (na adição)

Considere A+B (com sinal):

- Se A>=0 e B<=0, o resultado será menos negativo que B ou será menor que A, portanto nunca há overflow.
- Se A>=0 e B>=0, há overslow apenas se o resultado for negativo.
- Se A<=0 e B<=0, há overflow se o resultado for maior ou igual a zero.

    ```
    (+) + (+) = (-)
    (-) + (-) = (+)
    ```

### Como lidar com OverFlow:

#### Números com sinal

```Assembly
addu $t0, $t1, $t2

# Verifica se os sinais de $t1 e $t2 são diferentes
xor $t3, $t1, $t2

# Se o bit mais significativo de $t3 = 1, sinais diferentes
slt $t3, $t3, $zero
bne $t3, $zero, sem_overflow

# Se o sinal da soma for igual ao dos operandos, sem overflow
xor $t3, $t0, $t1
slt $t3, $t3, $zero
bne $t3, $zero, overflow
```

#### Números com sinal

```Assembly
addu $t0, $t1, $t2

# Negativa $t1 (primeiro passo para complemento a dois)
nor $t3, $t1, $zero

# Com isso, $t3 = 2^{32} - $t1 - 1
# Para verificar overflow, verifica-se se $t3 < $t2
# 2^{32} - $t1 - 1 < $t2 => 2^{32} - 1 < $t1 + $t2 => overflow
sltu $t3, $t3, $t2
bne $t3, $zero, overflow
```

## Algoritmo de multiplicação

1. Inicializa P=0
2. P=P+Q0*m
3. Deslocar M uma casa à esquerda e desloque Q uma casa à direita
4. Se não for a 32° interação, volte ao passo 2

### Otimizado
1. P=0
2. Acumule o multiplicando na parte mais significativa de P, se Q0=1
3. Desloque P à direita
4. Se não for a 32° interação, volte ao passo 2

## Algoritmo de divisão

1. Resto = dividendo
2. Resto = resto - divisor
3. Q<<1
    - se resto>=0, Q[0]=1
    - se resto<0, resto = resto + divisor 
4. Divisor>>1 
5. Se não for a 32° interação, volte ao passo 2

### Otimizado
Considerando que o divisor possui sempre uma metade zerada, podemos fixar o divisor e deslocar o resto à esquerda. Com isso, podemos usar a parte menos significativa do resto como quociente.

1. Resto = dividendo
2. R<<1
3. R[63...32] -= divisor
    - se resto >=0, R<<1 e R[0]=1
    - se resto <0, R[63...32]+=divisor e R<<1
4. Se não for a 33° iteração, volte ao passo 3
5. R[63...32]>>1