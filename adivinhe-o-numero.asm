
#TRABALHO 1 - ORGANIZAÇÃO E ARQUITETURA DE COMPUTADORES.

#Obejetivo: implementar um jogo em que o programa gera um numero aleatório e o usário deve adivinhar, por meio de tentativas, o número em questão.	
			
#LISTA DE REGISTRADORES E VARIAVEIS QUE ELES REPRESENTAM:
# s0 = randNumber -> NRO ALEATORIO GERADO;
# s1 = chute -> CHUTE FEILO PELO USUARIO;
# -- lista encadeada --
# s2 = SENTINELA DA LISTA ENCADEADA;
# s3 = CONTADOR DO NÓS INSERIDOS;
# -- funcao randNum --
# a2 = mod -> MODULO IGUAL A 100;
# a3 = a -> NUMERO PRIMO QUALQUER;
# a4 = c -> NUMERO PRIMO QUALQUER;
# a5 = seed -> NUMERO INTEIRO QUALQUER;
# t0 = aux_comp -> AUXILIAR DA COMPARAÇÃO;
# t1 = conta_aux -> AUXILIAR PARA REALIZAÇÃO DAS CONTAS;
# a1 = resultado -> RESULTADO DE NUMERO ALEATORIO FINAL;
# -- função para lista encadeada --
# a1 -> ENDEREÇO DO SENTINELA ;
# a2 -> VALOR DO NUMERO QUE SERÁ INSERIDO;
# t0 -> VARIÁVEL AUXILIAR PARA ARMAZENAR O ANTIGO COMEÇO DA LISTA;
# t1 -> VARIÁVEL PARA ARMAZENAR O ENDEREÇO DA PARTE DO PONTEIRO PARA O NÓ;
	
	.data
	.align 0
	
	#string usadas na interface com o usário;
initMsg:.asciz "Bem-vindo! Este é o jogo 'Adivinhe o número'!\nO computador escolheu um número entre 1 e 100, você consegue adivinhar qual é? Faça seu chute!\n"
chuteMsg: .asciz "Chute: " 
randMsg: .asciz "\nNúmero aleatório: " 
mtAlto:	.asciz "Seu chute foi mais alto que o numero correto, tente novamente!\n"
mtBaixo: .asciz "Seu chute foi mais baixo que o numero correto, tente novamente!\n"
finalMsg: .asciz "\nFim! Obrigada por jogar! :D\n" 
pulaLinha: .asciz "\n"
espaco:	   .asciz " "	
msg_parabens: .asciz "\n\nParabéns você acertou!\n"
msg_lista: .asciz "Seus chutes: "
msg_qtd_tentativas: .asciz "Quantidade de tentativas: "
	.align 2	
	.text
	.align 2
	.globl main
	
main:
	#printando msg de boas vindas e instruções;
	addi a7, zero, 4 
	la a0, initMsg
	ecall			
	
	jal randNum
	add s0, zero, a1 #s0 recebe o numero aleatorio entre 0 e 100;
	
	#solicitando entrada de inteiro (chute);
	addi a7, zero, 5 
	ecall		
	
	add s1, zero, a0 #armazenando o chute em s1;
	
	# Para mostrar o numero total de tentativas será usado um contador e ele será inicalizado com zero;
	li s3, 0 
	jal criar_lista
	
	mv s2, a1 # guarda o sentinela em s2;
	mv a1, s2 #passa o sentinela como parâmetro; 
	mv a2, s1 # passa o numero que tem que ser inserido como parâmentro;
	
	jal inserir_no
loop_chute:

	beq s1, s0, sai_chute #condição de saida do loop_chute;
	
	bge s1, s0, chute_alto  #pula para a condução chute_alto se s1>=s0;
	
	#printando msg de número muito baixo;
	addi a7, zero, 4 
	la a0, mtBaixo
	ecall
	
	#solicitando entrada do usuário;
	addi a7, zero, 5 
	ecall		
	
	add s1, zero, a0 #armazenando o chute em s1;
	
	mv a1, s2 #passa o sentinela como parâmetro ;
	mv a2, s1 # passa o numero que tem que ser inserido como parâmentro;
	
	jal inserir_no
	
	j loop_chute
	
chute_alto:

	#imprimi a mensagem de número muito alto;
	addi a7, zero, 4 
	la a0, mtAlto
	ecall
	
	#solicitando entrada do usuário;
	addi a7, zero, 5 
	ecall		
	
	add s1, zero, a0 #armazenando o chute em s1;
	
	mv a1, s2 #passa o sentinela como parâmetro; 
	mv a2, s1 # passa o numero que tem que ser inserido como parâmentro;
	
	jal inserir_no
	
	j loop_chute
	
sai_chute:

	#imprimi a tentativa correta do usário no final;
	addi a7, zero, 4 
	la a0, chuteMsg
	ecall
	
	addi a7, zero, 1
	add a0, zero, s1
	ecall		#--
	
	#parabeniza por ter acertado
	li a7,4
	la a0,msg_parabens
	ecall
	
	#imprimi o numero aleatorio que foi gerado;
	li a7, 4
	la a0, randMsg
	ecall
	
	li a7, 1
	add a0, zero, s0
	ecall		#--
	
	#pula uma linha para questões de organização;
	li a7, 4	
	la a0, pulaLinha
	ecall
	
	#imprime a lista
	li a7,4
	la a0,msg_lista
	ecall
	
	
	lw a1, 0(s2)
	jal imprimir_lista #--
	
	#pula uma linha para questões de organização;
	li a7, 4
	la a0, pulaLinha
	ecall
	
	#imprime a quantidade de tentativas
	li a7, 4
	la a0, msg_qtd_tentativas
	ecall
	
	li a7, 1
	add a0, zero, s3
	ecall	
	
	#imprimindo mensagem final;
	addi a7, zero, 4 
	la a0, finalMsg
	ecall
	
	#finalizando programa;
	addi a7, zero, 10 
	ecall

randNum:		
	#função que gera o numero pseudoaleatorio;
	#Representação das variáveis do pseudocódigo em linguagens de alto nivel, seu registrador correspondente e o valor que possui:
	# - mod -> a2 = 100; 
	# - a -> a3 = 223; 
	# - c -> a4 = 607; 
	# - seed -> a5 = ecall;
	# - aux_comp -> t0;  (auxiliar de comparação)
	# - conta_aux -> t1;  (contador auxiliar)
	# - resultado -> a1;
	
	addi a2, zero, 100 #queremos um numero ate 100, entao mod = 100;
	addi a3, zero, 23 #numero primo muito grande e qualquer;
	addi a4, zero, 17 #outro numero primo muito grande e qualquer;
	
	#gerando a seed com a syscall de RandInt (presente do rars);
	addi a7, zero, 41 
	ecall
	add a5, zero, a0 
	
	addi t0, zero, 1 #aux_comp = 1;
	
	blt a5, t0, randNum #se o número gerado for menor que 1, repete a funçao desde o começo;
	
	#manipulação dos registradores:
	rem a5, a5, a2	# seed = seed % 100
	mul t1, a5, a3	# conta_aux = seed * a
	add t1, t1, a4	# conta_aux = conta_aux + c
	rem a1, t1, a2	# resultado = conta_aux % 100
	
	jr ra
	
inserir_no:

	# nesta implementação a incersão é feita no final (FIFO) ;
	# aloca o nó, os primeiro 4 bytes para 0 numero e os 4 últimos pra apontar para o proximo nó;
	li a7, 9
	li a0, 8  
	ecall
	
	sw a2, 0(a0) # copia o numero do usuário para os primeiro 4 bytes do nó;
        
        lw t0, 0(a1) # armazena o antigo começo da lista em t0;
        
        addi t1, a0, 4 # armazena a parte de ponteiro do nó no t1;
        
        sw t0, 0(t1) # faz o nó apontar para o antigo começo da lista;
        
        sw a0, 0(a1) # faz o sentinela apontar pro novo no;
        
        addi s3, s3, 1 # incrementa o contador ;
        
        j return
        
criar_lista: 
	 
	#alocação de memória para o sentilena;
	li a7, 9
	li a0, 4 
	ecall
	
	mv a1,a0  #move o endereço do sentinela para o registrador a1;
	
	li t0, 0
	
	sw t0, 0(a1) #faz o sentinla apontar para NULL;
        
        j return
        
imprimir_lista: 

	beq a1, zero,  return  #retorna para onde foi chamada
	
	#imprimi a tentativa do usário;
	lw a0, 0(a1)
	li a7, 1
	ecall
	
	#imprimi um espaço entre as tentativas;
	la a0,espaco
	li a7, 4
	ecall
	
	lw a1, 4(a1) #pula para o proximo nó;	
	j imprimir_lista
	        
return:
	#apenas uma função de modularização;
	jr ra
