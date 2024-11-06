.list
#include      bios.inc
#include      kernel.inc
#include      macros.inc

              proc      scandir

              extrn     addname
              extrn     delname
              extrn     dta
              extrn     scanfile
              extrn     sector

auloop:       push      r8             ; save lump number
              push      r7
              call      o_lmptosec     ; convert to sector
sectorloop:   mov       rf,sector      ; point to sector address
              ghi       r8             ; store sector
              str       rf
              inc       rf
              glo       r8
              str       rf
              inc       rf
              ghi       r7
              str       rf
              inc       rf
              glo       r7
              str       rf
              mov       rf,dta         ; point to dta
              call      d_ideread      ; read directory sector
              mov       rf,dta         ; point to beginning of sector
              ldi       16             ; 16 entries in sector
              plo       rc
loop:         mov       ra,rf          ; copy current address
              lda       ra             ; see if entry is active
              lbnz      active         ; jump if so 
              lda       ra             ; check remaining bytes
              lbnz      active
              lda       ra
              lbnz      active
              lda       ra
              lbz       next           ; next entry if inactive
active:       push      r8             ; save values
              push      r7
              push      rf
              push      rc
subcall:      call      scanfile       ; check the file
              pop       rc             ; recover values
              pop       rf
              pop       r7
              pop       r8
              mov       ra,rf          ; need to get file flags
              inc       ra             ; move to flags
              inc       ra
              inc       ra
              inc       ra
              inc       ra
              inc       ra
              ldn       ra             ; get flags
              ani       1              ; check for subdirector
              lbz       next           ; jump if not a directory
              call      addname
              push      rf
              push      rc
              push      r8
              push      r7
              lda       rf             ; retrieve starting lump
              phi       r8
              lda       rf
              plo       r8
              lda       rf
              phi       r7
              lda       rf
              plo       r7
              call      scandir        ; scan the subdirectory
              call      delname        ; remove name from path
              pop       r7             ; recover current sector
              pop       r8
              mov       rf,dta         ; point to dta
              call      f_ideread      ; read sector back in
              pop       rc             ; recover remaining registers
              pop       rf
next:         glo       rf             ; move to next entry
              adi       32
              plo       rf
              ghi       rf
              adci      0
              phi       rf
              dec       rc             ; decrement count
              glo       rc             ; check for done with sector
              lbnz      loop           ; loop if more entries to check
              glo       r7             ; get low byte of sector
              ani       7              ; see if on last sector
              smi       7              ; were we on last sector
              lbz       nextau         ; jump if end of au
              inc       r7             ; increment sector
              lbr       sectorloop     ; and check next sector
nextau:       pop       r7             ; recover current lump
              pop       r8
              call      o_rdlump32     ; read next lump
              ghi       r8             ; zero check read lump
              str       r2
              glo       r8
              or
              str       r2
              ghi       r7
              or
              str       r2
              glo       r7
              or
              lbz       alldone        ; jump if no valid lump
              ghi       r8             ; check for last lump
              lbnz      auloop         ; process next lump if not last
              glo       r8
              lbnz      auloop
              ghi       r7
              smi       0feh
              lbnz      auloop
              glo       r7
              smi       0feh
              lbnz      auloop
alldone:      rtn                      ; return to caller

              public    subcall

              endp

