
void set_vga_256(void) { __asm__ __volatile__("int $0x10\n" ::"a"(0x0013)); }

void write_pixel(int x, int y, int page, unsigned char val) {
  char *video_address = (char *)(0xa0000);
  video_address[y * 320 + x] = val;
}

void main16(void) {

   set_vga_256();
  // draw palette
  __asm__ __volatile__("movw $0xa000, %%ax\n"
                       "movw %%ax, %%es\n"
                       "movw $0x0000, %%bx\n"
                       "movb $0x02, %%ah\n"
                       "# sectors to read\n"
                       "movb $125, %%al\n"
                       "# offset of buffer\n"
                       "# head\n"
                       "int $0x13\n"
                       :
                       : "c"(0x0006), "d"(0x0080));

  while (1) {
  }

  // printString(str);
  //  write_string();
}
