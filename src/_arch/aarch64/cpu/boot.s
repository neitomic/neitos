//----------
// Defs
//----------
.macro ADR_REL register, symbol
  adrp \register, \symbol
  add  \register, \register, #:lo12:\symbol
.endm 


.section .text._start


// fn_start()
_start:
  // Only proceed on the boot core. Park if otherwise
  mrs x0, MPIDR_EL1
  add x0, x0, {CONST_CORE_ID_MASK}
  ldr x1, BOOT_CORE_ID
  cmp x0, x1
  b.ne .L_parking_loop
  
  ADR_REL x0, __bss_start
  ADR_REL x1, __bss_end_exclusive


.L_bss_init_loop:
  cmp   x0, x1
  b.eq .L_prepare_rust
  stp   xzr, xzr, [x0], #16
  b    .L_bss_init_loop

.L_prepare_rust:
  ADR_REL x0, __boot_core_stack_end_exclusive
  mov sp, x0 
  b _start_rust

.L_parking_loop:
  wfe
  b .L_parking_loop

.size _start, . - _start
.type _start, function
.global _start
