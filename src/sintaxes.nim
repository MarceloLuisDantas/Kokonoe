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
        discard parseInt(args[1])
        return "ok"
    except :
        return "Valor passado invalido"

proc sintaxeSyscall*(args: seq[string]): string =
    if args.len() != 0 :
        return "Syscall não recebe nem um parametro"