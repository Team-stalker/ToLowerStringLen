format PE GUI 4.0
entry main
include 'win32ax.inc'

;***************************************************************************************************************
section '.data' data readable writeable
       String db 'XRAY PROJECT',0

section '.code' code readable executable
proc main
       stdcall ToLower,String
       invoke  MessageBox,NULL,String,'test',MB_OK
.exit:
       invoke  ExitProcess, 0
endp
;***************************************************************************************************************

;***************************************************************************************************************
; Перевод символов строки в нижний регистр
; Вернет длину строки
; ----------------------------------------
proc ToLower,pStrAddr
     push ebx ecx edx esi edi
     mov  esi,[pStrAddr]
     dec  esi
     xor  ecx, ecx
     dec ecx
.to_lower_byte_loop:
     inc  esi
     inc  ecx
     movzx eax,byte [esi]
     cmp  al, 0x0
     je   .to_lower_byte_ret
     cmp  ecx,0x100
     JAE  .add_end_string
.compare_eng:
     cmp  al,0x41
     jb   .to_lower_byte_loop
     cmp  al,0x5A
     jbe  .add_byte
.compare_rus:
     cmp  al,0xC0
     jb   .to_lower_byte_loop
     cmp  al,0xDF
     ja   .to_lower_byte_loop
.add_byte:
     add  eax, 0x20            
     mov  byte[esi], al
     jmp  .to_lower_byte_loop
.add_end_string:
     mov  byte[esi],0
.to_lower_byte_ret:
     mov  eax,ecx
     pop  edi esi edx ecx ebx
     ret
endp
;***************************************************************************************************************


;***************************************************************************************************************
section '.idata' import data readable writeable

     library kernel32,'KERNEL32.DLL',\
          user32,'user32.dll'

     include 'api/kernel32.inc'
     include 'api/user32.inc'

;***************************************************************************************************************
