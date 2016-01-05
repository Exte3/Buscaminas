.data

#Mensajes

	seleccion: .asciiz "1)Para usar un tablero predefinido 2)Para uno aleatorio : \n"
	plis: .asciiz "Por favor ingrese una opcion valida \n"
	newline:  .asciiz "\n"
	ale: .asciiz "Ingrese el tama�o de buscamina que desea, no mayor a 16 : \n"
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

	#predefinido es el que lee de un archivo, aun sin funcionar
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
		blt $a0, 3, fuera
		#jal lengtharray
		move $a0, $v0
		mul $a0, $a0, $a0
		move $a1, $a0
		# int i = 0
		add $t0, $zero, $zero
		addiu $sp, $sp, -4
		jal crear
		mul $t0, $t0, 4
		addu $sp, $sp, $t0
		
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
			# Los datos se guardan en el sp, actualmente se puede notar que las bombas
			# quedan introducidas aleatoriamente en el tablero, pero aun no se puede jugar
			# ni mistrar el tablero
			bge $t0, $a1, return
			move $t7, $ra
			move $t8, $a1
			jal random
			ble $a0, 15, mina
			bgt $a0, 15, nada 
			seguir:		
			move $ra, $t7
			move $a1, $t8
			#cargar dato en $t1 y luego moverse
			
			
			subi $t1, $t1, 4
			# Guarda un dato en la posicion correspondiete
			# i++
			addi $t0, $t0, 1
			j crear
		
		return:
			jr $ra
		
			
		
		random:
			li $a0, 1
			li $a1, 100
			li $v0, 42
			syscall
			jr $ra
			#Si el numero que retorna es igual o menor a 15 sera una mina
			
		mina:
			# 9 signifuca mina
			li $t3, 9
			move $t5, $t0
			sw $t3, -4($t1)
			lw $t0, -4($t1)
			move $t0, $t5
			add $t5, $zero, $zero
			j seguir
		nada:	
			move $t5, $t0
			li $t0, 0	
			sw $t0, -4($t1)
			lw $t0, -4($t1)
			move $t0, $t5
			j seguir
	imprimir:

		lw $t3, -16($sp)
		move $a0, $t3
		li $v0, 1
		syscall
			

end:
