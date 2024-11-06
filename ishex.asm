.list
#include      macros.inc

              proc      ishex

              plo       re             ; keep a copy
              smi       '0'            ; convert to binary
              lbnf      error          ; jump if too low
              smi       10             ; check high range of numbers
              lbnf      isnum          ; jump if numeral
              glo       re             ; recover character
              smi       'A'            ; check if below uppercase
              lbnf      error          ; jump if too low
              smi       6              ; check for A-F
              lbnf      isuc           ; jump if uppercase
              glo       re             ; recover character
              smi       'a'            ; check if below uppercase
              lbnf      error          ; jump if too low
              smi       6              ; check for A-F
              lbnf      islc           ; jump if uppercase
error:        smi       0              ; signal not hex character
              rtn                      ; and return
isnum:        glo       re             ; recover character
              smi       '0'            ; convert to binary
              adi       0              ; signal no error
              rtn                      ; and return
isuc:         glo       re             ; recover character
              smi       55             ; convert to binary
              adi       0              ; signal no error
              rtn                      ; and return
islc:         glo       re             ; recover character
              smi       87             ; convert to binary
              adi       0              ; signal no error
              rtn                      ; and retrn

              endp

