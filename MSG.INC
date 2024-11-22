; Messages ** mCHOICE v1.2 **

help DB "CHOICE v1.2 * (c)1994 by 'marikaz'",13,10
     DB "Waits for the user to choose one of a set of choices.",13,10,13,10
  fb DB '  CHOICE [/C[:]choices] [/N] [/S] [/T[:]c,nn] [text]',13,10,13,10,EOS
  fe DB "/C[:]choices Specifies allowable keys. Default is yn.",13,10
     DB "/N           Do not display choices and ? at end of prompt string.",13,10
     DB "/S           Make the choices case sensitive.",13,10
     DB "/T[:]c,nn    Default choice to c after nn seconds.",13,10
     DB "text         Prompt string to display.",13,10,13,10
     DB "ERRORLEVEL is set to offset of key user presses in choices.",13,10,EOS

errSWMsg DB 'Invalid switch on command line. Expected form:',13,10,EOS
errVNMsg DB 'CHOICE: Required MS-DOS version 2.0 or higher.',13,10,EOS
errTOMsg DB 'CHOICE: Incorrect timeout syntax. Expected form: T[:]c,nn',13,10,EOS
errPRMsg DB 'CHOICE: Only one prompt string allowed. Expected form:',13,10,EOS
errDCMsg DB 'CHOICE: Timeout default not in specified (or default) choices.',13,10,EOS
