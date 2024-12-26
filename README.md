# Kokonoe
Kokonoe é um simulador de um Processador simples, tendo um Assembly similar ao conjunto de instruções e registradores MIPS. 

## Registradores
`cada registrador é implementado como um inteiro de 64 bits`
| Registrador | Nome        | Editavel | Descrição  
| :---------- | :---------- | :------- | :-------- 
| #r0         | $ZERO       | NÂO      | ZERO
| #r1 .. r4   | $a1 .. $a4  | SIM      | Argumentos para procedimentos 
| #r5, r6     | $v1, $v2    | SIM      | Retornos de procedimentos
| #r7 .. r17  | $t1 .. $t10 | SIM      | Valores temporarios
| #r31        | $sv         | SIM      | Reservado para setar chamada de syscall


### #r0 ou $ZERO
Valor ZERO constante, qualquer valor adicionado a ele sera ignorando, e sempre que for chamado sera recebido 0. Pode ser utilizado quando o resultado de uma operação não é necessario, porem ela necessita um lugar para salvar o resultado, jogando o resultado para ZERO a operação sera possivel 

### #r1..#r4 ou $a1..$a4 (Argumentos)
Registradores reservados para serem utilizados para armazenar os argumentos de um procedimento. Esses registradores não são zerados automaticamente.

### #r5 e #r6 ou $v1 e $v2 (Valores)
Registradores reservados para serem utilizados para armazenar os retornos de um procedimento. Esses registradores não são zerados automaticamente.

### #r7..#r17 ou $t1..t10 (Temporario)
Registradores reservados para uso temporario, as variaveis do seu programa.

### #r31 ou $sv (Syscall Value)
Registrador reservado para uso interno

## Instruções
| Instrução | argumento 1 | argumento 2 | argumento 3 |
| :-------- | :---------- | :---------- | :---------- |
| add       | registrador | registrador | registrador |
| addi      | registrador | registrador | valor       |
| sub       | registrador | registrador | registrador |
| subi      | registrador | registrador | valor       |
| move      | registrador | registrador
| li        | registrador | valor
| ssc       | valor       
| syscall   

- `add #reg1 #reg2 #reg3` - Aloca em reg1 a soma dos valores de reg2 e reg3
- `addi #reg1 #reg2 valor` - Aloca em reg1 a soma do valore em reg 2 e o valor passado
- `sub #reg1 #reg2 #reg3` - Aloca em reg1 a subtração entre os valores de reg2 e reg3
- `subi #reg1 #reg2 valor` - Aloca em reg1 a subtração do valore em reg 2 com o valor passado
- `move #reg1 #reg2` - Move o valor de reg2 para reg1, é apenas um aptalho para `add #reg1 $ZERO #reg2`
- `li #reg1 valor` - Aloca em reg1 o valor passado, é apenas um atalho para `addi #reg1 $ZERO valor`
- `ssc valor` - seta o registrador responsavel por chamar syscalls
- `syscall` - Realiza a chamada de uma Syscall utilizando

## Syscalls
### ssc 1 - printInteiro
Imprime na tela o valor armazenado no registrador $a1


# TO DO
Converter a exceução de scripts e de um for indo linha por linha, para cada comando ser um objeto dentro de uma linha de comandos
