.list
#include      macros.inc

              proc      addname

              extrn     path
              
              push      rf             ; save consumed registers
              push      rd
              push      rc
              glo       rf             ; move to filename
              adi       12
              plo       rc
              ghi       rf
              adci      0
              phi       rc
              mov       rd,path        ; point to path
loop1:        lda       rd             ; find end
              lbnz      loop1
              dec       rd             ; move back
loop2:        lda       rc             ; get byte from filename
              lbz       done1          ; jump if terminator
              str       rd             ; store into path
              inc       rd
              lbr       loop2          ; loop until copy done
done1:        ldi       '/'            ; need slash
              str       rd             ; place into path
              inc       rd
              ldi       0              ; then terminate
              str       rd
              pop       rc             ; recover consumed registers
              pop       rd
              pop       rf
              rtn                      ; return to caller

              endp

