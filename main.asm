.list
#include      bios.inc
#include      kernel.inc
#include      macros.inc

              org       $2000

              extrn     dta
              extrn     ishex
              extrn     scandir

begin:        br        start          ; jump past version data
              eever
              db        'by Michael H. Riley',0
start:        mov       rf,K_VER       ; get kernel version
              lda       rf
              smi       5              ; must be 5+
              lbdf      start2         ; jump if valid version
              call      o_inmsg        ; display error
              db        'Requires Elf/OS 5+',10,13,0
              ldi       014h           ; set return code
              rtn                      ; return to caller
start2:       mov       rd,ra
              ldi       0              ; zero lump accumulator
              phi       rb
              plo       rb
              phi       ra
              plo       ra
argloop:      lda       rd             ; get byte from command line
              lbz       usage          ; jump to usage of no arg found
              smi       ' '            ; move past any spaces
              lbz       argloop        ; jump if space
              dec       rd             ; back to non-space
hexloop:      lda       rd             ; get next character
              lbz       donearg        ; jump if end of args
              call      ishex          ; is character a hex character
              lbdf      argerror       ; jump if no good
              plo       re             ; set value aside
              ldi       4              ; need 4 shifts
              plo       rc
shiftloop:    glo       ra             ; perform shift
              shl
              plo       ra
              ghi       ra
              shlc
              phi       ra
              glo       rb
              shlc
              plo       rb
              ghi       rb
              shlc
              phi       rb
              dec       rc             ; decrement count
              glo       rc             ; see if done
              lbnz      shiftloop      ; loop until 4 shifts done
              glo       re             ; recover new nybble
              str       r2             ; store for combine
              glo       ra             ; get low byte
              or                       ; and combine with new digit
              plo       ra
              lbr       hexloop        ; loop until no more characters
usage:        call      o_inmsg        ; display error
              db        'Usage: owns lumpnumber',10,13,0
              ldi       $0a            ; set return code
              rtn                      ; and return to caller
argerror:     call      o_inmsg        ; display error
              db        'Invalid option',0
              ldi       $09            ; set return code
              rtn                      ; and return
donearg:      mov       rf,lump        ; where to store lump
              ghi       rb             ; save lump
              str       rf
              inc       rf
              glo       rb
              str       rf
              inc       rf
              ghi       ra
              str       rf
              inc       rf
              glo       ra
              str       rf
              inc       rf
              mov       r8,0e000h      ; need to read sector 0
              mov       r7,0
              mov       rf,dta
              call      d_ideread
              mov       rf,dta+012ch   ; point to md
              lda       rf             ; read starting lump of md
              phi       r8
              lda       rf
              plo       r8
              lda       rf
              phi       r7
              lda       rf
              plo       r7
              call      scandir        ; scan filesystem
              rtn

path:         db        '/',0
              ds        1024
lump:         dw        0,0

              public    lump
              public    path

              end       begin

