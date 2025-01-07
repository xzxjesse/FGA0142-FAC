1. **Qual é a função do registrador `$zero` na arquitetura MIPS e como ele é utilizado em operações aritméticas?**
   
2. **Explique a diferença entre os tipos de dados `word`, `half` e `byte` na arquitetura MIPS, incluindo o tamanho de cada um. Dê exemplos de como são declarados na seção `.data` de um programa em Assembly MIPS.**

3. **Dado o seguinte trecho de código em Assembly MIPS:**
   ```assembly
   add $t0, $s1, $s2 
   add $t1, $s3, $s4
   add $s0, $t0, $t1
   ```
   O que cada linha do código está realizando? Explique o papel de cada registrador utilizado.

4. **Explique a pseudo-instrução `move` em Assembly MIPS e como ela é implementada com instruções nativas. Qual a diferença entre a implementação utilizando `add` e `or`?**

5. **Qual é o propósito da pseudo-instrução `li` em Assembly MIPS? Como ela pode ser implementada dependendo do tamanho da constante, e qual é a diferença no processo de carregamento para constantes de até 16 bits e para constantes maiores?**

6. **Qual é a principal diferença entre os registradores `$s0-$s7` e `$t0-$t7` na arquitetura MIPS, e como cada um é utilizado em um programa?**

7. **Explique o processo de execução de uma system call em Assembly MIPS. Quais são os passos necessários para invocar uma system call e quais registradores são usados para passar os dados necessários?**

8. **Descreva a função e o uso da system call de código 5 (ler um inteiro) em Assembly MIPS. Mostre um exemplo de código em que dois números inteiros são lidos e sua soma é impressa na tela.**

9. **O que são instruções imediatas em Assembly MIPS? Explique como a instrução `addi` funciona e qual é a diferença entre usá-la com um registrador e uma constante, em comparação com operações que utilizam dois registradores.**

10. **Explique como a instrução `lw` funciona em Assembly MIPS. Quais são os registradores utilizados e como o endereço de memória é calculado? Forneça um exemplo de código que carrega um valor de um vetor para um registrador.**

11. **Qual a diferença entre as instruções `lw` e `sw` e suas respectivas variações? Dê exemplos de quando seria apropriado usar cada uma delas.**

12. **Dado o exemplo "A[12] = g + A[8]", descreva o processo em Assembly MIPS utilizando as instruções de acesso à memória. Quais são as etapas e instruções necessárias para carregar, somar e armazenar os valores corretamente?**

13. **Explique a diferença entre a representação de inteiros sem sinal e inteiros com sinal em uma arquitetura de 32 bits. Como a representação de um número negativo, como -5, é feita usando o complemento de 2?**

14. **O que é a extensão de sinal e como ela funciona? Dê exemplos de como a extensão de sinal seria aplicada a um número binário de 4 bits para 8 bits, usando um valor negativo.**

15. **Descreva os três tipos de formatos de instrução em MIPS: Tipo-R, Tipo-I e Tipo-J. Forneça um exemplo de cada tipo, explicando como os campos de cada formato são preenchidos, com base nas instruções fornecidas.**

16. **Explique como as operações de deslocamento (sll e srl) funcionam em MIPS. Dê exemplos práticos, mostrando como o valor de um registrador é alterado após o deslocamento para a esquerda (sll) e para a direita (srl).**

17. **Como as operações lógicas `and`, `or`, `nor`, e `xor` são usadas em MIPS? Dê um exemplo de como realizar a extração de um bit de um registrador usando a operação `and` e uma máscara.**

18. **Explique a diferença entre os desvios condicionais `beq` e `bne`. Como eles são utilizados para alterar o fluxo de execução de um programa? Dê exemplos de situações em que cada um pode ser útil.**

19. **O que a instrução `slt` faz? Como ela é utilizada para comparar dois valores e definir o registrador de destino? Dê exemplos de como as variantes `slti` e `sltu` são usadas.**

20. **Explique como a instrução de desvio incondicional `j` funciona. Em que situações você poderia usar essa instrução em um programa?**

21. **O que acontece no exemplo de laço em Assembly quando a condição `i < 10` deixa de ser verdadeira? Explique o funcionamento das instruções `beq` e `j` nesse contexto.**

22. **Quais são as etapas envolvidas na chamada de um procedimento em MIPS? Por que é importante salvar o endereço de retorno no registrador `$ra` antes de desviar para um procedimento?**

23. **Como a pilha é utilizada no exemplo do cálculo da média? Explique o uso das instruções `addi`, `sw`, e `lw` para gerenciar a pilha.**

24. **No exemplo de soma, o que representa a instrução `jal soma`, e como o registrador `$v0` é utilizado para armazenar o valor retornado?**