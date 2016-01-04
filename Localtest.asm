		# $a0 es ingresado por teclado
		li $a0, 16
		
		mul $a0, $a0, $a0
		move $a1, $a0
		# int i = 0
		add $t0, $zero, $zero
		addiu $sp, $sp, -4
		jal crear
		mul $t0, $t0, 4
		addu $sp, $sp, $t0
		jal imprimir
		j end
crear:
			# -4(pos) corresponde al primer dato del arreglo.
			# La cabezera debe estar vacia
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
			#move $t5, $t0
			#li $t5, 0	
			sw $t0, -4($t1)
			lw $t0, -4($t1)
			#move $t0, $t5
			j seguir
imprimir:

	lw $t3, -16($sp)
	move $a0, $t3
	li $v0, 1
	syscall
end:
