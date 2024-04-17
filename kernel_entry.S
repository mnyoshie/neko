.code16
.extern main16
.globl _start
.text
_start:
     movb $0x0e, %ah
     movb $'o', %al
     int $0x10
     movb $'k', %al
     int $0x10
     movb $'!', %al
     int $0x10
     movb $'\n', %al
     int $0x10
     movb $'\r', %al
     int $0x10
     jmpw $0x0000, $main16
