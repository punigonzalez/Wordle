.data
    @ Archivos
    words_file:      .asciz "words.txt"
    ranking_file:    .asciz "ranking.txt"
    mode_r:         .asciz "r"
    mode_w:         .asciz "w+"

    @ Buffers
    word_buffer:    .space 256
    input_buffer:   .space 256
    name_buffer:    .space 64
    ranking:        .space 256

    @ Pantallas ASCII
    title_screen:   .incbin "title.txt"
    game_screen:    .incbin "game.txt"
    win_screen:     .incbin "win.txt"
    lose_screen:    .incbin "lose.txt"

    @ Mensajes
    name_prompt:    .asciz "\n\nIngrese su nombre: "
    menu_prompt:    .asciz "\n1. Jugar\n2. Salir\nElija una opción: "
    word_prompt:    .asciz "\nIngrese una palabra de %d letras: "
    points_msg:     .asciz "\nPuntos: %d"
    ranking_title:  .asciz "\nRANKING"
    clear_screen:   .asciz "\033[H\033[J"

    @ Variables de juego
    current_word:   .space 32
    word_length:    .word 0
    attempts:       .word 5
    points:         .word 25
    player_name:    .space 64

.text
.global main

@ Función principal
main:
    push {lr}
    bl clear_terminal
    bl show_title_screen
    bl pedir_nombre
    
menu_loop:
    bl show_menu
    bl get_menu_choice
    cmp r0, #1
    beq start_game
    cmp r0, #2
    beq exit_game
    b menu_loop

start_game:
    bl leer_palabras
    bl sortear_palabra
    bl calcular_letras
    bl game_loop
    b menu_loop

@ Subrutinas principales
leer_palabras:
    push {lr}
    @ Abrir archivo de palabras
    ldr r0, =words_file
    ldr r1, =mode_r
    bl fopen
    mov r4, r0              @ Guardar file handle

    @ Leer palabras
    ldr r0, =word_buffer
    mov r1, #256
    mov r2, r4
    bl fgets

    @ Cerrar archivo
    mov r0, r4
    bl fclose
    pop {pc}

calcular_letras:
    push {lr}
    ldr r0, =current_word
    bl strlen
    ldr r1, =word_length
    str r0, [r1]
    pop {pc}

sortear_palabra:
    push {lr}
    @ Implementar selección aleatoria
    @ Por ahora usa la primera palabra
    ldr r0, =word_buffer
    ldr r1, =current_word
    bl strcpy
    pop {pc}

leer_palabra:
    push {lr}
    ldr r0, =word_prompt
    ldr r1, =word_length
    ldr r1, [r1]
    bl printf
    
    ldr r0, =input_buffer
    bl gets
    pop {pc}

verificar_letras_verdes:
    push {r4-r8, lr}
    mov r4, #0          @ índice
    mov r5, #0          @ contador verdes
    
green_loop:
    ldr r0, =current_word
    ldrb r6, [r0, r4]   @ letra palabra objetivo
    cmp r6, #0
    beq green_end
    
    ldr r0, =input_buffer
    ldrb r7, [r0, r4]   @ letra input usuario
    
    cmp r6, r7
    bne next_green
    
    @ Letra verde encontrada
    add r5, r5, #1
    ldr r0, ="\033[32m" @ Color verde
    bl printf
    mov r0, r7
    bl putchar
    ldr r0, ="\033[0m"  @ Reset color
    bl printf
    
next_green:
    add r4, r4, #1
    b green_loop
    
green_end:
    mov r0, r5          @ Retornar cantidad de verdes
    pop {r4-r8, pc}

verificar_letras_amarillas:
    push {r4-r8, lr}
    @ Similar a verificar_letras_verdes pero para amarillas
    @ Usa color amarillo: \033[33m
    pop {r4-r8, pc}

calcular_puntos:
    push {lr}
    ldr r0, =attempts
    ldr r0, [r0]
    mov r1, #5
    mul r0, r0, r1      @ puntos = intentos * 5
    ldr r1, =points
    str r0, [r1]
    pop {pc}

pedir_nombre:
    push {lr}
    ldr r0, =name_prompt
    bl printf
    ldr r0, =name_buffer
    bl gets
    
    @ Copiar nombre a variable permanente
    ldr r0, =player_name
    ldr r1, =name_buffer
    bl strcpy
    pop {pc}

verificar_intentos:
    push {lr}
    ldr r0, =attempts
    ldr r1, [r0]
    sub r1, r1, #1      @ Decrementar intentos
    str r1, [r0]
    cmp r1, #0          @ Verificar si quedan intentos
    moveq r0, #0
    movne r0, #1
    pop {pc}

@ Rutinas de interfaz
show_title_screen:
    push {lr}
    ldr r0, =title_screen
    bl printf
    pop {pc}

show_game_screen:
    push {lr}
    ldr r0, =clear_screen
    bl printf
    ldr r0, =game_screen
    bl printf
    
    @ Mostrar puntos actuales
    ldr r0, =points_msg
    ldr r1, =points
    ldr r1, [r1]
    bl printf
    
    @ Mostrar ranking
    bl show_ranking
    pop {pc}

show_ranking:
    push {lr}
    ldr r0, =ranking_title
    bl printf
    
    @ Leer y mostrar ranking desde archivo
    ldr r0, =ranking_file
    ldr r1, =mode_r
    bl fopen
    mov r4, r0
    
    ldr r0, =ranking
    mov r1, #256
    mov r2, r4
    bl fgets
    
    ldr r0, =ranking
    bl printf
    
    mov r0, r4
    bl fclose
    pop {pc}

game_loop:
    push {lr}
game_loop_start:
    bl show_game_screen
    bl leer_palabra
    bl verificar_letras_verdes
    cmp r0, #5              @ Si todas las letras son verdes
    beq win_game
    
    bl verificar_letras_amarillas
    bl verificar_intentos
    cmp r0, #0
    beq lose_game
    b game_loop_start
    
win_game:
    bl calcular_puntos
    bl update_ranking
    bl show_win_screen
    pop {pc}
    
lose_game:
    bl show_lose_screen
    pop {pc}

@ Utilidades
clear_terminal:
    push {lr}
    ldr r0, =clear_screen
    bl printf
    pop {pc}

update_ranking:
    push {lr}
    @ Implementar actualización del ranking
    pop {pc}

exit_game:
    mov r0, #0
    pop {pc}
