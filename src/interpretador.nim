# Instruções do processador
# | Instrução | argumento 1 | argumento 2 | argumento 3 |
# | :-------- | :---------- | :---------- | :---------- |
# | add       | registrador | registrador | registrador |
# | addi      | registrador | registrador | valor       |
# | sub       | registrador | registrador | registrador |
# | subi      | registrador | registrador | valor       |
# |
# | ssc       | valor       |
# | syscall   
# | showmem 
#
# add  $t1 $t2 $t3 - t1 = t2 + t3
# addi $t1 $t2 100 - t1 = t2 + 100
# sub  $t1 $t2 $t3 - t1 = t2 - t3
# subi $t1 $t2 100 - t1 = t2 - 100

import strutils
import sequtils
import processador

let instructions = @[
    "add", "addi", "sub", "subi", "move", "li", "ssc", "syscall", "showmem"
]

let comandos = @[
    "ls", "cat", "exit", "vi", "touch", "run"
]

func tokenizer(entrada: string): seq[string] =
    return entrada.split(" ")

proc getComando*(entrada: string): seq[string] =
    var tokens = tokenizer(entrada)
    proc filtraEspaco(x: string): bool = x != ""
    tokens.keepIf(filtraEspaco)
    if concat(instructions, comandos).find(tokens[0]) != -1 :
        return tokens

proc execScript*(proce: Processador, file: string) =
    var x = readFile("./scripts/" & file)
    for linha in x.split("\n") :
        let tokens  = getComando(linha)
        let instrucao = tokens[0]
        let args = tokens[1..tokens.len - 1]
        proce.exce(instrucao, args)
    
    

