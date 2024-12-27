from processador import registradorValido
import strutils
import sequtils


# Detecção de registradores validos
proc registradoresValidos*(regis: seq[string]): bool =
    let validos = regis.filter(proc(a: string): bool = registradorValido(a))
    return validos.len() == regis.len()
    
# Detecta erro de sintaxe em add e sub
proc sintaxeAddSub*(argumentos: seq[string]): string =
    if argumentos.len() != 3 :
        return "Add e Sub recebem exatamente 3 argumentos"
    if not registradoresValidos(argumentos) :
        return "1 ou mais registradores invalidos"
    return "ok"

# Detecta erro de sintaxe em addi e subi
proc sintaxeAddiSubi*(argumentos: seq[string]): string =
    if argumentos.len() != 3 :
        return "Add e Sub recebem exatamente 3 argumentos, 2 registradores e 1 numero"
    if not registradoresValidos(argumentos[0..1]) :
        return "1 ou mais registradores invalidos"
    return "ok"

# Detecta erro de sintaxe em move
proc sintaxeMove*(argumentos: seq[string]): string =
    if argumentos.len() != 2 :
        return "Move recebe exatamente 3 argumentos"
    if not registradoresValidos(argumentos) :
        return "1 ou mais registradores invalidos"
    return "ok"

# Detecta erro de sintaxe em li
proc sintaxeLi*(args: seq[string]): string =
    if args.len() != 2 :
        return "Move recebe exatamente 2 argumentos"

    if not registradorValido(args[0]) :
        return "Registrador de destino invalido"
        
    try :
        discard parseInt(args[1])
        return "ok"
    except :
        return "Valor passado invalido"

# Detecta erro de sintaxe em ssc
proc sintaxeSsc*(args: seq[string]): string = 
    if args.len() != 1 :
        return "Ssc recebe exatamente 1 argumento"

    try :
        discard parseInt(args[0])
        return "ok"
    except :
        return args[0] & " não é um valor passado invalido"

proc sintaxeSyscall*(args: seq[string]): string =
    if args.len() != 0 :
        return "Syscall não recebe nem um parametro"
    return "ok"

proc apenasLetras(linha: string): bool =
    let letras = @[
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 
        'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 
        'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    ]

    for i in toUpperAscii(linha) :
        if letras.find(i) == -1 :
            return false
    return true

proc sintaxeJumpPoint*(linha: seq[string]): string =  
    let nome = linha[0]
    if nome.len() < 1 :
        return "Jump Points precisam de um nome"

    if not apenasLetras(nome) :
        return "Jump Points podem possuir apenas letras"

    return "ok"

proc sintaxeJump*(linha: seq[string]): string =
    if linha.len() != 1 :
        return "jump so recebe 1 parametro, o ponto de jump"
    
    if not apenasLetras(linha[0]) :
        return "pontos de jump so podem possuir letras"

    return "ok"


    