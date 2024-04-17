.code16
.text

#################
# MBR #
#################
_start:
     movw $0x0000, %ax
     cli
     movw %ax, %ss
     movw $0x7c00, %sp
     jmp _boot
     str_read_disk: .asciz "Reading disk..\n\r"
     str_read_done: .asciz "Reading done..\n\r"
_boot:
     leaw str_read_disk, %si
     call write_string

     # read disk
     movb $0x02, %ah
     # sectors to read
     movb $3, %al
     # offset of buffer
     movw $0x7e00, %bx
     # track number
     movb $0, %ch
     # sector
     movb $2, %cl
     # head
     xorb %dh, %dh
     int $0x13
     leaw str_read_done, %si
     call write_string
     ljmpw $0x0000, $0x7e00
.eternity:
     hlt
     jmp .eternity
write_string:
     movb $0x0e, %ah
.write_char:
     lodsb
     orb %al, %al
     jz .end_write_char
     int $0x10
     jmp .write_char
.end_write_char:
     ret
     # partition 1
     . = _start + 446
     .byte 0x01 # status

     .byte 0x00 # head
     .byte 0x02 # sector
     .byte 0x00 # cylinder

     .byte 0x00 # partition type

     .byte 0x00 # e head
     .byte 0x1e # e sector
     .byte 0x00 # e cylinder

     .byte 0x00, 0x00, 0x00, 0x01
     .byte 0x00, 0x00, 0x00, 0x1e

     . = _start + 510
     .byte 0x55
     .byte 0xaa
