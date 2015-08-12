
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8
	.DEF _adc_wr_input=R11
	.DEF _adc_rd_input=R10
	.DEF _tempValue=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  _timer2_comp_isr
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  _timer0_comp_isr
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x14:
	.DB  0x1
_0x15:
	.DB  0x2F
_0x8F:
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _isEnable
	.DW  _0x14*2

	.DW  0x01
	.DW  _timeReg
	.DW  _0x15*2

	.DW  0x02
	.DW  0x0A
	.DW  _0x8F*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 04.08.2015
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 32
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 004D {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004E char status,data;
; 0000 004F status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0050 data=UDR;
	IN   R16,12
; 0000 0051 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0052    {
; 0000 0053    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0054 #if RX_BUFFER_SIZE == 256
; 0000 0055    // special case for receiver buffer size=256
; 0000 0056    if (++rx_counter == 0)
; 0000 0057       {
; 0000 0058 #else
; 0000 0059    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(32)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 005A    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(32)
	CP   R30,R7
	BRNE _0x5
; 0000 005B       {
; 0000 005C       rx_counter=0;
	CLR  R7
; 0000 005D #endif
; 0000 005E       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 005F       }
; 0000 0060    }
_0x5:
; 0000 0061 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x8E
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0068 {
_getchar:
; 0000 0069 char data;
; 0000 006A while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 006B data=rx_buffer[rx_rd_index++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 006C #if RX_BUFFER_SIZE != 256
; 0000 006D if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(32)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 006E #endif
; 0000 006F #asm("cli")
_0x9:
	cli
; 0000 0070 --rx_counter;
	DEC  R7
; 0000 0071 #asm("sei")
	sei
; 0000 0072 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0073 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 32
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0083 {
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0084 if (tx_counter)
	TST  R8
	BREQ _0xA
; 0000 0085    {
; 0000 0086    --tx_counter;
	DEC  R8
; 0000 0087    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0088 #if TX_BUFFER_SIZE != 256
; 0000 0089    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(32)
	CP   R30,R9
	BRNE _0xB
	CLR  R9
; 0000 008A #endif
; 0000 008B    }
_0xB:
; 0000 008C }
_0xA:
_0x8E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0093 {
_putchar:
; 0000 0094 while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0xC:
	LDI  R30,LOW(32)
	CP   R30,R8
	BREQ _0xC
; 0000 0095 #asm("cli")
	cli
; 0000 0096 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R8
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
; 0000 0097    {
; 0000 0098    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0099 #if TX_BUFFER_SIZE != 256
; 0000 009A    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(32)
	CP   R30,R6
	BRNE _0x12
	CLR  R6
; 0000 009B #endif
; 0000 009C    ++tx_counter;
_0x12:
	INC  R8
; 0000 009D    }
; 0000 009E else
	RJMP _0x13
_0xF:
; 0000 009F    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00A0 #asm("sei")
_0x13:
	sei
; 0000 00A1 }
	RJMP _0x2060001
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;/////////////////////////////////////////////////////////
;/////////////////////////////////////////////////////////
;
;#define FIRST_ADC_INPUT 0
;#define LAST_ADC_INPUT 3
;#define ADC_VREF_TYPE 0x40
;#define ZERO 10
;
;#define COUNT_CONTROL 75
;#define HYSTIREZIS 15
;
;#define AP PORTC.2
;#define AN PORTC.3
;#define BP PORTC.4
;#define BN PORTC.5
;#define CP PORTC.6
;#define CN PORTC.7
;
;#define LED1 PORTD.4  //green
;#define LED2 PORTD.6  //red
;#define INTA PIND.2
;#define INTB PIND.3
;#define INTC PINB.2
;
;#define MIN_OUT_VOLTAGE (230*COUNT_CONTROL)
;#define MAX_OUT_VOLTAGE (255*COUNT_CONTROL)
;
;#define MIN_TIMEREG 47   //48  //180 grad
;#define MAX_TIMEREG 180  //178 //30 grad
;
;
;char adc_wr_input=0, adc_rd_input=0;
;char isRising[4], isFalling[4];
;signed int adcValue[LAST_ADC_INPUT-FIRST_ADC_INPUT+1], tempValue;
;long OutVoltage = 0;
;char flag, isEnable = 1;

	.DSEG
;unsigned char timeReg = MIN_TIMEREG;
;char regCounter = 0;
;char phaseCounter = 0;
;char old_test = 0;
;
;inline void SetOut(char numb)
; 0000 00D2 {

	.CSEG
_SetOut:
; 0000 00D3   if(isEnable && isRising[numb] && timeReg > MIN_TIMEREG)
;	numb -> Y+0
	LDS  R30,_isEnable
	CPI  R30,0
	BREQ _0x17
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_isRising)
	SBCI R31,HIGH(-_isRising)
	LD   R30,Z
	CPI  R30,0
	BREQ _0x17
	LDS  R26,_timeReg
	CPI  R26,LOW(0x30)
	BRSH _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 00D4   {
; 0000 00D5       switch(numb)
	CALL SUBOPT_0x0
; 0000 00D6       {
; 0000 00D7           case 0: AP = 1; if(isFalling[1]) BN = 1; if(isFalling[2]) CN = 1;
	SBIW R30,0
	BRNE _0x1C
	SBI  0x15,2
	__GETB1MN _isFalling,1
	CPI  R30,0
	BREQ _0x1F
	SBI  0x15,5
_0x1F:
	__GETB1MN _isFalling,2
	CPI  R30,0
	BREQ _0x22
	SBI  0x15,7
; 0000 00D8           break;
_0x22:
	RJMP _0x1B
; 0000 00D9           case 1: BP = 1; if(isFalling[0]) AN = 1; if(isFalling[2]) CN = 1;
_0x1C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x25
	SBI  0x15,4
	LDS  R30,_isFalling
	CPI  R30,0
	BREQ _0x28
	SBI  0x15,3
_0x28:
	__GETB1MN _isFalling,2
	CPI  R30,0
	BREQ _0x2B
	SBI  0x15,7
; 0000 00DA           break;
_0x2B:
	RJMP _0x1B
; 0000 00DB           case 2: CP = 1; if(isFalling[0]) AN = 1; if(isFalling[1]) BN = 1;
_0x25:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1B
	SBI  0x15,6
	LDS  R30,_isFalling
	CPI  R30,0
	BREQ _0x31
	SBI  0x15,3
_0x31:
	__GETB1MN _isFalling,1
	CPI  R30,0
	BREQ _0x34
	SBI  0x15,5
; 0000 00DC           break;
_0x34:
; 0000 00DD       }
_0x1B:
; 0000 00DE 
; 0000 00DF       delay_us(50);
	__DELAY_USW 200
; 0000 00E0 
; 0000 00E1       switch(numb)
	CALL SUBOPT_0x0
; 0000 00E2       {
; 0000 00E3           case 0: AP = 0; BN = 0; CN = 0;
	SBIW R30,0
	BRNE _0x3A
	CBI  0x15,2
	CBI  0x15,5
	CBI  0x15,7
; 0000 00E4           break;
	RJMP _0x39
; 0000 00E5           case 1: BP = 0; AN = 0; CN = 0;
_0x3A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x41
	CBI  0x15,4
	CBI  0x15,3
	CBI  0x15,7
; 0000 00E6           break;
	RJMP _0x39
; 0000 00E7           case 2: CP = 0; AN = 0; BN = 0;
_0x41:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x39
	CBI  0x15,6
	CBI  0x15,3
	CBI  0x15,5
; 0000 00E8           break;
; 0000 00E9       }
_0x39:
; 0000 00EA   }
; 0000 00EB }
_0x16:
_0x2060001:
	ADIW R28,1
	RET
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00EF {
_timer0_ovf_isr:
	CALL SUBOPT_0x1
; 0000 00F0 // Reinitialize Timer 0 value
; 0000 00F1 TCCR0=0x00;
	OUT  0x33,R30
; 0000 00F2 TCNT0=0x4A;
	LDI  R30,LOW(74)
	OUT  0x32,R30
; 0000 00F3 // Place your code here
; 0000 00F4 SetOut(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SetOut
; 0000 00F5 }
	RJMP _0x8C
;
;// Timer 0 output compare interrupt service routine
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 00F9 {
_timer0_comp_isr:
	CALL SUBOPT_0x1
; 0000 00FA // Place your code here
; 0000 00FB SetOut(0);
	ST   -Y,R30
	RCALL _SetOut
; 0000 00FC }
	RJMP _0x8C
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0100 {
_timer1_ovf_isr:
	CALL SUBOPT_0x1
; 0000 0101 // Reinitialize Timer1 value
; 0000 0102 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0103 TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
; 0000 0104 TCNT1L=0x4A;
	LDI  R30,LOW(74)
	OUT  0x2C,R30
; 0000 0105 // Place your code here
; 0000 0106 SetOut(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _SetOut
; 0000 0107 }
	RJMP _0x8C
;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 010B {
_timer1_compa_isr:
	CALL SUBOPT_0x2
; 0000 010C // Place your code here
; 0000 010D SetOut(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _SetOut
; 0000 010E }
	RJMP _0x8C
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0112 {
_timer2_ovf_isr:
	CALL SUBOPT_0x1
; 0000 0113 // Reinitialize Timer2 value
; 0000 0114 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0115 TCNT2=0x4A;
	LDI  R30,LOW(74)
	OUT  0x24,R30
; 0000 0116 // Place your code here
; 0000 0117 SetOut(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _SetOut
; 0000 0118 }
	RJMP _0x8C
;
;// Timer2 output compare interrupt service routine
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
; 0000 011C {
_timer2_comp_isr:
	CALL SUBOPT_0x2
; 0000 011D // Place your code here
; 0000 011E SetOut(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _SetOut
; 0000 011F }
	RJMP _0x8C
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0123 {
_ext_int0_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0124             if(INTA && (TCCR0&7) == 0)
	SBIS 0x10,2
	RJMP _0x50
	IN   R30,0x33
	ANDI R30,LOW(0x7)
	BREQ _0x51
_0x50:
	RJMP _0x4F
_0x51:
; 0000 0125             {
; 0000 0126               TCNT0=timeReg; //Время включения 1
	LDS  R30,_timeReg
	OUT  0x32,R30
; 0000 0127               TCCR0=0x05;  //putchar(0xB1);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0128             }
; 0000 0129             phaseCounter++;
_0x4F:
	RJMP _0x8D
; 0000 012A }
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 012E {
_ext_int1_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 012F             if(INTB && (TCCR1B&7) == 0)
	SBIS 0x10,3
	RJMP _0x53
	IN   R30,0x2E
	ANDI R30,LOW(0x7)
	BREQ _0x54
_0x53:
	RJMP _0x52
_0x54:
; 0000 0130             {
; 0000 0131               TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
; 0000 0132               TCNT1L=timeReg; //Время включения 2
	LDS  R30,_timeReg
	OUT  0x2C,R30
; 0000 0133               TCCR1B=0x05;  //putchar(0xB2);
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 0134             }
; 0000 0135             phaseCounter++;
_0x52:
	RJMP _0x8D
; 0000 0136 }
;
;// External Interrupt 2 service routine
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 013A {
_ext_int2_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 013B             if(INTC && (TCCR2&7) == 0)
	SBIS 0x16,2
	RJMP _0x56
	IN   R30,0x25
	ANDI R30,LOW(0x7)
	BREQ _0x57
_0x56:
	RJMP _0x55
_0x57:
; 0000 013C             {
; 0000 013D               TCNT2=timeReg; //Время включения 3
	LDS  R30,_timeReg
	OUT  0x24,R30
; 0000 013E               TCCR2=0x07;   //putchar(0xB3);
	LDI  R30,LOW(7)
	OUT  0x25,R30
; 0000 013F             }
; 0000 0140             phaseCounter++;
_0x55:
_0x8D:
	LDS  R30,_phaseCounter
	SUBI R30,-LOW(1)
	STS  _phaseCounter,R30
; 0000 0141 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;// ADC interrupt service routine
;// with auto input scanning
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0146 {
_adc_isr:
	CALL SUBOPT_0x2
; 0000 0147 // Read the AD conversion result
; 0000 0148 
; 0000 0149 tempValue = ADCW;
	__INWR 12,13,4
; 0000 014A 
; 0000 014B // Select next ADC input
; 0000 014C     adc_rd_input = adc_wr_input + 1;
	MOV  R30,R11
	SUBI R30,-LOW(1)
	MOV  R10,R30
; 0000 014D     if(adc_rd_input > 3) adc_rd_input -= 4;
	LDI  R30,LOW(3)
	CP   R30,R10
	BRSH _0x58
	MOV  R30,R10
	LDI  R31,0
	SBIW R30,4
	MOV  R10,R30
; 0000 014E     ADMUX=(ADC_VREF_TYPE & 0xff) | adc_rd_input;
_0x58:
	MOV  R30,R10
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 014F 
; 0000 0150 
; 0000 0151 if(adc_wr_input<3) //Фазы
	LDI  R30,LOW(3)
	CP   R11,R30
	BRSH _0x59
; 0000 0152 {
; 0000 0153 tempValue -= 0x01FF;
	LDI  R30,LOW(511)
	LDI  R31,HIGH(511)
	__SUBWRR 12,13,30,31
; 0000 0154 adcValue[adc_wr_input] = tempValue;
	CALL SUBOPT_0x3
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R12
	STD  Z+1,R13
; 0000 0155 }
; 0000 0156 else //Выход
	RJMP _0x5A
_0x59:
; 0000 0157 {
; 0000 0158     OutVoltage += tempValue - 255;
	MOVW R30,R12
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	CALL SUBOPT_0x4
	CALL __CWD1
	CALL __ADDD12
	STS  _OutVoltage,R30
	STS  _OutVoltage+1,R31
	STS  _OutVoltage+2,R22
	STS  _OutVoltage+3,R23
; 0000 0159 
; 0000 015A     if(++regCounter >= COUNT_CONTROL)
	LDS  R26,_regCounter
	SUBI R26,-LOW(1)
	STS  _regCounter,R26
	CPI  R26,LOW(0x4B)
	BRSH PC+3
	JMP _0x5B
; 0000 015B     {
; 0000 015C         isEnable = (phaseCounter > 1) && (phaseCounter < 11); //Защита от частоты сети
	LDS  R26,_phaseCounter
	CPI  R26,LOW(0x2)
	BRLO _0x5C
	CPI  R26,LOW(0xB)
	BRSH _0x5C
	LDI  R30,1
	RJMP _0x5D
_0x5C:
	LDI  R30,0
_0x5D:
	STS  _isEnable,R30
; 0000 015D         if(OutVoltage < 40 && timeReg > (MIN_TIMEREG + 26)) isEnable = 0; //Защита от мин тока удержания
	CALL SUBOPT_0x4
	__CPD2N 0x28
	BRGE _0x5F
	LDS  R26,_timeReg
	CPI  R26,LOW(0x4A)
	BRSH _0x60
_0x5F:
	RJMP _0x5E
_0x60:
	LDI  R30,LOW(0)
	STS  _isEnable,R30
; 0000 015E 
; 0000 015F         if(isEnable){LED1 = 0; LED2 = 0;} else {LED1 = 1; LED2 = 1; timeReg = MIN_TIMEREG; }
_0x5E:
	LDS  R30,_isEnable
	CPI  R30,0
	BREQ _0x61
	CBI  0x12,4
	CBI  0x12,6
	RJMP _0x66
_0x61:
	SBI  0x12,4
	SBI  0x12,6
	LDI  R30,LOW(47)
	STS  _timeReg,R30
_0x66:
; 0000 0160 
; 0000 0161         if(OutVoltage < MIN_OUT_VOLTAGE){ if(timeReg < MAX_TIMEREG) timeReg++; LED1 = 1;}  //LED2 on Volt+
	CALL SUBOPT_0x4
	__CPD2N 0x4362
	BRGE _0x6B
	LDS  R26,_timeReg
	CPI  R26,LOW(0xB4)
	BRSH _0x6C
	LDS  R30,_timeReg
	SUBI R30,-LOW(1)
	STS  _timeReg,R30
_0x6C:
	SBI  0x12,4
; 0000 0162         if(OutVoltage > MAX_OUT_VOLTAGE){ if(timeReg > MIN_TIMEREG) timeReg--; LED2 = 1;}  //Для 50 герц
_0x6B:
	CALL SUBOPT_0x4
	__CPD2N 0x4AB6
	BRLT _0x6F
	LDS  R26,_timeReg
	CPI  R26,LOW(0x30)
	BRLO _0x70
	LDS  R30,_timeReg
	SUBI R30,LOW(1)
	STS  _timeReg,R30
_0x70:
	SBI  0x12,6
; 0000 0163         if(OutVoltage > (MAX_OUT_VOLTAGE+30) && timeReg > (MIN_TIMEREG+3)) timeReg-=3;
_0x6F:
	CALL SUBOPT_0x4
	__CPD2N 0x4AD4
	BRLT _0x74
	LDS  R26,_timeReg
	CPI  R26,LOW(0x33)
	BRSH _0x75
_0x74:
	RJMP _0x73
_0x75:
	LDS  R30,_timeReg
	LDI  R31,0
	SBIW R30,3
	STS  _timeReg,R30
; 0000 0164          if(timeReg != old_test) putchar(timeReg);
_0x73:
	LDS  R30,_old_test
	LDS  R26,_timeReg
	CP   R30,R26
	BREQ _0x76
	LDS  R30,_timeReg
	ST   -Y,R30
	RCALL _putchar
; 0000 0165          old_test = timeReg;
_0x76:
	LDS  R30,_timeReg
	STS  _old_test,R30
; 0000 0166          if(phaseCounter != 3) putchar(phaseCounter);
	LDS  R26,_phaseCounter
	CPI  R26,LOW(0x3)
	BREQ _0x77
	LDS  R30,_phaseCounter
	ST   -Y,R30
	RCALL _putchar
; 0000 0167         regCounter = 0;
_0x77:
	LDI  R30,LOW(0)
	STS  _regCounter,R30
; 0000 0168         OutVoltage = 0;
	STS  _OutVoltage,R30
	STS  _OutVoltage+1,R30
	STS  _OutVoltage+2,R30
	STS  _OutVoltage+3,R30
; 0000 0169         phaseCounter = 0;
	STS  _phaseCounter,R30
; 0000 016A     }
; 0000 016B     adcValue[adc_wr_input] = tempValue - 255;
_0x5B:
	CALL SUBOPT_0x3
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R12
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	ST   X+,R30
	ST   X,R31
; 0000 016C }
_0x5A:
; 0000 016D 
; 0000 016E flag = 1;
	LDI  R30,LOW(1)
	STS  _flag,R30
; 0000 016F 
; 0000 0170 // Select next ADC input
; 0000 0171 if (++adc_wr_input > 3)
	INC  R11
	LDI  R30,LOW(3)
	CP   R30,R11
	BRSH _0x78
; 0000 0172 {
; 0000 0173     adc_wr_input = 0;
	CLR  R11
; 0000 0174 }
; 0000 0175 // Delay needed for the stabilization of the ADC input voltage
; 0000 0176 delay_us(10);
_0x78:
	__DELAY_USB 53
; 0000 0177 // Start the AD conversion
; 0000 0178 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0179 }
_0x8C:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Declare your global variables here
;
;void main(void)
; 0000 017E {
_main:
; 0000 017F // Declare your local variables here
; 0000 0180 char i;
; 0000 0181 // Input/Output Ports initialization
; 0000 0182 // Port A initialization
; 0000 0183 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0184 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0185 PORTA=0x00;
;	i -> R17
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0186 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0187 
; 0000 0188 // Port B initialization
; 0000 0189 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out
; 0000 018A // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=0
; 0000 018B PORTB=0x00;
	OUT  0x18,R30
; 0000 018C DDRB=0x01;
	LDI  R30,LOW(1)
	OUT  0x17,R30
; 0000 018D 
; 0000 018E // Port C initialization
; 0000 018F // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
; 0000 0190 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T
; 0000 0191 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0192 DDRC=0xFC;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0000 0193 
; 0000 0194 // Port D initialization
; 0000 0195 // Func7=In Func6=Out Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0196 // State7=T State6=0 State5=T State4=0 State3=T State2=T State1=T State0=T
; 0000 0197 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0198 DDRD=0x50;
	LDI  R30,LOW(80)
	OUT  0x11,R30
; 0000 0199 
; 0000 019A 
; 0000 019B // Timer/Counter 0 initialization
; 0000 019C // Clock source: System Clock
; 0000 019D // Clock value: 15,625 kHz
; 0000 019E // Mode: Normal top=0xFF
; 0000 019F // OC0 output: Disconnected
; 0000 01A0 //TCCR0=0x05;
; 0000 01A1 TCNT0=0x4A;
	LDI  R30,LOW(74)
	OUT  0x32,R30
; 0000 01A2 OCR0=0xCC;
	LDI  R30,LOW(204)
	OUT  0x3C,R30
; 0000 01A3 
; 0000 01A4 // Timer/Counter 1 initialization
; 0000 01A5 // Clock source: System Clock
; 0000 01A6 // Clock value: 15,625 kHz
; 0000 01A7 // Mode: Normal top=0xFFFF
; 0000 01A8 // OC1A output: Discon.
; 0000 01A9 // OC1B output: Discon.
; 0000 01AA // Noise Canceler: Off
; 0000 01AB // Input Capture on Falling Edge
; 0000 01AC // Timer1 Overflow Interrupt: On
; 0000 01AD // Input Capture Interrupt: Off
; 0000 01AE // Compare A Match Interrupt: On
; 0000 01AF // Compare B Match Interrupt: Off
; 0000 01B0 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 01B1 //TCCR1B=0x05;
; 0000 01B2 TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
; 0000 01B3 TCNT1L=0x4A;
	LDI  R30,LOW(74)
	OUT  0x2C,R30
; 0000 01B4 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 01B5 ICR1L=0x00;
	OUT  0x26,R30
; 0000 01B6 OCR1AH=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2B,R30
; 0000 01B7 OCR1AL=0xCC;
	LDI  R30,LOW(204)
	OUT  0x2A,R30
; 0000 01B8 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 01B9 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01BA 
; 0000 01BB // Timer/Counter 2 initialization
; 0000 01BC // Clock source: System Clock
; 0000 01BD // Clock value: 15,625 kHz
; 0000 01BE // Mode: Normal top=0xFF
; 0000 01BF // OC2 output: Disconnected
; 0000 01C0 ASSR=0x00;
	OUT  0x22,R30
; 0000 01C1 //TCCR2=0x07;
; 0000 01C2 TCNT2=0x4A;
	LDI  R30,LOW(74)
	OUT  0x24,R30
; 0000 01C3 OCR2=0xCC;
	LDI  R30,LOW(204)
	OUT  0x23,R30
; 0000 01C4 
; 0000 01C5 // External Interrupt(s) initialization
; 0000 01C6 // INT0: On
; 0000 01C7 // INT0 Mode: Rising Edge
; 0000 01C8 // INT1: On
; 0000 01C9 // INT1 Mode: Rising Edge
; 0000 01CA // INT2: On
; 0000 01CB // INT2 Mode: Rising Edge
; 0000 01CC GICR|=0xE0;
	IN   R30,0x3B
	ORI  R30,LOW(0xE0)
	OUT  0x3B,R30
; 0000 01CD MCUCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x35,R30
; 0000 01CE MCUCSR=0x40;
	LDI  R30,LOW(64)
	OUT  0x34,R30
; 0000 01CF GIFR=0xE0;
	LDI  R30,LOW(224)
	OUT  0x3A,R30
; 0000 01D0 
; 0000 01D1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01D2 TIMSK=0xD7;
	LDI  R30,LOW(215)
	OUT  0x39,R30
; 0000 01D3 
; 0000 01D4 
; 0000 01D5 // USART initialization
; 0000 01D6 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01D7 // USART Receiver: On
; 0000 01D8 // USART Transmitter: On
; 0000 01D9 // USART Mode: Asynchronous
; 0000 01DA // USART Baud Rate: 38400
; 0000 01DB UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01DC UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 01DD UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01DE UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01DF UBRRL=0x67; //UBRRL=0x19;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 01E0 
; 0000 01E1 // Analog Comparator initialization
; 0000 01E2 // Analog Comparator: Off
; 0000 01E3 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01E4 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01E5 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01E6 
; 0000 01E7 // ADC initialization
; 0000 01E8 // ADC Clock frequency: 250,000 kHz
; 0000 01E9 // ADC Voltage Reference: AVCC pin
; 0000 01EA // ADC Auto Trigger Source: ADC Stopped
; 0000 01EB ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 01EC ADCSRA=0xCE;
	LDI  R30,LOW(206)
	OUT  0x6,R30
; 0000 01ED 
; 0000 01EE // SPI initialization
; 0000 01EF // SPI disabled
; 0000 01F0 SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 01F1 
; 0000 01F2 // TWI initialization
; 0000 01F3 // TWI disabled
; 0000 01F4 TWCR=0x00;
	OUT  0x36,R30
; 0000 01F5 
; 0000 01F6 // Watchdog Timer initialization
; 0000 01F7 // Watchdog Timer Prescaler: OSC/512k
; 0000 01F8 #pragma optsize-
; 0000 01F9 WDTCR=0x1D;
	LDI  R30,LOW(29)
	OUT  0x21,R30
; 0000 01FA WDTCR=0x0D;
	LDI  R30,LOW(13)
	OUT  0x21,R30
; 0000 01FB #ifdef _OPTIMIZE_SIZE_
; 0000 01FC #pragma optsize+
; 0000 01FD #endif
; 0000 01FE 
; 0000 01FF // Global enable interrupts
; 0000 0200 #asm("sei")
	sei
; 0000 0201 
; 0000 0202 putchar(0xCC);
	LDI  R30,LOW(204)
	ST   -Y,R30
	RCALL _putchar
; 0000 0203 while (1)
_0x79:
; 0000 0204       {
; 0000 0205           if(INTA)
	SBIS 0x10,2
	RJMP _0x7C
; 0000 0206           {
; 0000 0207               isRising[0] = 1;
	LDI  R30,LOW(1)
	STS  _isRising,R30
; 0000 0208               isFalling[0] = 0;
	LDI  R30,LOW(0)
	RJMP _0x89
; 0000 0209           }
; 0000 020A           else
_0x7C:
; 0000 020B           {
; 0000 020C               isRising[0] = 0;
	LDI  R30,LOW(0)
	STS  _isRising,R30
; 0000 020D               isFalling[0] = 1;
	LDI  R30,LOW(1)
_0x89:
	STS  _isFalling,R30
; 0000 020E           }
; 0000 020F           if(INTB)
	SBIS 0x10,3
	RJMP _0x7E
; 0000 0210           {
; 0000 0211               isRising[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _isRising,1
; 0000 0212               isFalling[1] = 0;
	LDI  R30,LOW(0)
	RJMP _0x8A
; 0000 0213           }
; 0000 0214           else
_0x7E:
; 0000 0215           {
; 0000 0216               isRising[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _isRising,1
; 0000 0217               isFalling[1] = 1;
	LDI  R30,LOW(1)
_0x8A:
	__PUTB1MN _isFalling,1
; 0000 0218           }
; 0000 0219           if(INTC)
	SBIS 0x16,2
	RJMP _0x80
; 0000 021A           {
; 0000 021B               isRising[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _isRising,2
; 0000 021C               isFalling[2] = 0;
	LDI  R30,LOW(0)
	RJMP _0x8B
; 0000 021D           }
; 0000 021E           else
_0x80:
; 0000 021F           {
; 0000 0220               isRising[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _isRising,2
; 0000 0221               isFalling[2] = 1;
	LDI  R30,LOW(1)
_0x8B:
	__PUTB1MN _isFalling,2
; 0000 0222           }
; 0000 0223 
; 0000 0224 
; 0000 0225       #asm("wdr")
	wdr
; 0000 0226       if(flag && rx_counter)
	LDS  R30,_flag
	CPI  R30,0
	BREQ _0x83
	TST  R7
	BRNE _0x84
_0x83:
	RJMP _0x82
_0x84:
; 0000 0227       {
; 0000 0228         getchar();
	RCALL _getchar
; 0000 0229         for(i=0; i<4; i++)
	LDI  R17,LOW(0)
_0x86:
	CPI  R17,4
	BRSH _0x87
; 0000 022A         {
; 0000 022B           putchar(adcValue[i] & 0xFF);
	CALL SUBOPT_0x5
	LD   R30,X
	ST   -Y,R30
	RCALL _putchar
; 0000 022C           putchar(adcValue[i] >> 8);
	CALL SUBOPT_0x5
	CALL __GETW1P
	CALL __ASRW8
	ST   -Y,R30
	RCALL _putchar
; 0000 022D         }
	SUBI R17,-1
	RJMP _0x86
_0x87:
; 0000 022E         flag = 0;
	LDI  R30,LOW(0)
	STS  _flag,R30
; 0000 022F       }
; 0000 0230 
; 0000 0231       }
_0x82:
	RJMP _0x79
; 0000 0232 }
_0x88:
	RJMP _0x88
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x20
_tx_buffer:
	.BYTE 0x20
_isRising:
	.BYTE 0x4
_isFalling:
	.BYTE 0x4
_adcValue:
	.BYTE 0x8
_OutVoltage:
	.BYTE 0x4
_flag:
	.BYTE 0x1
_isEnable:
	.BYTE 0x1
_timeReg:
	.BYTE 0x1
_regCounter:
	.BYTE 0x1
_phaseCounter:
	.BYTE 0x1
_old_test:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	MOV  R30,R11
	LDI  R26,LOW(_adcValue)
	LDI  R27,HIGH(_adcValue)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4:
	LDS  R26,_OutVoltage
	LDS  R27,_OutVoltage+1
	LDS  R24,_OutVoltage+2
	LDS  R25,_OutVoltage+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	MOV  R30,R17
	LDI  R26,LOW(_adcValue)
	LDI  R27,HIGH(_adcValue)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET


	.CSEG
__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

;END OF CODE MARKER
__END_OF_CODE:
