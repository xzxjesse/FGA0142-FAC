# Resumo - Introdução
- **Hardware**: executa um conjunto de operações (binário)
    - **ISA (Instruction Set Architecture)**: conjunto de instruções
        - **Linguagem de máquina**: códigos binários que abstraem as operações do ISA

## Níveis de abstração:
<img src="CamadasComputador.jpg" alt="Camadas do Computador" width="400"/>

- todo software programado em alto nível passa por um processo de **transformação** para que possa ser **executado pelo hardware**.

## Conjunto de instruções

||RISC|CISC|
|:---:|---|---|
|**Instruções**|- consome 1 ciclo de clock|- pode consumir mais de 1 ciclo de clock|
||- baixo número de instruções|- grande número de instruções|
||- mais simples|- mais complexas|
|**Projeto**|- centrado no software|- centrado no hardware|
|**Memória**|- uso menos eficiente|- uso mais eficiente|
|**Execução**|- direto no hardware|- microprograma|

## Modelo atual de computador

<img src="ArquiteturaVonNeumann.png" alt="Modelo de Computador" width="400"/>

- **Memória:** armazena tanto os dados quanto o programa que será executado.