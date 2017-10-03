/*
 * Copyright (c) 2000, 2001, 2002, 2003, 2004, 2005, 2008, 2009
 *	The President and Fellows of Harvard College.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE UNIVERSITY AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

/*
 * setjmp and longjmp for MIPS.
 */

#define z0  $0     /* always zero register */
#define AT  $1     /* assembler temp register */
#define v0  $2     /* value 0 */
#define v1  $3     /* value 1 */
#define a0  $4     /* argument 0 */
#define a1  $5     /* argument 1 */
#define a2  $6     /* argument 2 */
#define a3  $7     /* argument 3 */
#define t0  $8     /* temporary (caller-save) 0 */
#define t1  $9     /* temporary (caller-save) 1 */
#define t2  $10    /* temporary (caller-save) 2 */
#define t3  $11    /* temporary (caller-save) 3 */
#define t4  $12    /* temporary (caller-save) 4 */
#define t5  $13    /* temporary (caller-save) 5 */
#define t6  $14    /* temporary (caller-save) 6 */
#define t7  $15    /* temporary (caller-save) 7 */
#define s0  $16    /* saved (callee-save) 0 */
#define s1  $17    /* saved (callee-save) 1 */
#define s2  $18    /* saved (callee-save) 2 */
#define s3  $19    /* saved (callee-save) 3 */
#define s4  $20    /* saved (callee-save) 4 */
#define s5  $21    /* saved (callee-save) 5 */
#define s6  $22    /* saved (callee-save) 6 */
#define s7  $23    /* saved (callee-save) 7 */
#define t8  $24    /* temporary (caller-save) 8 */
#define t9  $25    /* temporary (caller-save) 9 */
#define k0  $26    /* kernel temporary 0 */
#define k1  $27    /* kernel temporary 1 */
#define gp  $28    /* global pointer */
#define sp  $29    /* stack pointer */
#define s8  $30    /* saved (callee-save) 8 = frame pointer */
#define ra  $31    /* return address */

   .text
   .set noreorder

   /*
    * int setjmp(jmp_buf jb);
    *
    * Save the current state so we can return again from the call later
    * if/when longjmp is called. (If the function that called setjmp
    * returns before longjmp is called, the results are undefined. We
    * only need to save registers, not the whole contents of the stack.)
    */

   .globl setjmp
   .type setjmp,@function
   .ent setjmp
setjmp:
   /*
    * jmp_buf is in a0. We need to save s0-s8, sp, and ra in it.
    * Don't store more registers without adjusting machine/setjmp.h.
    */

   sw sp, 0(a0)		/* save registers */
   sw ra, 4(a0)
   sw s0, 8(a0)
   sw s1, 12(a0)
   sw s2, 16(a0)
   sw s3, 20(a0)
   sw s4, 24(a0)
   sw s5, 28(a0)
   sw s6, 32(a0)
   sw s7, 36(a0)
   sw s8, 40(a0)

   j ra			/* done */
   li v0, 0		/* return 0 (in delay slot) */
   .end setjmp


   /*
    * void longjmp(jmp_buf jb, int code);
    */
   .globl longjmp
   .type longjmp,@function
   .ent longjmp
longjmp:
   /*
    * jmp_buf is in a0. Return code is in a1.
    * We need to restore s0-s8, sp, and ra from the jmp_buf.
    * The return code is forced to 1 if 0 is passed in.
    */

   sltiu t0, a1, 1	/* set t0 to 1 if return code is 0... otherwise 0 */
   addu a1, a1, t0	/* update the return code */

   lw sp, 0(a0)		/* restore registers */
   lw ra, 4(a0)
   lw s0, 8(a0)
   lw s1, 12(a0)
   lw s2, 16(a0)
   lw s3, 20(a0)
   lw s4, 24(a0)
   lw s5, 28(a0)
   lw s6, 32(a0)
   lw s7, 36(a0)
   lw s8, 40(a0)

   j ra			/* return, to where setjmp was called from */
   move v0, a1		/* set return value */
   .end longjmp
