       IDENTIFICATION DIVISION.
       PROGRAM-ID. aoc-day12-p2.
      
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
           01 X PIC S9(8) VALUE ZERO.
           01 Y PIC S9(8) VALUE ZERO.
           01 WX PIC S9(8) VALUE 10.
           01 WY PIC S9(8) VALUE 1.
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

           EVALUATE INPUT-ACTION
           WHEN FORWARD
               COMPUTE X = X + WX * ARG
               COMPUTE Y = Y + WY * ARG
           WHEN NORTH
               COMPUTE WY = WY + ARG
           WHEN EAST
               COMPUTE WX = WX + ARG
           WHEN SOUTH
               COMPUTE WY = WY - ARG
           WHEN WEST
               COMPUTE WX = WX - ARG
           WHEN RI
               COMPUTE TMP = ARG / 90
               PERFORM ROR TMP TIMES
           WHEN LE
               COMPUTE TMP = ARG / 90
               PERFORM ROL TMP TIMES
           END-EVALUATE.

       ROR.
           COMPUTE TMP = -WX.
           MOVE WY TO WX.
           MOVE TMP TO WY.

       ROL.
           COMPUTE TMP = -WY.
           MOVE WX TO WY.
           MOVE TMP TO WX.
