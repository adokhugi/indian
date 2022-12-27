;indian winter
;demobit 2018
;by adok/hugi

;run with dosbox
;speed: at least 24000 cycles
;(press ctrl+f12 repeatedly)

.286
code segment
assume cs:code,ds:code
org 100h

program:
	push	0a000h + 400
	pop	es

	mov	al,13h
	int	10h

	xor	di,di

	mov	dx,3c9h
	mov	cl,64
	push	cx
pal_l1:
	xor	ax,ax
	out	dx,al
	pop	ax
	push	ax
	sub	ax,cx
	out	dx,al
	out	dx,al
	loop	pal_l1
	pop	cx
	xor	ax,ax
pal_l2:
	push	ax
	out	dx,al
	mov	al,63
	out	dx,al
	pop	ax
	out	dx,al
	inc	ax
	loop	pal_l2

inner_loop:
	inc	bp
	jne	inner_loop_l1
	not	ax

inner_loop_l1:
	stosb
	dec	di

	push	ax

	xor	dx,dx
	mov	ax,di
	div	word ptr xscreen + 4		; 320
	or	dx,dx
	jnz	not_left_border_reached
	mov	[x_dir],2
not_left_border_reached:
	cmp	dx,319
	jnz	not_right_border_reached
	neg	[x_dir]
not_right_border_reached:
	or	ax,ax
	jnz	not_top_border_reached
xscreen:
	mov	[y_dir],320
not_top_border_reached:
	cmp	ax,159
	jnz	not_bottom_border_reached
	neg	[y_dir]
not_bottom_border_reached:

	add	di,[x_dir]
	add	di,[y_dir]

	in	al,60h
	dec	ax
	je	ende
	pop	ax
	loop	inner_loop

	push	ax

	push	cx
	push	di

blur0:
	push	ds

	push	es
	pop	ds

	xor	ax,ax

	dec	cx
blur1:
	mov	si,cx
	dec	si
	lodsb
	mov	dx,ax
	inc	si
	lodsb
	add	dx,ax
	xchg	ax,dx
	shr	ax,1
	mov	di,si
	dec	di
	dec	di
	stosb
	loop	blur1

	pop	ds

	pop	di
	pop	cx

	pop	ax
	inc	ch
	jmp	inner_loop

ende:
	pop	ax
	ret

; variables
x_dir	dw ?
y_dir	dw ?

code ends
end program