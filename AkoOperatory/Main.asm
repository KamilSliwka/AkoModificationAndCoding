; Przyk³ad wywo³ywania funkcji MessageBoxW ze znakami polskimi
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
extern __write : PROC
extern __read : PROC
public _main
.data
tekstP db 'wpisz znaki i kliknij ','enter',10
tekstK db ?
tytulUnicode dw 'U','T','F','-','1','6',0
bufor dw 80 dup (?)
magazyn db 80 dup (?)
wynik dw 80 dup (?)
dlugoscTekstu dd ?
.code
_main PROC


mov ecx,(offset tekstK) - (offset tekstP)
push ecx
push offset tekstP
push 1
call __write
add esp,12

push 80
push offset magazyn
push 0
call __read
add esp,12
mov dlugoscTekstu,eax
mov ecx,eax
mov ebx,0
mov eax,0
mov edx,0
ptl:
mov dl,magazyn[eax]
mov bufor[ebx],dx
add ebx,2
inc eax
dec ecx
jnz ptl

mov ecx,dlugoscTekstu
mov eax,0
ptl1:
mov dx,bufor[eax]
cmp dx,0A5H;¹
jnz con1
mov dx,0105H
jmp next
con1:
cmp dx,86H;æ
jnz con2
mov dx,0107H
jmp next
con2:
cmp dx,0A9H;ê
jnz con3
mov dx,0119H
jmp next
con3:
cmp dx,88H;³
jnz con4
mov dx,0142H
jmp next
con4:
cmp dx,0E4H;ñ
jnz con5
mov dx,0144H
jmp next
con5:
cmp dx,0A2H;ó
jnz con6
mov dx,00F3H
jmp next
con6:
cmp dx,98H;œ
jnz con7
mov dx,015BH
jmp next
con7:
cmp dx,0ABH;Ÿ
jnz con8
mov dx,017AH
jmp next
con8:
cmp dx,0BEH;¿
jnz next
mov dx,017CH
next:
mov bufor[eax],dx
add eax,2
dec ecx
jnz ptl1

mov ebx,0
mov eax,0
mov edx,0
mov ecx,dlugosctekstu
dec ecx
ptl2:
mov dx,bufor[ebx]  ;zamiana 4 kolejnch liter
mov ax,bufor[ebx+6]
mov bufor[ebx+6],dx
mov bufor[ebx],ax

mov dx,bufor[ebx+2]
mov ax,bufor[ebx+4]
mov bufor[ebx+4],dx
mov bufor[ebx+2],ax
add ebx,8;przeskok o 4 litery
sub ecx,4
jnz ptl2

mov ebx,0
mov eax,0
mov edx,0
mov ecx,dlugosctekstu
dec ecx
ptl3:
mov dx,bufor[ebx]   ;czy jest 1234
cmp dx,0031H
jnz dalej
mov dx,bufor[ebx+2]
cmp dx,0032H
jnz dalej
mov dx,bufor[ebx+4]
cmp dx,0033H
jnz dalej
mov dx,bufor[ebx+6]
cmp dx,0034H
jnz dalej
mov wynik[eax],006CH  ; nowa tablica przepisujemy do niej rezultat 
mov wynik[eax+2],0069H
mov wynik[eax+4],0063H
mov wynik[eax+6],007AH
mov wynik[eax+8],0062H
mov wynik[eax+10],0061H
add eax,12
add ebx,8
sub ecx,4
jz exit
dalej:
mov dx,bufor[ebx]
mov wynik[eax],dx
add eax,2
add ebx,2
dec ecx
jnz ptl3
exit:
push 0
push offset tytulUnicode
push offset wynik
push 0
call _MessageBoxW@16  



 push 0 ; kod powrotu programu
 call _ExitProcess@4
_main ENDP
END