# Kokonoe
Kokonoe é um interpretador simples, baseado em Assembly de MIPS, tudo funciona em cima de um "processador" simulado.

## Basico do Basico
Os scripts executaveis possuem a extenção .kn, eles não possuem identação obrigatoria, porem cada comando precisa ser escrito em 1 linha e 1 linha apenas. Os comentarios são possiveis, tudo que estiver depois de um ; sera considerado um comentario.

Existem 2 modos de uso, é possivel tanto abrir Kokonoe no modo interativo, onde você tera um prompt simples para executar comandos, e como modo interpretador, onde você pode passar um script .kn para ser executado.

## Comandos
Kokonoe suporta alguns comandos comuns de shell, dentre eles;
- ls  : lista os scripts existentes na pasta interna script
- cat : lista o conteudo de um script especifico
- run : permite executar scripts mesmo estando no modo interativo
- vi  : abre o vi para que você possa editar os scripts

## Registradores
`cada registrador é implementado como um inteiro de 64 bits`
| Registrador | Nome        | Editavel | Descrição  
| :---------- | :---------- | :------- | :-------- 
| #r0         | $ZERO       | NÂO      | ZERO
| #r1 .. r4   | $a1 .. $a4  | SIM      | Argumentos para procedimentos 
| #r5 e r6    | $v1 e $v2   | SIM      | Retornos de procedimentos
| #r7 .. r17  | $t1 .. $t10 | SIM      | Valores temporarios
| #r18 .. r30 |             | SIM      | em trabalho, podem ser utilizados por hora
| #r30        | $ra         | NÂO      | Reservado para armazenar o ponto de retorno
| #r31        | $sv         | SIM      | Reservado para setar chamada de syscall

PS: Todos os registradores são editaveis (exceto o ZERO que é hardcoded), mas não é recomendado utilizar os marcados como não editaveis

### #r0 ou $ZERO
Valor ZERO constante, qualquer valor adicionado a ele sera ignorando, e sempre que for chamado sera recebido 0. Pode ser utilizado quando o resultado de uma operação não é necessario, porem ela necessita um lugar para salvar o resultado, jogando o resultado para ZERO a operação sera possivel 

### #r1..#r4 ou $a1..$a4 (Argumentos)
Registradores reservados para serem utilizados para armazenar os argumentos de um procedimento. Esses registradores não são zerados automaticamente.

### #r5 e #r6 ou $v1 e $v2 (Valores)
Registradores reservados para serem utilizados para armazenar os retornos de um procedimento. Esses registradores não são zerados automaticamente.

### #r7..#r17 ou $t1..t10 (Temporario)
Registradores reservados para uso temporario, as variaveis do seu programa.

### #30 ou $ra (Returna Adress)
Registrador que armazena o ponto de pulo ao utilizar jal, utilizado pelo jr para saber para qual ponto retornar apos o fim de um procedimento

### #r31 ou $sv (Syscall Value)
Registrador reservado para uso interno

## Instruções
| Instrução | argumento 1    | argumento 2 | argumento 3 |
| :-------- | :------------: | :---------: | :---------: |
| add       | registrador    | registrador | registrador |
| addi      | registrador    | registrador | valor       |
| sub       | registrador    | registrador | registrador |
| subi      | registrador    | registrador | valor       |
| move      | registrador    | registrador
| li        | registrador    | valor
| jump      | ponto de jump
| jal       | ponto de jump
| jr        |
| ssc       | valor       
| syscall   

- `add #reg1 #reg2 #reg3` - Aloca em reg1 a soma dos valores de reg2 e reg3
- `addi #reg1 #reg2 valor` - Aloca em reg1 a soma do valore em reg 2 e o valor passado
- `sub #reg1 #reg2 #reg3` - Aloca em reg1 a subtração entre os valores de reg2 e reg3
- `subi #reg1 #reg2 valor` - Aloca em reg1 a subtração do valore em reg 2 com o valor passado
- `move #reg1 #reg2` - Move o valor de reg2 para reg1, é apenas um aptalho para `add #reg1 $ZERO #reg2`
- `li #reg1 valor` - Aloca em reg1 o valor passado, é apenas um atalho para `addi #reg1 $ZERO valor`
- `jump ponto_de_jump` - Move a execução do codigo para outra linha (um goto)
- `jal ponto_de_jump` - Move a execução do codigo para outra linha, e salva a linha original no registrador $ra
- `jr` - Retorna para o ponto armazenado em $ra
- `ssc valor` - seta o registrador responsavel por chamar syscalls
- `syscall` - Realiza a chamada de uma Syscall utilizando

## Syscalls
### ssc 1 - printInteiro
Imprime na tela o valor armazenado no registrador $a1


# TO DO
Implementação de condicionais
Implementação de uma memoria fora os registradores
Implementação de mais syscalls
Implementação de uso de strings
