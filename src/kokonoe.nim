import std/os
import processador
from interpretador import getComando

var proce = newProcessador()

proc input() : string =
    stdout.write("Kokonoe Prompt |> ")
    return stdin.readLine()

proc main() =
    proce.about()
    while true :
        let entrada = input()
        let tokens  = getComando(entrada)
        let instrucao = tokens[0]
        let args = tokens[1..tokens.len - 1]
        proce.exce(instrucao, args)
        
main()