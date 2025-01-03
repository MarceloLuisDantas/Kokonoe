import std/os
import strutils
import processador
import interpretador

var proce = newProcessador()

proc input() : string =
    stdout.write("\nKokonoe Prompt |> ")
    return stdin.readLine()

proc ls() =
    discard execShellCmd("ls ./scripts")

proc cat(arquivo: string) =
    discard execShellCmd("cat ./scripts/" & arquivo)

proc vi(arquivo: string) =
    discard execShellCmd("vi ./scripts/" & arquivo)

proc run(arquivo: string) =
    if arquivo.split(".")[1] != "kn" :
        echo "Formato de arquivo invalido"
    else :
        interpretador.execScript(proce, arquivo)

proc repl() =
    proce.about()
    while true :
        let entrada = input()
        let instrucao = getComandoRepl(entrada)
        let args = instrucao.args
        case instrucao.op
          of "exit" : break
          of "ls"   : ls()
          of "cat"  : cat(args[0])
          of "vi"   : vi(args[0])
          of "run"  : run(args[0])
          else :
            proce.exec(instrucao)

proc main() =
    let parametros = commandLineParams()
    if (parametros.len() == 0) :
        repl()
    else :
        if parametros[0].split(".")[1] != "kn" :
            echo "Formato de arquivo invalido"
        else :
            interpretador.execScript(proce, parametros[0])

main()