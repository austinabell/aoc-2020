       IDENTIFICATION DIVISION.
       PROGRAM-ID. aoc-day12-p1.
      
       ENVIRONMENT DIVISION.
           INPUT-OUTPUT SECTION.
               FILE-CONTROL.
               SELECT INPUTF ASSIGN TO "input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
           FD INPUTF
           RECORD IS VARYING IN SIZE FROM 1 to 4
           DEPENDING ON LINE-LEN.
               01 INPUTRECORD.
               05 INPUT-ACTION PIC X.
               05 INPUT-ARG PIC 9(3).

       WORKING-STORAGE SECTION.
           01 FSTATUS PIC 9 VALUE 0.
           01 LINE-LEN PIC 9 COMP.
           01 NORTH CONSTANT AS 'N'.
           01 EAST CONSTANT AS 'E'.
           01 SOUTH CONSTANT AS 'S'.
           01 WEST CONSTANT AS 'W'.
           01 LE CONSTANT AS 'L'.
           01 RI CONSTANT AS 'R'.
           01 FORWARD CONSTANT AS 'F'.
           01 CURR-DIR PIC X VALUE EAST.
           01 X PIC S9(8) VALUE ZERO.
           01 Y PIC S9(8) VALUE ZERO.
           01 TMP PIC S9(8) VALUE ZERO.
           01 ARG PIC S9(3) VALUE ZERO.

       PROCEDURE DIVISION.
       MAIN.
           OPEN INPUT INPUTF.
           PERFORM FILE-READ UNTIL FSTATUS = 1.
           CLOSE INPUTF.
           COMPUTE TMP = FUNCTION ABS(X) + FUNCTION ABS(Y).
           DISPLAY TMP.
           STOP RUN.

       FILE-READ.
           READ INPUTF
               AT END MOVE 1 TO FSTATUS
               NOT AT END PERFORM HANDLE-LINE
           END-READ.
       
       HANDLE-LINE.
           COMPUTE ARG = FUNCTION NUMVAL(INPUT-ARG)
           IF INPUT-ACTION = FORWARD THEN
               MOVE CURR-DIR TO INPUT-ACTION
           END-IF.

           IF INPUT-ACTION = NORTH OR INPUT-ACTION = SOUTH
               OR INPUT-ACTION = EAST OR INPUT-ACTION = WEST THEN 
               PERFORM HANDLE-MOVE
               EXIT PARAGRAPH
           END-IF.

           *> rotating, value needs to be divided by 90 to handle deg
           COMPUTE TMP = ARG / 90.
           IF INPUT-ACTION = RI THEN
               PERFORM ROR TMP TIMES
           ELSE 
               PERFORM ROL TMP TIMES
           END-IF.

       ROR.
           EVALUATE CURR-DIR
           WHEN NORTH
               MOVE EAST TO CURR-DIR
           WHEN EAST
               MOVE SOUTH TO CURR-DIR
           WHEN SOUTH
               MOVE WEST TO CURR-DIR
           WHEN WEST
               MOVE NORTH TO CURR-DIR
           END-EVALUATE.

       ROL.
           EVALUATE CURR-DIR
           WHEN NORTH
               MOVE WEST TO CURR-DIR
           WHEN EAST
               MOVE NORTH TO CURR-DIR
           WHEN SOUTH
               MOVE EAST TO CURR-DIR
           WHEN WEST
               MOVE SOUTH TO CURR-DIR
           END-EVALUATE.

       HANDLE-MOVE.
           EVALUATE INPUT-ACTION
           WHEN NORTH
               COMPUTE Y = Y - ARG
           WHEN EAST
               COMPUTE X = X + ARG
           WHEN SOUTH
               COMPUTE Y = Y + ARG
           WHEN WEST
               COMPUTE X = X - ARG
           END-EVALUATE.
