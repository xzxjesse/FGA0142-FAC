    .text
    .globl multfac

multfac:
    # Recebe os parâmetros nos registradores $a0 (multiplicando) e $a1 (multiplicador)
    
    # Inicializa os registradores hi e lo com 0
    move    $hi, $zero
    move    $lo, $zero
    
    # Verifica se o multiplicando é negativo
    bltz    $a0, neg_multiplicando
    
    # Verifica se o multiplicador é negativo
    bltz    $a1, neg_multiplicador
    
    # Caso ambos sejam positivos, realiza a multiplicação normalmente
    mul_loop:
        add     $lo, $lo, $a0        # Adiciona o multiplicando ao acumulador lo
        sub     $a1, $a1, 1          # Decrementa o multiplicador
        bgtz    $a1, mul_loop        # Se o multiplicador for maior que zero, repete o loop
        jr      $ra                  # Retorna ao chamador
    
    # Caso o multiplicando seja negativo
    neg_multiplicando:
        negu    $a0, $a0             # Torna o multiplicando positivo
        jal     multfac              # Chama o procedimento novamente
        negu    $hi, $hi             # Torna o valor de hi negativo
        jr      $ra                  # Retorna ao chamador
    
    # Caso o multiplicador seja negativo
    neg_multiplicador:
        negu    $a1, $a1             # Torna o multiplicador positivo
        jal     multfac              # Chama o procedimento novamente
        negu    $lo, $lo             # Torna o valor de lo negativo
        jr      $ra                  # Retorna ao chamador
