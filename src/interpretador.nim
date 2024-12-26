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

proc getComandoRepl*(entrada: string): seq[string] =
    var tokens = tokenizer(entrada)
    if concat(instructions, comandos).find(tokens[0]) != -1 :
        return tokens

proc getComandoScript(entrada: string): seq[string] =
    var tokens = tokenizer(entrada)
    if instructions.find(tokens[0]) != -1 :
        return tokens

func linhaVazia(linha: string): bool =
    return linha.strip().len() == 0 

func filtraEspaço(entrada: string): bool =
    return entrada != ""

func limpaScript(script: seq[string]): seq[string] =
    var limpo = newSeqOfCap[string](script.len() - int(float(script.len()) * 0.2))
    for linha in script :
        if not linhaVazia(linha) :
            let semEspacoComecoFim = linha.strip()
            let semComentario = semEspacoComecoFim.split(";")[0]
            let semEspaco = semComentario.split(" ").filter(filtraEspaço)
            limpo.add(semEspaco.join(" "))
    return limpo

proc execScript*(proce: Processador, file: string) =
    var x = readFile("./scripts/" & file)
    var linhas = x.split("\n")
    let scriptLimpo = limpaScript(linhas)
    for linha in scriptLImpo :
        echo linha
        let tokens = getComandoScript(linha)
        if tokens[0] != " " :
            let instrucao = tokens[0]
            let args = tokens[1..tokens.len - 1]
            proce.exce(instrucao, args)
    
    

