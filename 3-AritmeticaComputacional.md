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

    - Obs.: O complemento a dois de um número X numa arquitetura de n bits vale 2^n - x em sua representação sem sinal - por isso "complemento a 2" (na base 2).

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

##### Explicação do código

**Linha 1:**
```assembly
addu $t0, $t1, $t2
```
- **Descrição:** Realiza a soma de \( t1 \) e \( t2 \), armazenando o resultado em \( t0 \).
- **Detalhe:** A instrução `addu` (add unsigned) não detecta ou gera exceção de overflow, mesmo para números com sinal.

**Linha 2:**
```assembly
xor $t3, $t1, $t2
```
- **Descrição:** Realiza a operação lógica XOR entre \( t1 \) e \( t2 \), armazenando o resultado em \( t3 \).
- **Propósito:** Determina se \( t1 \) e \( t2 \) têm sinais diferentes:
  - \( XOR \) resulta em \( 1 \) no bit mais significativo (MSB) se os sinais forem diferentes.
  - Se \( t1 \) e \( t2 \) têm o mesmo sinal, \( MSB = 0 \).

**Linha 3:**
```assembly
slt $t3, $t3, $zero
```
- **Descrição:** Verifica se \( t3 \) é menor que zero.  
  - A instrução `slt` (set on less than) define \( t3 = 1 \) se \( t3 < 0 \); caso contrário, \( t3 = 0 \).
- **Propósito:** Identifica se \( t3 \) tem o bit mais significativo igual a \( 1 \), indicando que \( t1 \) e \( t2 \) têm sinais diferentes.

**Linha 4:**
```assembly
bne $t3, $zero, sem_overflow
```
- **Descrição:** Se \( t3 =/= 0 \), os sinais de \( t1 \) e \( t2 \) são diferentes, e **não pode haver overflow**. A execução salta para o rótulo `sem_overflow`.

**Linha 5:**
```assembly
xor $t3, $t0, $t1
```
- **Descrição:** Realiza \( XOR \) entre \( t0 \) (resultado da soma) e \( t1 \), armazenando o resultado em \( t3 \).
- **Propósito:** Verifica se o sinal do resultado \( t0 \) é diferente do sinal de \( t1 \).  
  - Se o MSB de \( t3 = 1 \), o sinal do resultado mudou, indicando overflow.

**Linha 6:**
```assembly
slt $t3, $t3, $zero
```
- **Descrição:** Verifica se \( t3 \) é menor que zero.
- **Propósito:** Determina se houve alteração no sinal, o que indicaria overflow.


**Linha 7:**
```assembly
bne $t3, $zero, overflow
```
- **Descrição:** Se \( t3 =/= 0 \), houve alteração no sinal do resultado, indicando **overflow**. A execução salta para o rótulo `overflow`.


#### Números sem sinal

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

##### Explicação do código

**Linha 1:**
```assembly
addu $t0, $t1, $t2
```
- **Descrição:** Soma \( t1 \) e \( t2 \), armazenando o resultado em \( t0 \).
- **Detalhe:** Usado para números sem sinal, onde não há controle automático de overflow.

**Linha 2:**
```assembly
nor $t3, $t1, $zero
```
- **Descrição:** Realiza a operação NOR entre \( t1 \) e \( zero \), armazenando o resultado em \( t3 \).
- **Propósito:** Calcula o complemento a dois de \( t1 \) de forma indireta:
  - \( t3 =~ t1 \) (inversão dos bits de \( t1 \)).

**Linha 3:**
```assembly
sltu $t3, $t3, $t2
```
- **Descrição:** Compara \( t3 \) (valor invertido de \( t1 \)) com \( t2 \) usando comparação sem sinal (`sltu`).
  - Define \( t3 = 1 \) se \( t3 < t2 \); caso contrário, \( t3 = 0 \).
- **Propósito:** Determina se o complemento a dois de \( t1 \) é menor que \( t2 \), o que indicaria overflow.

**Linha 4:**
```assembly
bne $t3, $zero, overflow
```
- **Descrição:** Se \( t3 =/= 0 \), houve **overflow**. A execução salta para o rótulo `overflow`.

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

### Exemplo:

|Iteração|Etapa|Produto|
|:---:|:---:|:---:|
|0|inicialização|0000 1010|
|1|p[0]=0|0000 1010|
||p>>1|0000 0101|
|2|p[7..4]+=M|1100 0101|
||p>>1|0110 0010|
|3|p[0]=0|0110 0010|
||p>>1|0011 0001|
|4|p[7..4]+=M|1111 0001|
||p>>1|0111 1000|

### Instruções em Assembly  

No MIPS, há duas instruções para realizar multiplicação:  

- **`mult r1, r2`**: Multiplicação com sinal.  
- **`multu r1, r2`**: Multiplicação sem sinal.  

O resultado da multiplicação é armazenado em dois registradores especiais: **`hi`** e **`lo`**.  

| **Registrador** | **Tamanho** |  
|------------------|-------------|  
| `hi`            | 32 bits     |  
| `lo`            | 32 bits     |  

#### Como acessar os registradores `hi` e `lo`?  

1. **Para o registrador `lo`**:  
   - **`mtlo reg`**: Move o valor de um registrador geral (`reg`) para o registrador especial `lo` (Move To LO).  
   - **`mflo reg`**: Move o valor armazenado no registrador especial `lo` para um registrador geral (`reg`) (Move From LO).  

2. **Para o registrador `hi`**:  
   - **`mthi reg`**: Move o valor de um registrador geral (`reg`) para o registrador especial `hi` (Move To HI).  
   - **`mfhi reg`**: Move o valor armazenado no registrador especial `hi` para um registrador geral (`reg`) (Move From HI).  

#### Diferença entre os registradores `hi` e `lo`  

- **`hi`**: Contém a parte mais significativa do produto (High).  
- **`lo`**: Contém a parte menos significativa do produto (Low).  

### Exemplo prático  

```assembly  
# Multiplicação de r1 e r2  
mult r1, r2  

# Acessando o resultado da multiplicação  
mflo r3   # Move a parte menos significativa (low) para r3  
mfhi r4   # Move a parte mais significativa (high) para r4  
```  

Assim, o registrador **`hi`** armazena o "resto" ou a parte alta do produto, enquanto o registrador **`lo`** contém a parte principal ou baixa do produto.

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

### Exemplo:

|Iteração|Etapa|Resto|
|:---:|:---:|:---:|
|0|inicialização|0000 0111|
||r<<1|0000 1110|
|1|r[7..4]-=divisor|<0 1110|
||passo 3 (b)|0001 1100|
|2|r[7..2]-=divisor|<0 1100|
||passo 3 (b)|0011 1000|
|3|r[7..4]-=divisor|0001 1000|
||passo 3 (1)|0011 0001|
|4|r[7..4]-=divisor|0001 0001|
||passo 3 (a)|0010 0011|
|-|r[7..4]|0001 0011|

### Instruções em Assembly  

No MIPS, há uma única instrução para realizar divisão:  

- **`div r1, r2`**: Realiza a divisão de inteiros, onde `r1` é o dividendo e `r2` é o divisor.  

O resultado da operação é armazenado em dois registradores especiais: **`lo`** e **`hi`**, assim como na multiplicação.  

#### Como acessar os registradores `hi` e `lo`?  

1. **Para o registrador `lo`**:  
   - **`mtlo reg`**: Move o valor de um registrador geral (`reg`) para o registrador especial `lo` (Move To LO).  
   - **`mflo reg`**: Move o valor armazenado no registrador especial `lo` para um registrador geral (`reg`) (Move From LO).  

2. **Para o registrador `hi`**:  
   - **`mthi reg`**: Move o valor de um registrador geral (`reg`) para o registrador especial `hi` (Move To HI).  
   - **`mfhi reg`**: Move o valor armazenado no registrador especial `hi` para um registrador geral (`reg`) (Move From HI).  

#### Diferença entre os registradores `hi` e `lo` no contexto da divisão  

- **`hi`**: Contém o **resto** da divisão.  
- **`lo`**: Contém o **quociente** da divisão.  

### Exemplo prático  

```assembly  
# Divisão de r1 por r2  
div r1, r2  

# Acessando o resultado da divisão  
mflo r3   # Move o quociente (low) para r3  
mfhi r4   # Move o resto (high) para r4  
```  

Assim, o registrador **`hi`** armazena o resto da divisão inteira, enquanto o registrador **`lo`** contém o quociente.

## Algoritmos com Sinal  

1. **Converta ambos os números para positivo**:  
   Utilize o módulo (valor absoluto) dos números de entrada.  

2. **Execute o algoritmo**:  
   Realize a operação desejada (multiplicação ou divisão) com os valores positivos.  

3. **Aplique as regras de sinal no resultado**:  

   ### Multiplicação:  
   - O resultado será **positivo** se os sinais dos dois números forem iguais.  
   - O resultado será **negativo** se os sinais dos dois números forem diferentes.  

   ### Divisão:  
   - O quociente será **positivo** se os sinais do dividendo e do divisor forem iguais.  
   - O quociente será **negativo** se os sinais do dividendo e do divisor forem diferentes.  

   - *Obs: Independente de qual sinal o divisor terá, o sinal do valor do resto sempre será equivalente ao sinal do dividendo.*

   Exemplo:  
   ```  
   Multiplicação:  
   (+6) × (-3) = -18  
   (-6) × (-3) = +18  

   Divisão:  
   (+6) ÷ (-3) = -2  
   (-6) ÷ (-3) = +2  
   ```  