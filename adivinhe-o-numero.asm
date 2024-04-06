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
espaco:	   .asciz " "	
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
	
	li s3, 0 # inicia o contador como 0
	jal criar_lista
	
	mv s2, a1 # guarda o sentinela em s2
	
	mv a1, s2 #passa o sentinela como parâmetro 
	mv a2, s1 # passa o numero que tem que ser inserido como parâmentro
	jal inserir_no
loop_chute:
	beq s1, s0, sai_chute
	
	bge s1, s0, chute_alto
	
	addi a7, zero, 4 #printando msg de número muito baixo
	la a0, mtBaixo
	ecall
	
	addi a7, zero, 5 #solicitando entrada de inteiro (chute de numero)
	ecall		
	
	add s1, zero, a0 #armazenando o chute em s1
	
	mv a1, s2 #passa o sentinela como parâmetro 
	mv a2, s1 # passa o numero que tem que ser inserido como parâmentro
	jal inserir_no
	
	j loop_chute
	
chute_alto:
	addi a7, zero, 4 #printando msg de número muito alto
	la a0, mtAlto
	ecall
	
	addi a7, zero, 5 #solicitando entrada de inteiro (chute de numero)
	ecall		
	
	add s1, zero, a0 #armazenando o chute em s1
	
	mv a1, s2 #passa o sentinela como parâmetro 
	mv a2, s1 # passa o numero que tem que ser inserido como parâmentro
	jal inserir_no
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
	
	li a7, 4	#pula linha
	la a0, pulaLinha
	ecall
	
	lw a1, 0(s2)
	jal imprimir_lista #imprime a lista
	
	li a7, 4	#pula linha
	la a0, pulaLinha
	ecall
	
	li a7, 1
	add a0, zero, s3
	ecall	
	
	
	
	
	
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
inserir_no:
	# a1 -> endereço do sentinela
	# a2 -> valor do numero que eu tenho que inserir
	# t0 -> variável auxiliar para armazenar o antigo começo da lista
	# t1 -> variável pra armazenar o endereço da parte de ponteiro do nó
	# nessa lista encadeada a gente insere no fim (FIFO) 
	li a7, 9
	li a0, 8 # aloca o no, os primeiro 4 bytes pro numero e os úlmtios 4 pra apontar pro prox nó 
	ecall
	
	sw a2, 0(a0) # copia o numero do usuário pros primeiro 4 bytes do nó
        
        lw t0, 0(a1) # armazena o antigo começo da lista em t0
        addi t1, a0, 4 # armazazena a parte de ponteiro do nó no t1
        sw t0, 0(t1) # faz o nó apontar para o antigo começo da lista
                 # armazena o antigo começo da lista nos útimos 4 bytes do nó 
                 
                 
        sw a0, 0(a1) # faz o sentinela apontar pro novo no
        addi s3, s3, 1 # incrementa o contador 
        j return
        
criar_lista: 
	# a1 -> armazena 
	li a7, 9
	li a0, 4 #aloca o sentinela, que é um ponteiro 
	ecall
	
	
	mv a1,a0  #bota o endereço do sentinela no registrador a1
	
	li t0, 0
	sw t0, 0(a1) # faz o sentinla apontar pra NULL
        
        j return
imprimir_lista: 
        # a1 -> recebe o nó atual	
	beq a1, x0,  return # volta pra main 
	
	 # printa o numero 
	lw a0, 0(a1)
	li a7, 1
	ecall
	
	# da um espaço
	la a0,espaco
	li a7, 4
	ecall
	
	lw a1, 4(a1) # bota o próximo nó para ser processado
	
	j imprimir_lista
	
	

		
         
return:
	jr ra # volta pra o lugar que a função foi chamada
	
#LISTA DE REGISTRADORES E VARIAVEIS QUE ELES REPRESENTAM

# s0 = randNumber -> NRO ALEATORIO GERADO
# s1 = chute -> CHUTE FEILO PELO USUARIO
# s2 = sentinela da lista encadeada
# s3 = contador de nós inseridos 
# -- funcao randNum --
# a2 = mod -> MODULO IGUAL A 100
# a3 = a -> NRO PRIMO QUALQUER
# a4 = c -> NRO PRIMO QUALQUER
# a5 = seed -> NRO INTEIRO QUALQUER
# t0 = aux_comp -> AUXILIAR DA COMPARAÇÃO
# t1 = conta_aux -> AUXILIAR PARA REALIZAÇÃO DAS CONTAS
# a1 = resultado -> RESULTADO DE NRO ALEATORIO FINAL

