;***************************************************************;
;*			Boot1.asm-			       *;
;*			Simple bootloader as a test of sockeye *;
;*							       *;
;***************************************************************;

bits	16						;You are still in 16 bit real mode

org		0x7c00

start:		jmp loader

;******************************************;
;		OEM Parameter Block       *;
;******************************************;
TIMES 0Bh-$+start DB 0

bpbBytesPerSector:     DW 512
bpbSectorsPerCluster:   DB 1
bpbReservedSectors:     DW 1
bpbNumberOfFATs:            DB 2
bpbRootEntries:             DW 224
bpbTotalSectors:            DW 2880
bpbMedia:                   DB 0xF0
bpbSectorsPerFAT:           DW 9
bpbSectorsPerTrack:     DW 18
bpbHeadsPerCylinder:    DW 2
bpbHiddenSectors:          DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber:          DB 0
bsUnused:                  DB 0
bsExtBootSignature:     DB 0x29
bsSerialNumber:         DD 0xa0a1a2a3
bsVolumeLabel:          DB "MOS FLOPPY "
bsFileSystem:           DB "FAT12   "


msg	db	"Welcome to the sockeye operating system!",0

;*********************************************
;		Prints a string		     *
;		DS=>si: 0 terminated string  *
;*********************************************

Print:
		lodsb
		or		al, al		;al=current char
		jz		PrintDone
		mov		ah,	0eh
		int		10h
		jmp		Print
PrintDone:
		ret

;****************************************;
;--------------Bootloader entry point---*;
;****************************************;
loader:

;ERROR FIX ONE --------------------------------------------
	
	xor	ax, ax		; Setup segements to insure they are all zero. Remember that
	mov	ds, ax		; we have ORG 0x7c00. This means all addresses are based 
	mov	es, ax		; from 0x7c00:0. Because the data segments are within the same
				; code segment, null em.
	mov	si, msg	
	call	Print
	
	xor	ax, ax		;clear ax
	int 0x12		;Get KB from the BIOS

	cli			; Clear all Interrupts
	hlt			; Bring the system to a halt

times 510 - ($-$$) db 0		; We have to be 512 bytes. Clear the rest of the bytes with 0

dw 0xAA55			;Boot sig