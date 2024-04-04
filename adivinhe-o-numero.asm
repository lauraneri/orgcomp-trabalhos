	.data
	.align 0	#alinhando para string
initMsg:.asciz "Bem-vindo! Este é o jogo 'Adivinhe o número'!\nO computador escolheu um número entre 1 e 100, você consegue adivinhar qual é? Faça seu chute!\n"
			#mensagens de boas-vindas e instruções
chuteMsg: .asciz "Chute: " #diz qual foi o chute do usuário
randMsg: .asciz "\nNúmero aleatório: " #diz qual foi o nro aleatorio gerado
mtAlto:	.asciz "Seu chute foi mais alto que o nro correto, tente novamente!\n"
mtBaixo: .asciz "Seu chute foi mais baixo que o nro correto, tente novamente!\n"
finalMsg: .asciz "\nFim! Obrigada por jogar! :D\n" #finalização
pulaLinha: .asciz "\n"
	
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
	
	li a7, 4	#printando o nro aleatorio que foi gerado --
	la a0, randMsg
	ecall
	
	addi a7, zero, 1
	add a0, zero, s0
	ecall		#--
	
	li a7, 4	#pula linha
	la a0, pulaLinha
	ecall
	
	addi a7, zero, 5 #solicitando entrada de inteiro (chute de numero)
	ecall		
	
	add s1, zero, a0 #armazenando o chute em s1
	
loop_chute:
	beq s1, s0, sai_chute
	
	bge s1, s0, chute_alto
	
	addi a7, zero, 4 #printando msg de número muito baixo
	la a0, mtBaixo
	ecall
	
	addi a7, zero, 5 #solicitando entrada de inteiro (chute de numero)
	ecall		
	
	add s1, zero, a0 #armazenando o chute em s1
	
	j loop_chute
	
chute_alto:
	addi a7, zero, 4 #printando msg de número muito alto
	la a0, mtAlto
	ecall
	
	addi a7, zero, 5 #solicitando entrada de inteiro (chute de numero)
	ecall		
	
	add s1, zero, a0 #armazenando o chute em s1
	
	j loop_chute
	
sai_chute:
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
			#mod -> a2 = 100; a -> a3 = 223; c -> a4 = 607; seed -> a5 = ecall;
			#aux_comp -> t0; conta_aux -> t1; resultado -> a1
	addi a2, zero, 100 #queremos um numero ate 100, entao mod = 100
	addi a3, zero, 23 #numero primo mto grande qualquer
	addi a4, zero, 17 #outro numero primo mto grande qualquer
	
	addi a7, zero, 41 #gerando a seed com a syscall de RandInt--
	ecall
	add a5, zero, a0 #--
	
	addi t0, zero, 1 #aux_comp (auxiliar de comparação) = 1
	
	blt a5, t0, randNum #se o nro gerado for menor que 1, repete a funçao do começo
	
	rem a5, a5, a2	# seed = seed % 100
	mul t1, a5, a3	# conta_aux = seed * a
	add t1, t1, a4	# conta_aux = conta_aux + c
	rem a1, t1, a2	# resultado = conta_aux % 100
	


	jr ra
	
#LISTA DE REGISTRADORES E VARIAVEIS QUE ELES REPRESENTAM

# s0 = randNumber -> NRO ALEATORIO GERADO
# s1 = chute -> CHUTE FEILO PELO USUARIO

# -- funcao randNum --
# a2 = mod -> MODULO IGUAL A 100
# a3 = a -> NRO PRIMO QUALQUER
# a4 = c -> NRO PRIMO QUALQUER
# a5 = seed -> NRO INTEIRO QUALQUER
# t0 = aux_comp -> AUXILIAR DA COMPARAÇÃO
# t1 = conta_aux -> AUXILIAR PARA REALIZAÇÃO DAS CONTAS
# a1 = resultado -> RESULTADO DE NRO ALEATORIO FINAL
