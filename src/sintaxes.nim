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
        return args[0] & " não é um valor valido"

proc sintaxeSyscall*(args: seq[string]): string =
    if args.len() != 0 :
        return "Syscall não recebe nem um parametro"
    return "ok"

proc jumpNameValido(nome: string): string =
    let simbulosValidos = "qwertyuiopasdfghjklzxcvbnm123456789_"
    for i in toLowerAscii(nome) :
        if simbulosValidos.find(i) == -1 :
            return $i & " não é um caracter valido"
    return "ok"

proc sintaxeJumpPoint*(linha: seq[string]): string =  
    let nome = linha[0]
    if nome.len() < 1 :
        return "Jump Points precisam de um nome"

    let err = jumpNameValido(nome)
    if err != "" :
        return err

    return "ok"

proc apenasLetras(x: string): bool =
    let letras = "qwertyuiopasdfghjklzxcvbnm"
    for i in x :
        if letras.find(i) == -1 :
            return false
    return true

proc sintaxeJump*(linha: seq[string]): string =
    if linha.len() != 1 :
        return "jump so recebe 1 parametro, o ponto de jump"
    
    let err = jumpNameValido(linha[0])
    if err != "" :
        return err

    return "ok"

proc sintaxeJal*(linha: seq[string]): string =
    if linha.len() != 1 :
        return "jal so recebe 1 parametro, o ponto de jump"
    
    let err = jumpNameValido(linha[0])
    if err != "" :
        return err

    return "ok"

proc sintaxeJr*(linha: seq[string]): string =
    if linha.len() != 0 :
        return "jr não recebe parametros"
    return "ok"

# "beq", "bne", "bgt", "bge", "blt", "ble",  
proc sintaxeBranch*(args: seq[string]): string =
    if (args.len() != 3) :
        return "Branchs recebem 3 parametros, 2 registradores e 1 inteiro"
    if not registradoresValidos(args[0..1]) :
        return "1 ou mais registradores invalidos"
    let err = jumpNameValido(args[2])
    if err != "" :
        return err
    return "ok"

proc sintaxeSlt*(args: seq[string]): string =
    if (args.len() != 3) :
        return "slt recebe 3 parametros, 3 registradores"
    if not registradoresValidos(args) :
        return "1 ou mais registradores invalidos"
    return "ok"

proc sintaxeSlti*(args: seq[string]): string =
    if (args.len() != 3) :
        return "slti recebe 3 parametros, 2 registradores e 1 valor para comparação"
    if not registradoresValidos(args[0..1]) :
        return "1 ou mais registradores invalidos"

    try :
        discard parseInt(args[2])
        return "ok"
    except :
        return args[2] & " não é um valor valido"