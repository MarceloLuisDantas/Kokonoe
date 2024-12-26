import std/os
import processador
from interpretador import getComando

var proce = newProcessador()

proc input() : string =
    stdout.write("Kokonoe Prompt |> ")
    return stdin.readLine()

proc repl() =
    proce.about()
    while true :
        let entrada = input()
        let tokens  = getComando(entrada)
        
        let instrucao = tokens[0]
        if (instrucao == "exit") :
            break

        let args = tokens[1..tokens.len - 1]
        proce.exce(instrucao, args)

proc main() =
    let parametros = commandLineParams()
    if (parametros.len() == 0) :
        repl()
    else :
        interpretador.execScript(proce, parametros[0])

main()