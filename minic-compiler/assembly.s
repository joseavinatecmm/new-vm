	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 26, 0	sdk_version 26, 2
	.globl	_suma                           ## -- Begin function suma
	.p2align	4, 0x90
_suma:                                  ## @suma
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	leaq	L_.str(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movl	-4(%rbp), %eax
	addl	-8(%rbp), %eax
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %esi
	leaq	L_.str.1(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movl	-12(%rbp), %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_multiplicar                    ## -- Begin function multiplicar
	.p2align	4, 0x90
_multiplicar:                           ## @multiplicar
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	leaq	L_.str.2(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movl	-4(%rbp), %eax
	imull	-8(%rbp), %eax
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %esi
	leaq	L_.str.3(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movl	-12(%rbp), %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_main                           ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movl	$0, -4(%rbp)
	leaq	L_.str.4(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movl	$10, -8(%rbp)
	movl	$20, -12(%rbp)
	movl	-8(%rbp), %eax
	addl	-12(%rbp), %eax
	movl	%eax, -16(%rbp)
	movl	-8(%rbp), %esi
	leaq	L_.str.5(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movl	-12(%rbp), %esi
	leaq	L_.str.6(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movl	-16(%rbp), %esi
	leaq	L_.str.7(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movl	-8(%rbp), %edi
	movl	-12(%rbp), %esi
	callq	_suma
	movl	-8(%rbp), %edi
	movl	-16(%rbp), %esi
	callq	_multiplicar
	movl	-16(%rbp), %ecx
	movq	_contador@GOTPCREL(%rip), %rax
	movl	%ecx, (%rax)
	movq	_contador@GOTPCREL(%rip), %rax
	movl	(%rax), %ecx
	movq	_global@GOTPCREL(%rip), %rax
	movl	%ecx, (%rax)
	movq	_global@GOTPCREL(%rip), %rax
	cmpl	$0, (%rax)
	je	LBB2_2
## %bb.1:
	movq	_global@GOTPCREL(%rip), %rax
	movl	(%rax), %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %ecx
	movq	_contador@GOTPCREL(%rip), %rax
	movl	%ecx, (%rax)
	leaq	L_.str.8(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movq	_contador@GOTPCREL(%rip), %rax
	movl	(%rax), %esi
	leaq	L_.str.9(%rip), %rdi
	movb	$0, %al
	callq	_printf
LBB2_2:
	leaq	L_.str.10(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movq	_contador@GOTPCREL(%rip), %rax
	movl	(%rax), %eax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"Entrando a suma\n"

L_.str.1:                               ## @.str.1
	.asciz	"Resultado calculado en suma: %d\n"

L_.str.2:                               ## @.str.2
	.asciz	"Entrando a multiplicar\n"

L_.str.3:                               ## @.str.3
	.asciz	"Producto calculado: %d\n"

L_.str.4:                               ## @.str.4
	.asciz	"Iniciando programa MiniC\n"

L_.str.5:                               ## @.str.5
	.asciz	"Valor de x: %d\n"

L_.str.6:                               ## @.str.6
	.asciz	"Valor de y: %d\n"

L_.str.7:                               ## @.str.7
	.asciz	"Valor de z: %d\n"

	.comm	_contador,4,2                   ## @contador
	.comm	_global,4,2                     ## @global
L_.str.8:                               ## @.str.8
	.asciz	"Dentro del bloque if\n"

L_.str.9:                               ## @.str.9
	.asciz	"Valor de contador: %d\n"

L_.str.10:                              ## @.str.10
	.asciz	"Fin del programa\n"

.subsections_via_symbols
