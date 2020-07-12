.PROGRAM bufferdraw()


		; ************************************************************************************
        ; Written by: Matthew Daniel
		; email: mrd89@corell.edu
		; Last updated: 2020-Feb
		; this program uses the buffer from readserial() and moves the robot to given points
		; calibration must be done before running this program
        ; ************************************************************************************



		;location variables
        AUTO LOC temploc
        AUTO LOC shiftedpos
        AUTO LOC initdraw
        AUTO REAL tmp[5]
        AUTO REAL pploc[5]



		; movement variables
        AUTO REAL dy, dz
        AUTO LOC movetopos
        AUTO REAL dist
        AUTO REAL currSpeed


        ; calibration to create plane location
        AUTO REAL rightop[5]
        AUTO REAL rightbottom[5]
        AUTO REAL leftbottom[5]

		; initial var used / scaling
        AUTO REAL yscale
        AUTO REAL zscale
        AUTO REAL x0
        AUTO REAL y0
        AUTO REAL z0


		; variables used intermediate calculations
        AUTO REAL xyscale
        AUTO REAL xzscale

        AUTO REAL currx
        AUTO REAL isdrawing
        AUTO REAL newy
        AUTO REAL newz





        isdrawing = 0 ; says pen is not drawing at first



        ; ************************************************************************************
        ; Moving robot slowly to each corner of the drawing board slowly
		; Calibration MUST be done before running this portion of the program
        ; ************************************************************************************
        SPEED 30 ALWAYS
        SPEED 10
        MOVES #initcalibrate
        SPEED 10
        MOVES #leftbottom
        DELAY 0.75
        DECOMPOSE leftbottom[] = HERE
        SPEED 50
        MOVES #initcalibrate
        SPEED 10
        MOVES #rightbottom
        DELAY 0.75
        DECOMPOSE rightbottom[] = HERE
        SPEED 50
        MOVES #initcalibrate
        SPEED 10
        MOVES #righttop
        DELAY 0.75
        DECOMPOSE righttop[] = HERE
        DELAY 0.1
        MOVES #initcalibrate
        DELAY 0.4
        DECOMPOSE tmp[] = HERE


        ; calculate plane based on 3 points given
        yscale = (righttop[1]-leftbottom[1])/2
        zscale = (righttop[2]-leftbottom[2])/2
        y0 = (righttop[1]+leftbottom[1])/2
        z0 = (righttop[2]+leftbottom[2])/2


        ; finds difference in the x direction between the two
        xyscale = (rightbottom[0]-leftbottom[0])/2
        xzscale = (righttop[0]-rightbottom[0])/2

        x0 = leftbottom[0]+xyscale+xzscale

        MOVE TRANS(x0,y0,z0,tmp[3],tmp[4],tmp[5])
        DELAY 0.5
        SET initdraw = HERE
		
		; move pen away from board 
        MOVE SHIFT(HERE BY -20)




        ; ************************************************************************************
        ; Main program starts here
        ; ************************************************************************************

        WHILE TRUE DO ;l1

            IF ((isempty == 0)) THEN ;l2

                IF ((bufferx[tail] == 10101) AND (buffery[tail] == 10102)) THEN ;l3


                    DECOMPOSE tmp[] = HERE
                    IF (isdrawing == 1) THEN
                        MOVE SHIFT(HERE BY -20)  ; when not writing move back 20mm

                    END

                    ; let program know that the pen is not touching wall
                    isdrawing = 0


                ELSE ; this means robot should move


                    ; check if the pen was drawing last turn, if it was, do normal thing
                    ; if isdrawing =0, move to position translated by -20

                    DECOMPOSE tmp[] = HERE
                    newy = bufferx[tail]*yscale+y0
                    newz = buffery[tail]*zscale+z0


                    dy = tmp[1]-newy
                    dz = tmp[2]-newz

                    xcurr = x0+xyscale*bufferx[tail]+xzscale*buffery[tail]

                ; add pploc[0] to be dx 
                    SET movetopos = TRANS(xcurr,newy,newz,tmp[3],tmp[4],tmp[5])

                    ; ******************************************
                    ; determine and calculate an appropriate speed based on 
					; the distance needed to travel between points
                    ; ******************************************
                    dist = SQRT(dy*dy+dz*dz)

                    IF (dist < 5) THEN ;l5
                        randi = RANDOM*10

                        IF (randi < 9) THEN ;l6
                            currSpeed = 10
                        END ;l6

                    ELSE
                        currSpeed = 25+3*dist
                        IF (currSpeed > 95) THEN
                            currSpeed = 80
                        END

                    END l5





                        ; ******************************************
                        ; check if the robot needs to translate its movement
                        ; due to the isdrawing command
                    IF (isdrawing == 1) THEN ;l4

						; Move to next location
                        SPEED currSpeed
                        MOVES movetopos

                    ELSE 
					
						; move to new pose -20mm x
					
                        SET shiftedpos = movetopos ; save final pose

                        SPEED currSpeed
                        MOVES SHIFT(shiftedpos BY -20) ; move to shifted location
						
						; slowly approach the wall to begin drawing again
                        SPEED 20
                        MOVES movetopos


                    END ;l4

                    isdrawing = 1 ;since it moved to board, it is drawing

                END ;l3




                isfull = 0 ;


            ; moves tail position
                IF ((tail+1) == size) THEN
                    tail = 0
                ELSE
                    tail = tail+1
                END ;end of moving tail position

                IF (tail == head) THEN
                    isempty = 1 ;
                END



            END          ;end of if isempty statement , l2




        END ;end for while true ;l1


.END

