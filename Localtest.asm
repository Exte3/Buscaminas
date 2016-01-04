		# $a0 es ingresado por teclado
		li $a0, 4
		
		mul $a0, $a0, $a0
		move $a1, $a0
		# int i = 0
		add $t0, $zero, $zero
		lw $t1, 0($sp)
		jal crear
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
			
			seguir:		
			move $ra, $t7
			move $a1, $t8
			#cargar dato en $t1 y luego moverse
			lw $t1, -4($t1)
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
				sw $t3, -4($t1)
				j seguir

imprimir:

	lw $t3, -8($sp)
	move $a0, $t3
	li $v0, 1
	syscall
end: