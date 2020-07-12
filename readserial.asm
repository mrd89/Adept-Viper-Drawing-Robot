.PROGRAM readserial()

		; ************************************************************************************
        ; Written by: Matthew Daniel
		; email: mrd89@corell.edu
		; Last updated: 2019-DEC
		; connects to the serial port and takes in two variables at a time and places them into a
		; serial buffer of size 1000
        ; ************************************************************************************


        ; defining buffer
        GLOBAL REAL bufferx
        GLOBAL REAL buffery
        GLOBAL REAL tail
        GLOBAL REAL head
        GLOBAL REAL size
        GLOBAL REAL isfull
        GLOBAL REAL isempty


        ; receive data declarations
        AUTO slun
        AUTO $temp
        LOCAL REAL value
        LOCAL $string_input


        ;setup 

        ;allow buffer size and allocate
        size = 1000 ;
        bufferx[size] = 0  ;
        buffery[size] = 0  ;

        ;head and tail declarations
        head = 0 ;
        tail = 0
        isfull = 0 ;
        isempty = 1 ;



        ; loop that program will always run
        WHILE TRUE DO

            $temp = " "       ; reset temp

            ATTACH (slun, 4) "serial:1"       ;connect to serial 1
            IF IOSTAT(slun) < 0 GOTO 100 ;error collection message

            READ (slun) $string_input ; reads serial port
            nparams = 0       ;reset array index

            DO
                $temp = $DECODE($string_input," ,",0) ;
                value[nparams] = VAL($temp) ;
                $temp = $DECODE($string_input," ,",1) ;Discard spaces and commas
                nparams = nparams+1
            UNTIL $string_input == "" ;


            ; if the input was correct syntax and is NOT full
            IF ((nparams == 2) AND (isfull == 0)) THEN

            ; add values to buffer
                bufferx[head] = value[0]
                buffery[head] = value[1]

            ; added a value to buffer, therefore not full
                isempty = 0


            ;finds next head position, if at end of buffer, go to 0, else add one
                IF ((head+1) == size) THEN
                    head = 0
                ELSE
                    head = head+1
                END


            ;if head=tail while inserting, must be full
                IF (head == tail) THEN
                    isfull = 1
                END

            END




; ERROR COLLECTION
 100        IF (IOSTAT(slun) < 0) THEN

            ;used to test errors
            ;TYPE IOSTAT(slun), " ", $ERROR(IOSTAT(slun))
            END



            DETACH (slun) ;detach the serial
        END ;end of main while loop




.END




