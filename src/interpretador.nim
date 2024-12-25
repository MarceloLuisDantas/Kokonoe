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

import std/strutils

let instructions = [
    "add", "addi", "sub", "subi", "move", "li", "ssc", "syscall", "showmem"
]

func tokenizer(entrada: string): seq[string] =
    return entrada.split(" ")

proc getComando*(entrada: string): seq[string] =
    let tokens = tokenizer(entrada)
    if instructions.find(tokens[0]) != -1 :
        return tokens
