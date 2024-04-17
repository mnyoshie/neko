MEMORY {
  ram (rw) : ORIGIN = 0x0000, LENGTH = 0x7c00
  exe (rwx) : ORIGIN = 0x7e00, LENGTH = 0x81ff
}

SECTIONS {
  . = 0x7e00;
  .text : {
    *(.text)
  } > exe

  .data : ALIGN(512)  {
    *(.data)
  } > exe

  .bss : ALIGN(512) {
    *(.bss)
  } > exe

}
