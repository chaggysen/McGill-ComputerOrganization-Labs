.global _start
_start:

MOV R0, #0 // R0 will be step
MOV R1, #168 // R1=168 (a)
MOV R2, #1 // R2=1 (xi)
MOV R3, #100 // R3=100 (cnt)
MOV R4, #10 // R4=10 (k)
MOV R5, #2 // R5=2 (t)

LOOP:
	MUL R6, R2, R2 //xi*xi
	SUBS R7, R6, R1 // (xi*xi)-a
	MUL R8, R7, R2 // (xi*xi-a)*xi
	ASR R8, R8, R4 // ((xi*xi-1)*xi)>>k
	MOV R0, R8 // load content of R8 in R0(step)
	CMP R0, #2 // if (step > t)
	BGT GT
	CMP R0, #-2 //(if step < -t)
	BLT LT
	B YO
	
GT:
MOV R0, #2 // step = t if R5-R0<=0
B YO

LT:
MOV R0, #-2
B YO

YO:
SUBS R2, R2, R0
SUBS R3, R3, #1
BGT LOOP

STOP:
B STOP
	