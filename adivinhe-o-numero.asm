	.data
	.align 0	#alinhando para string
initMsg:.asciz "Bem-vindo! Este é o jogo 'Adivinhe o número'!\n"
instMsg:.asciz "O computador escolheu um número entre 1 e 100, você consegue adivinhar qual é? Faça seu chute!\n"
			#mensagens de boas-vindas e instruções
	
	.align 2	#alinhando para inteiro
numero: .word
	
	.text
	.align 2
	.globl main
	
main:
	addi a7, zero, 4
	la a0, initMsg
	ecall		#printando msg de boas vindas
	
	addi a7, zero, 4
	la a0, instMsg
	ecall		#printando msg de instruções
	
	
	
	addi a7, zero, 10 #finalizando programa
	ecall