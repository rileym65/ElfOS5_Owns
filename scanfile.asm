.list
#include      bios.inc
#include      kernel.inc
#include      macros.inc

; ***************************************************
; ***** RF - pointer to DIRENT for file to scan *****
; ***************************************************
              proc      scanfile

              extrn     lump
              extrn     path

              glo       rf             ; point to filename
              adi       12
              plo       rd
              ghi       rf
              adci      0
              phi       rd

              lda       rf             ; retrieve starting lump
              phi       r8
              lda       rf
              plo       r8
              lda       rf
              phi       r7
              lda       rf
              plo       r7
auloop:       mov       rf,lump        ; point to lump to check
              ghi       r8             ; and compare to current lump
              str       r2
              lda       rf
              sm
              lbnz      continue
              glo       r8
              str       r2
              lda       rf
              sm
              lbnz      continue
              ghi       r7
              str       r2
              lda       rf
              sm
              lbnz      continue
              glo       r7
              str       r2
              lda       rf
              sm
              lbnz      continue
              mov       rf,path        ; point to path
              call      o_msg          ; display it
              ldi       19             ; maximum 19 characters to display
              plo       rc
nameloop:     lda       rd             ; get byte from name
              lbz       done           ; jump if done
              call      o_type         ; send to output
              dec       rc             ; decrement count
              glo       rc             ; see if end of name
              lbnz      nameloop       ; jump if not
done:         call      o_inmsg        ; display crlf
              db        10,13,0
              rtn                      ; and return to caller
continue:     call      o_rdlump32     ; read lump value
              ghi       r8             ; zero check value
              str       r2
              glo       r8
              or
              str       r2
              ghi       r7
              or
              str       r2
              glo       r7
              or
              lbz       return         ; 0 is not a valid value
              ghi       r8             ; check for $ffffffff
              smi       0ffh
              lbnz      goodlump
              glo       r8
              smi       0ffh
              lbnz      goodlump
              ghi       r7
              smi       0ffh
              lbnz      goodlump
              glo       r7
              smi       0ffh
              lbz       return
goodlump:     ghi       r8             ; check for final lump
              str       r2
              glo       r8
              or
              lbnz      auloop         ; jump if not last lump
              ghi       r7
              smi       0feh
              lbnz      auloop 
              glo       r7
              smi       0feh
              lbnz      auloop 
return:       rtn                      ; and return to caller

              endp

