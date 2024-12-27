from strutils import parseInt

type Instrucao* = tuple
    op: string
    args: seq[string]

func newInstrucao*(ins: string, args: seq[string]): Instrucao =
    return (ins, args)

type Processador* = ref object
    # | Registrador | Nome        | Editavel | Descrição  
    # | :---------- | :---------- | :------- | :-------- 
    # | #r0         | $ZERO       | NÂO      | ZERO
    # | #r1 .. r4   | $a1 .. $a4  | SIM      | Argumentos para procedimentos 
    # | #r5, r6     | $v1, $v2    | SIM      | Retornos de procedimentos
    # | #r7 .. r16  | $t1 .. $t10 | SIM      | Valores temporarios
    # | #r31        | $sv         | SIM      | Seta qual syscalls
    registradores: array[32, int]
    programStack: seq[Instrucao]

func newProcessador*(): Processador =
    Processador()

# Converte o nome do registrador para o indice no array
func regToIndex(registrador: string) : int =
    case registrador
      of "#r0",  "$ZERO" : return 0
      of "#r1",  "$a1"   : return 1
      of "#r2",  "$a2"   : return 2
      of "#r3",  "$a3"   : return 3
      of "#r4",  "$a4"   : return 4
      of "#r5",  "$v1"   : return 5
      of "#r6",  "$v2"   : return 6
      of "#r7",  "$t1"   : return 7
      of "#r8",  "$t2"   : return 8
      of "#r9",  "$t3"   : return 9
      of "#r10", "$t4"   : return 10
      of "#r11", "$t5"   : return 11
      of "#r12", "$t6"   : return 12
      of "#r13", "$t7"   : return 13
      of "#r14", "$t8"   : return 14
      of "#r15", "$t9"   : return 15
      of "#r16", "$t10"  : return 16
      of "#r31", "$sv"   : return 31
      else : return -1

func registradorValido*(registrador: string): bool =
    return regToIndex(registrador) != -1

proc addInstruction*(self: Processador, ins: Instrucao) =
    self.programStack.add(ins)

func getR(self: Processador, r: int): int = 
    if r == 0 :
        return 0
    return self.registradores[r]

proc setR(self: Processador, r: int, v: int) =
    if (r != 0) :
        self.registradores[r] = v





# Instruções do processador
# | Instrução | argumento 1 | argumento 2 | argumento 3 |
# | :-------- | :---------- | :---------- | :---------- |
# | add       | registrador | registrador | registrador |
# | addi      | registrador | registrador | valor       |
# | sub       | registrador | registrador | registrador |
# | subi      | registrador | registrador | valor       |
# | move      | registrador | registrador
# |
# | ssc       | valor       |
# | syscall   
# | showmem 

proc add(self: Processador, r1: string, r2: string, r3: string) =
    var i1: int = regToIndex(r1)
    var i2: int = regToIndex(r2)
    var i3: int = regToIndex(r3)
    self.setR(i1, self.getR(i2) + self.getR(i3))

proc addi(self: Processador, r1: string, r2: string, v: string) =
    var i1: int = regToIndex(r1)
    var i2: int = regToIndex(r2)
    self.setR(i1, self.getR(i2) + v.parseInt())    
    
proc sub(self: Processador, r1: string, r2: string, r3: string) =
    var i1: int = regToIndex(r1)
    var i2: int = regToIndex(r2)
    var i3: int = regToIndex(r3)
    self.setR(i1, self.getR(i2) - self.getR(i3))

proc subi(self: Processador, r1: string, r2: string, v: string) =
    var i1: int = regToIndex(r1)
    var i2: int = regToIndex(r2)
    self.setR(i1, self.getR(i2) - v.parseInt())    

# Seta qual syscall sera chamada
proc ssc(self: Processador, v: int) =
    self.setR(regToIndex("$sv"), v)

# Syscalls
proc printInteiro(self: Processador) =
    echo self.getR(regToIndex("$a1"))

# Mostra todos os valores da memoria
proc showMem(self: Processador) =
    let regisNumber = [
        ("r0", "ZERO"), 
        ("r1", "a1"), ("r2", "a2"), ("r3", "a3"), ("r4", "a4"), 
        ("r5", "v1"), ("r6", "v2"), 
        ("r7", "t1"), ("r8", "t2"), ("r9", "t3"), ("r10", "t4"), ("r11", "t5"), ("r12", "t6"), ("r13", "t7"), ("r14", "t8"), ("r15", "t9"), ("r16", "t10"), 
        ("r17", ""),  ("r18", ""),  ("r19", ""),  ("r20", ""),  ("r21", ""),  ("r22", ""),  ("r23", ""),  ("r24", ""),  ("r25", ""),  ("r26", ""),  ("r27", ""),  ("r28", ""),  ("r29", ""),  ("r30", ""),  
        ("r31", "sv")  
    ]
    
    for i, j in self.registradores :
        let num = regisNumber[i][0]
        let name = regisNumber[i][1]
        echo num, " ", name, " | ", j

proc callSyscall(self: Processador) =
    let op = self.getR(regToIndex("$sv"))
    case op
      of 1 : self.printInteiro()
      else : return

# Recebe um comando e seus argumentos e executa
proc exce*(self: Processador, instrucao: Instrucao) =
    let args = instrucao.args
    case instrucao.op
      of "add"     : self.add(args[0], args[1], args[2]) 
      of "addi"    : self.addi(args[0], args[1], args[2]) 
      of "sub"     : self.sub(args[0], args[1], args[2])
      of "subi"    : self.subi(args[0], args[1], args[2])
      of "li"      : self.addi(args[0], "$ZERO", args[1])
      of "move"    : self.add(args[0], "$ZERO", args[1])
      of "ssc"     : self.ssc(args[0].parseInt())
      of "syscall" : self.callSyscall()
      of "showmem" : self.showMem()

proc cleanProgramStack(self: Processador) =
    self.programStack = newSeq[Instrucao]()

proc execProgram*(self: Processador) =
    for ins in self.programStack :
        self.exce(ins)
    self.cleanProgramStack()

# Descrição do Processador
proc about*(self: Processador) =    
    let Kokonoe = """              
 _   _______ _   _______ _   _ _____ _____ 
| | / /  _  | | / /  _  | \ | |  _  |  ___|
| |/ /| | | | |/ /| | | |  \| | | | | |__  
|    \| | | |    \| | | | . ` | | | |  __| 
| |\  \ \_/ / |\  \ \_/ / |\  \ \_/ / |___ 
\_| \_/\___/\_| \_/\___/\_| \_/\___/\____/ 

                  ,                  | 
                 %,                  | Emulador do Processador Kokonoe
             % /,,,              .   | Escrito por: Dromedario de Chapeu
           ,#,*,,,,.#        ,*, /,  | GitHub: https://github.com/MarceloLuisDantas/Kokonoe
        /##,,,,,,,#*@*###*,,,,,,,,   | 
      (#*,,,,,,,.*,,#########.,*%    | 
     %#,,,,***,**######/%%%%%%%.     | 
   ,%#,,,*,%&*,**##/%%%%**/%%%%%     | 
  *%%,,**   .**.*%,(%#(@@&%%,%%/#    | 
  %%,,**       *,#,/*,*/,,(&%#(,#    | 
 ,%%,,*       ., #***&@&@@*/##,,#    | 
,.*%,,*       *,,,%%,*%%/&& ,,,,*    | 
%.,#%,,        ,,,,,,/%%    ,,,,     | 
..,,#..         ******@@*#  .,,,     | 
 ..,,,(,        .*,*%&&&,##  ,,,     | Digite exit para fechar
  ...,,        .,,.%%%%..((% ,,,     | 

All Copyright of Kokonoe Character reserved to Arc System Works - Team Blue"""

    echo Kokonoe