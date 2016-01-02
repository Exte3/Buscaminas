.data

#Mensajes

	seleccion: .asciiz "1)Para usar un tablero predefinido 2)Para uno aleatorio : \n"
	plis: .asciiz "Por favor ingrese una opcion valida \n"
	newline:  .asciiz "\n"
	ale: .asciiz "Ingrese el tamaño de buscamina que desea, no mayor a 16 \n"
	outrange: .asciiz "El numero ingresado esta fuera de rango, intentelo nuevamente \n"
	
#Globales
	archivo: .asciiz "prueba.txt"
	buffer: .byte 0:256 #buffer de 256 bytes o 256 chars
.text

#menu de seleccion
inicio:
	la $a0, seleccion
	li $v0, 4
	syscall
	li $v0, 5
	syscall

	beq $v0, 1, predefinido
	beq $v0, 2, aleatorio
	bne $v0, 2, error

	error:
		la $a0, plis
		li $v0, 4
		syscall
		j inicio

	#predefinido es el que lee de un archivo
	predefinido:
		la $a0, archivo
		li $a1, 0
		li $a2, 0
		li $v0, 13
		syscall
		move $t0, $v0
		move $a0, $t0
		la $a1, buffer
		li $a2, 100
		li $v0, 14
		syscall
		#Esta parte lo imprime
		la $a0, buffer
		li $v0, 4
		syscall
		j end
	#aleatorio genera uno
	aleatorio:
		la $a0, ale
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		move $a0, $v0
		bgt $a0, 16, fuera
		blt $a0, 1, fuera
		#jal lengtharray
		move $a0, $v0
		mul $a0, $a0, $a0
		add $t0, $zero, $zero
		jal crear
		
		j end

		fuera:
			la $a0, outrange
			li $v0, 4
			syscall
			j aleatorio

		#funcion que calculara el numero de posiciones del arreglo
		#funcion que actualmente fue desechada
		lengtharray:
			mul $t0, $a0, $a0
			subi $t0, $t0, 1
			mul $v0, $t0, 4
			jr $ra
		
		crear:
			# -4(pos) corresponde al primer dato del arreglo.
			# La cabezera debe estar vacia
			bge $t0, $a0, end
			subi $t1, $t1, 4
			lw $t3, -4($t1)
			add $t3, $zero, $t0
			# Guarda un dato en la posicion correspondiete
			sw $t3, -4($t1)
			# i++
			addi $t0, $t0, 1
			j crear
		
		rellenar:
			
		#la idea es usar el modulo de 3 para el numero que sale, si es 0 se pone mina
		random:
			li $a0, 1
			li $a1, 100
			li $v0, 42
			syscall
			

end:
