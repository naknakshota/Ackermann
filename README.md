# Ackermann Function Using X86

#### See below link for reference:
https://en.wikipedia.org/wiki/Ackermann_function

#### Compile using the following Command:
     nasm -f elf -gstabs pr.asm
     ld -o pr -m elf_i386 pr.o
#### Run using following command:
    ./pr
