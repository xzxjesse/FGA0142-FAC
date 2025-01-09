## Aritmética Computacional:

1. **Conceitual**:  
   Explique como o sistema numérico posicional determina o valor de cada dígito em um número. Por que o sistema é chamado de "posicional"?  

2. **Prática**:  
   Dado um número de 4 bits no sistema de complemento a 2, como você representaria o número -6? Mostre o cálculo detalhado para chegar à representação binária correta.  

3. **Conceitual e Prática**:  
   Compare as representações de sinais "magnitude", "complemento a 1" e "complemento a 2". Qual delas elimina a ambiguidade do zero e por quê? Dê exemplos numéricos para justificar sua resposta.  

## Overflow na Adição:

1. **Conceitual**:  
   Explique o que é overflow em operações de adição com números com sinal. Por que ele ocorre apenas em casos específicos, como quando dois números positivos resultam em um número negativo?

2. **Prática**:  
   Considere os números de 4 bits representados em complemento a 2: \( A = 0110 \) (\(+6\)) e \( B = 0101 \) (\(+5\)).  
   - Realize a soma \( A + B \).  
   - Determine se houve overflow e justifique sua resposta com base nas regras de detecção de overflow.  

3. **Conceitual e Prática**:  
   Analise o seguinte trecho de código Assembly para verificar overflow:  
   ```assembly
   addu $t0, $t1, $t2
   xor $t3, $t1, $t2
   slt $t3, $t3, $zero
   bne $t3, $zero, sem_overflow
   xor $t3, $t0, $t1
   slt $t3, $t3, $zero
   bne $t3, $zero, overflow
   ```  
   - Explique o papel de cada instrução na verificação de overflow.  
   - Por que é importante verificar tanto os sinais dos operandos quanto o sinal do resultado?  

## Algoritmo de Multiplicação:

1. **Conceitual**:  
   Explique a diferença entre a abordagem básica do algoritmo de multiplicação e sua versão otimizada. Quais melhorias a versão otimizada oferece em termos de desempenho e uso de recursos?

2. **Prática**:  
   Dado o exemplo abaixo, complete as etapas do algoritmo de multiplicação otimizado:  
   - Multiplicando (\( M \)) = \( 0011 \) (3)  
   - Multiplicador (\( Q \)) = \( 0101 \) (5)  
   - Inicialize \( P = 0 \).  
   - Realize as iterações do algoritmo para calcular o produto.  

3. **Conceitual e Prática**:  
   No MIPS, o comando **`mult`** armazena o resultado da multiplicação nos registradores `hi` e `lo`. Explique a função desses registradores e descreva como você moveria os valores armazenados neles para registradores gerais, usando um exemplo prático em Assembly.

## Algoritmo de Divisão:

1. **Conceitual**:  
   Explique como o algoritmo básico de divisão difere da versão otimizada. Quais são as principais vantagens de deslocar o resto à esquerda em vez de deslocar o divisor à direita?

2. **Prática**:  
   Considere o dividendo \( D = 25 \) e o divisor \( M = 6 \). Execute as primeiras 3 iterações do algoritmo básico de divisão manualmente, detalhando os valores do resto e do quociente a cada passo.

3. **Conceitual e Prática**:  
   No MIPS, a instrução **`div`** armazena o quociente e o resto nos registradores `lo` e `hi`, respectivamente. Suponha que você tenha os valores \( r1 = 20 \) e \( r2 = 3 \). Escreva um programa em Assembly para calcular o quociente e o resto, armazenando-os em registradores gerais \( r3 \) e \( r4 \). Explique como o acesso aos registradores `lo` e `hi` é realizado.

## Algoritmos com Sinal:

1. **Conceitual**:  
   Por que é necessário converter os números para valores absolutos antes de realizar operações como multiplicação ou divisão em algoritmos com sinal? Explique como essa abordagem simplifica a lógica do algoritmo.

2. **Prática**:  
   Dado A = -12 e B = 4, aplique o algoritmo com sinal para calcular:  
   a) A.B  
   b) A/B  
   Detalhe cada etapa, desde a conversão para valores absolutos até a aplicação das regras de sinal.

3. **Conceitual e Prática**:  
   No contexto de divisão com sinal, explique por que o sinal do resto deve corresponder ao sinal do dividendo. Dado \( A = -17 \) e \( B = 5 \), calcule o quociente e o resto manualmente, ilustrando como o algoritmo garante que essa regra seja cumprida.