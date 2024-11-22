;----------------------------------------------------------------------------
; mCHOICE ver. 1.2 ** ~1994 'marikaz'
;----------------------------------------------------------------------------
; mCHOICE moze zastapic CHOICE z MS-DOS lub FreeDOS. Dziala z MS-DOS 2.0+
; Funkcjonalnie identyczny z CHOICE z MS-DOS
;
; mCHOICE can replace CHOICE from MS-DOS or FreeDOS. Works with MS-DOS 2.0+
;----------------------------------------------------------------------------

CHOICESLEN  EQU 7ah
ERRORFLAG   EQU -1
EOS         EQU 0


PRINTSTR    MACRO str
            push ax
            mov dx,OFFSET str
            mov ah,9
            int 21h
            pop ax
            ENDM

code    SEGMENT PUBLIC 'code'
        ASSUME  cs:code

JUMPS
ORG 100h
Main            PROC
                mov ax,3000h
                int 21h
                cmp al,2      ;DOS 2+
                jnb verOK
                lea si,errVNMsg
                call PrnMsg
                ret           ;=INT 20h
verOK:
                mov al,0ffh
                lea di,ccb
                mov cx,CHOICESLEN
                cld
                rep stosb

                call GetCmdLine
                cmp statCMDL,1
                ja prnErrorMsg
                call SetupPrompt
                test pFlags,1
                jz waitForKey
                call DelayMode
                cmp ax,ERRORFLAG
                jne exit
                lea si,errDCMsg
                call PrnMsg
                jmp exitNow

waitForKey:
                PRINTSTR prompt
getKey:
                mov ax,0c08h
                int 21h
                cmp al,3
                jne noCtrlC
                mov al,0
                jmp exitNow
       noCtrlC:
                call CheckChar
                cmp ax,ERRORFLAG
                je getKey
exit:
                lea si,defChar
                call PrnMsg
exitNow:
                mov ah,4ch
                int 21h
prnErrorMsg:
                mov al,ERRORFLAG
                cmp statCMDL,2
                jne errTO
                lea si,errSWMsg
                call PrnMsg
                lea si,fb
                call PrnMsg
                jmp exitNow
         errTO:
                cmp statCMDL,3
                jne errPR
                lea si,errTOMsg
                call PrnMsg
                jmp exitNow
         errPR:
                cmp statCMDL,4
                jne prnHL
                lea si,errPRMsg
                call PrnMsg
                lea si,fb
                call PrnMsg
                jmp exitNow
         prnHL:
                lea si,help
                call PrnMsg
                lea si,fe
                call PrnMsg
                jmp exitNow
;----------------------------------------------------------------------------
SetupPrompt     PROC
                test pFlags,10b
                jnz caseS
                mov si,OFFSET cChar
                mov di,si
        upCase:
                cmp BYTE PTR [si],-1
                je caseS
                lodsb
                cmp al,'a'
                jb skpUC
                cmp al,'z'
                ja skpUC
                and al,11011111b
         skpUC:
                stosb
                jmp upCase
         caseS:
                mov si,OFFSET cChar
                mov di,prTail
                test pFlags,100b ;/n
                jnz endPrompt
                mov al,'['
                stosb
         setPr:
                cmp BYTE PTR [si],-1
                je endSetPr
                movsb
                mov al,','
                stosb
                jmp setPr
      endSetPr:
                dec di
                mov ax,'?]'
                stosw
     endPrompt:
                mov BYTE PTR [di],'$'
                ret
SetupPrompt     ENDP

CheckChar       PROC
                test pFlags,10b
                jnz skpUp
                cmp al,'a'
                jb skpUp
                cmp al,'z'
                ja skpUp
                and al,11011111b
         skpUp:
                mov cx,CHOICESLEN
                lea di,cChar
                repne scasb
                or cx,cx
                jz noChar
                mov defChar,al
                mov ax,CHOICESLEN
                sub ax,cx
                mov defErrLvl,al
                ret
        noChar:
                lea si,beep
                call PrnMsg
                mov ax,ERRORFLAG
                ret
CheckChar       ENDP

DelayMode       PROC
                mov al,defChar
                call CheckChar
                cmp ax,ERRORFLAG
                jne setTimer
                ret
      setTimer:
                PRINTSTR prompt
                mov cx,delay
                or cx,cx
                jz CharFromCon ;nn=0
                shl cx,3
         _wait:
                push cx
                mov ah,86h
                mov cx,1
                mov dx,0e848h   ;1e848 = 1/8 sec.
                int 15h
                pop cx
                call chkKey
                jc exitNow
                cmp ax,ERRORFLAG
                jne CharFromCon
                loop _wait
   CharFromCon:
                mov al,defErrLvl
                ret
DelayMode       ENDP

ChkKey          PROC
                push cx
                mov ah,0bh
                int 21h
                or al,al
                jnz gotKey
                mov ax,ERRORFLAG
                pop cx
                ret
        gotKey:
                mov ah,8
                int 21h
                cmp al,3
                jne nGK
                mov al,0
                pop cx
                stc
                ret
           nGK:
                call CheckChar
                pop cx
                clc
                ret
ChkKey          ENDP

PrnMsg          PROC
                push ax
                mov ah,0eh
            lp:
                lodsb
                or al,al
                jz ep
                int 10h
                jmp lp
            ep:
                pop ax
                ret
PrnMsg          ENDP

                INCLUDE gcmdl2.asm

beep      DB 7,EOS
statCMDL  DB 1
pFlags    DB 0
defChar   DB ?,13,10,EOS
defErrLvl DB ?
prTail    DW OFFSET prompt
delay     DW 0

          INCLUDE msg.inc

cChar     DB 'yn'
ccb       DB CHOICESLEN DUP (?)
prompt    LABEL BYTE
Main            ENDP
code ENDS
     END Main
