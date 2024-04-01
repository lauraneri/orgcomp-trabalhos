	.data
	.align 0	#alinhando para string
initMsg:.asciz "Bem-vindo! Este é o jogo 'Adivinhe o número'!\nO computador escolheu um número entre 1 e 100, você consegue adivinhar qual é? Faça seu chute!"
			    #mensagens de boas-vindas e instruções
chuteMsg: .asciz "Chute: "
finalMsg: .asciz "\nFim! Obrigada por jogar! :D\n"
	
	.align 2	#alinhando para inteiro


	.text
	.align 2
	.globl main
	
main:
	addi a7, zero, 4 #printando msg de boas vindas e instruções
	la a0, initMsg
	ecall			
	
	addi a7, zero, 5 #solicitando entrada de inteiro (chute de numero)
	ecall		
	
	add s0, a0, zero #armazenando o chute
	
	addi a7, zero, 4 #printando o chute
	la a0, chuteMsg
	ecall
	
	addi a7, zero, 1
	add a0, zero, s0
	ecall			#--
	
	addi a7, zero, 4 #printando msg final
	la a0, finalMsg
	ecall
	
	
	addi a7, zero, 10 #finalizando programa
	ecall
