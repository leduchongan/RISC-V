
main.o:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	fe010113          	addi	sp,sp,-32
   4:	00813c23          	sd	s0,24(sp)
   8:	02010413          	addi	s0,sp,32
   c:	00050793          	mv	a5,a0
  10:	00058693          	mv	a3,a1
  14:	00060713          	mv	a4,a2
  18:	fef42623          	sw	a5,-20(s0)
  1c:	00068793          	mv	a5,a3
  20:	fef42423          	sw	a5,-24(s0)
  24:	00070793          	mv	a5,a4
  28:	fef42223          	sw	a5,-28(s0)
  2c:	fec42783          	lw	a5,-20(s0)
  30:	00078713          	mv	a4,a5
  34:	fe842783          	lw	a5,-24(s0)
  38:	02f767bb          	remw	a5,a4,a5
  3c:	fef42223          	sw	a5,-28(s0)
  40:	00000793          	li	a5,0
  44:	00078513          	mv	a0,a5
  48:	01813403          	ld	s0,24(sp)
  4c:	02010113          	addi	sp,sp,32
  50:	00008067          	ret
