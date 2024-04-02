	.data
	.align 0	#alinhando para string
initMsg:.asciz "Bem-vindo! Este é o jogo 'Adivinhe o número'!\nO computador escolheu um número entre 1 e 100, você consegue adivinhar qual é? Faça seu chute!\n"
			#mensagens de boas-vindas e instruções
chuteMsg: .asciz "Chute: "
randMsg: .asciz "\nNúmero aleatório: "
finalMsg: .asciz "\nFim! Obrigada por jogar! :D\n"
	
	.align 2	#alinhando para inteiro


	.text
	.align 2
	.globl main
	
main:
	addi a7, zero, 4 #printando msg de boas vindas e instruções
	la a0, initMsg
	ecall			
	
	jal randNum
	add s0, zero, a1 #s0 = nro aleatorio entre 0 e 100
	
	addi a7, zero, 5 #solicitando entrada de inteiro (chute de numero)
	ecall		
	
	add s1, zero, a0 #armazenando o chute em s1
	
	addi a7, zero, 4 #printando o chute--
	la a0, chuteMsg
	ecall
	
	addi a7, zero, 1
	add a0, zero, s1
	ecall		#--
	
	li a7, 4	#printando o nro aleatorio que foi gerado --
	la a0, randMsg
	ecall
	
	li a7, 1
	add a0, zero, s0
	ecall		#--
	
	addi a7, zero, 4 #printando msg final
	la a0, finalMsg
	ecall
	
	
	addi a7, zero, 10 #finalizando programa
	ecall

randNum:		#função que gera o numero pseudoaleatorio
			#mod -> a2 = 100; a -> a3 = 223; c -> a4 = 607; seed -> a5 = ecall; conta_aux -> t1; resultado -> a1
	addi a2, zero, 100 #queremos um numero ate 100, entao mod = 100
	addi a3, zero, 223 #numero primo mto grande qualquer
	addi a4, zero, 607 #outro numero primo mto grande qualquer
	
	addi a7, zero, 41 #gerando a seed com a syscall de RandInt--
	ecall
	add a5, zero, a0 #--
	
	mul t1, a5, a3	# conta_aux = seed * a
	add t1, t1, a4	# conta_aux = conta_aux + c
	rem a1, t1, a2	# resultado = conta_aux % 100

	jr ra
