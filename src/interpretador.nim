# Instruções do processador
# | Instrução | argumento 1 | argumento 2 | argumento 3 |
# | :-------- | :---------- | :---------- | :---------- |
# | add       | registrador | registrador | registrador |
# | addi      | registrador | registrador | valor       |
# | sub       | registrador | registrador | registrador |
# | subi      | registrador | registrador | valor       |
# | move      | registrador | registrador
# |
# | jump      | valor
# | jal       | valor
# | jr        | registrador
# | jb        
# |
# | ssc       | valor       |
# | syscall   
# | showmem 
#
# add  $t1 $t2 $t3 - t1 = t2 + t3
# addi $t1 $t2 100 - t1 = t2 + 100
# sub  $t1 $t2 $t3 - t1 = t2 - t3
# subi $t1 $t2 100 - t1 = t2 - 100

import processador
import sintaxes
import strutils
import sequtils
import tables

let instructions = @[
    "add", "addi", "sub", "subi", "move", "li", 
    "jump", "jal", "jr", "jb",
    "ssc", "syscall", "showmem"
]

let comandos = @[
    "ls", "cat", "exit", "vi", "touch", "run"
]

# Etapa de pre-processamento do script

# verifica se a linha é vazia, se for ela sera ignorando pelo interpretador
func linhaVazia(linha: string): bool =
    return linha.strip().len() == 0 

func filtraEspaço(entrada: string): bool =
    return entrada != ""

proc isJumpPoint(linha: string): bool =
    return linha[0] == '_'

func tokenizer(entrada: string): Instrucao =
    let tokens = entrada.split(" ")
    if tokens.len() != 1 :
        return newInstrucao(tokens[0], tokens[1..^1])
    if isJumpPoint(tokens[0]) : 
        return newInstrucao("jumppoint", @[tokens[0][1..^1]])
    return newInstrucao(tokens[0], @[])

# Faz a limpeza do script, revomendo espaços extras e comentarios
proc limpaScript(script: seq[string]): seq[string] =
    var limpo = newSeqOfCap[string](script.len() - int(float(script.len()) * 0.2))
    for linha in script :
        if not linhaVazia(linha) :
            let semEspacoComecoFim = linha.strip()
            let semComentario = semEspacoComecoFim.split(";")[0]
            let semEspaco = semComentario.split(" ").filter(filtraEspaço)
            if semEspaco.len() > 0 :
                limpo.add(semEspaco.join(" "))
    return limpo

# Detecção de instruções não conhecidas
# Usada apenas ao executar scripts
proc detectaInstrucaoNaoExistente(script: seq[string]): seq[string] =
    for i, v in script :
        if not isJumpPoint(v) :
            let instrucao = v.split(" ")[0]
            if instructions.find(instrucao) == -1 :
                result.add("Erro na linha " & $(i+1) & " instrução \"" & instrucao & "\" não reconhecido")       

proc checkSintaxe(instrucao: string, args: seq[string]): string =
    case instrucao :
      of "add", "sub"   : return sintaxeAddSub(args)
      of "addi", "subi" : return sintaxeAddiSubi(args)
      of "move"         : return sintaxeMove(args)
      of "li"           : return sintaxeLi(args)
      of "ssc"          : return sintaxeSsc(args)
      of "syscall"      : return sintaxeSyscall(args)
      of "jumppoint"    : return sintaxeJumpPoint(args)
      of "jump"         : return sintaxeJump(args)
    #   of "jal"
    #   of "jb"
    #   of "jr"
      else : return "O dev esqueceu de implementar isso pelo visto"

# Detecta erros de sintaxe
proc detecaErrosSintaxe(script: seq[string]): seq[string] =
    for i, v in script :
        let ins = tokenizer(v)
        let err = checkSintaxe(ins.op, ins.args)
        if err != "ok" :
            result.add(
                "Erro de sintaxe na linha " & $(i+1) & " - \"" & v & "\" \n" & 
                "    - " & err & "\n"
            )

# Encontra e gera a tabela de pontos para os jumps
proc getJumpPoints(script: seq[string]): (string, TableRef[string, int]) =
    var points = newTable[string, int]()
    for i, v in script :
        if v[0] == '_' :
            if points.hasKey(v) :
                let msg = "Multiplos pontos com o nome " & v[1..^1] & "\n - linha " & $points[v] & "\n - linha " & $i
                return (msg, points)
            points[v[1..^1]] = i

    
    return ("ok", points)    


proc getComandoRepl*(entrada: string): Instrucao =
    var operacao = tokenizer(entrada)
    if concat(instructions, comandos).find(operacao.op) != -1 :
        return operacao

# Executa um script
proc execScript*(proce: Processador, file: string) =
    var x = readFile("./scripts/" & file)
    var linhas = x.split("\n")
    
    # Remove qualquer espaço em branco extra e os comentarios
    let scriptLimpo = limpaScript(linhas)

    # Verifica se existe alguma instrução invalida
    let erros = detectaInstrucaoNaoExistente(scriptLimpo)
    if erros.len() > 0 :
        for erro in erros :
            echo erro
        return

    # Verifica os erros de sintaxe de cada instrução
    let errosSintaxe = detecaErrosSintaxe(scriptLimpo)  
    if errosSintaxe.len() != 0 :
        for i in errosSintaxe :
            echo i
        return

    let (err, jumpPoints) = getJumpPoints(scriptLimpo)
    if err != "ok" :
        echo err
        return

    proce.jumpPoints = jumpPoints

    # Carrega o script na memoria
    for linha in scriptLimpo :
        let instrucao = tokenizer(linha)
        proce.addInstruction(instrucao)

    proce.execProgram()