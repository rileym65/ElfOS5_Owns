.list
#include      macros.inc
              
              proc      delname

              extrn     path

              push      rf             ; save consumed register
              mov       rf,path        ; point to path
loop1:        lda       rf             ; look for end
              lbnz      loop1
              dec       rf             ; move to byte before terminator
              dec       rf
              dec       rf             ; before slash
loop2:        ldn       rf             ; need to find a slash
              smi       '/'            ; look for slash
              lbz       done           ; jump if found
              dec       rf             ; point to prior character
              lbr       loop2          ; and keep looking
done:         inc       rf             ; move past slash
              ldi       0              ; write terminator
              str       rf
              pop       rf             ; recover consumed register
              rtn                      ; and return

              endp

