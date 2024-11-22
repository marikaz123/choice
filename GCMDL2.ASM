;----------------------------------------------------------------
; GetCMDLine * REV. D                                * marikaz *
;----------------------------------------------------------------
; No parametrs                                           (ret 0)
; Parametrs without errors                               (ret 1)
; Invalid switch on command line.                        (ret 2)
; Incorrect timeout syntax.                              (ret 3)
; Only one prompt string allowed.                        (ret 4)
; Timeout default not in specified (or default) choices. (main)
; Help [/?]                                              (ret 6)
;----------------------------------------------------------------

SPC = 20h
TAB = 9
CR  = 0Dh
SW  = '/'
QM  = '"'
Q   = '?'
N   = 'n'
S   = 's'
C   = 'c'
T   = 't'

GetCmdLine      PROC
                xor ax,ax          ;ax=error code
                mov si,80h
                cmp BYTE PTR [si],1
                jbe endParametrs
                inc si
gCmdL:
                lodsb
                cmp al,SPC
                je skipBC
                cmp al,TAB
                je skipBC
                cmp al,CR
                je endParametrs
                mov statCMDL,2
                jmp endParametrs
        skipBC:
                lodsb
                cmp al,SPC
                je skipBC
                cmp al,TAB
                je skipBC
                cmp al,CR
                je endParametrs

                mov statCMDL,1
                cmp al,SW
                je switches
                ;prompt
                test pFlags,10000b
                jz _tx
                mov statCMDL,4
                jmp endParametrs
           _tx:
                or pFlags,10000b
                lea di,prompt
                call GetPrompt
                cmp ax,ERRORFLAG
                jne gCmdL
                mov statCMDL,2
                jmp endParametrs
switches:
                lodsb
                cmp al,Q
                jne switchN
                mov statCMDL,6
                jmp endParametrs
switchN:
                or al,100000b
                cmp al,N
                jne switchS
                or pFlags,100b
                jmp gCmdL
switchS:
                cmp al,S
                jne switchC
                or pFlags,10b
                jmp gCmdL
switchC:
                cmp al,C
                jne switchT
                test pFlags,1000b
                jnz errSwC
                or pflags,1000b
                lea di,cChar
                call GetSwCParam
                cmp ax,ERRORFLAG
                jne gCmdL
        errSwC:
                mov statCMDL,2
                jmp endParametrs
switchT:
                cmp al,T
                je _st
                mov statCMDL,2
                jmp endParametrs
           _st:
                test pFlags,1
                jnz errSwT
                or pFlags,1
                call GetSwTParam
                cmp ax,ERRORFLAG
                jne gCmdL
        errSwT:
                mov statCMDL,3
endParametrs:
                ret
GetCmdLine      ENDP
;--------------------------------------------------------- GetPrompt -------
GetPrompt       PROC
                cmp al,QM
                je qMark
         getPR:
                cmp al,CR
                je _cr
                cmp al,SW
                je _sw
                cmp al,QM
                je errQ
                stosb
                lodsb
                jmp getPR
           _sw:
                dec si ;   slash
                dec di ; /
           _cr:
                dec si
                mov al,SPC
                stosb
                mov prTail,di
                ret
qMark:
                lodsb
                cmp al,QM
                je _qm
                cmp al,CR
                je errQ
                stosb
                jmp qMark
           _qm:
                mov prTail,di
                ret
          errQ:
                mov ax,ERRORFLAG
                ret
GetPrompt       ENDP
;--------------------------------------------------------- GetSwCParam ------
GetSwCParam     PROC
                mov cx,CHOICESLEN
                cmp BYTE PTR [si],':'
                jne getChoices
                inc si
    getChoices:
                lodsb
                IFDEF NOSLASH    ;FreeDOS does not allow '/'
                 cmp al,SW       ;but MS-DOS does...
                 je errGC
                ENDIF
                cmp al,CR
                je endGC
                cmp al,TAB
                je endGC
                cmp al,SPC
                je endGC
                jb errGC
                stosb
                loop getChoices
         errGC:
                mov ax,ERRORFLAG
                ret
         endGC:
                mov BYTE PTR [di],-1
                dec si
                ret
GetSwCParam     ENDP
;---------------------------------------------------------- GetSwTParam -----
GetSwTParam     PROC
                cmp BYTE PTR [si],':'
                jne getDCh
                inc si
        getDCh:
                lodsb
                mov defChar,al
                cmp BYTE PTR [si],','
                jne errGS
                inc si
                lodsw
                cmp al,'0'
                jb errGS
                cmp al,'9'
                ja errGS
                cmp ah,SPC
                je oneD
                cmp ah,TAB
                je oneD
                cmp ah,CR
                je oneD
                cmp ah,'0'
                jb errGS
                cmp ah,'9'
                jb twoD
                jmp errGS
          oneD:
                sub al,'0'
                mov BYTE PTR delay,al
                dec si  ;1d
                ret
          twoD:
                cmp BYTE PTR [si],SPC
                je _td
                cmp BYTE PTR [si],TAB
                je _td
                cmp BYTE PTR [si],CR
                jne errGS
           _td:
                sub ax,'00'
                shl al,1
                mov dl,al
                shl al,2
                add al,dl
                add al,ah
                mov BYTE PTR delay,al
                ret

         errGS:
                mov ax,ERRORFLAG
                ret
GetSwTParam     ENDP
