program main
  implicit none

  integer :: ios
  logical, dimension(1024) :: seats
  character(len = 10) :: line
  integer(kind = 8) :: row_low, row_high, max
  integer(kind = 4) :: index, col_low, col_high, i

  max = 0
  do i=1,1024
    seats(i) = .false.
  end do

  open(10, file='input.txt', action='read')

  do
    read(10, *, iostat=ios) line
    if (ios /= 0) exit

    row_low = 0
    row_high = 127
    col_low = 0
    col_high = 7
    index = 0

    do while (index < 7)
      if (line(index+1:index+1) == "F") then
        row_high = row_high - ((row_high - row_low)/2) - 1
      else
        row_low = row_low + ((row_high - row_low)/2) + 1
      end if
      index = index + 1
    end do

    do while (index < 10)
      if (line(index+1:index+1) == "L") then
        col_high = col_high - ((col_high - col_low)/2) - 1
      else
        col_low = col_low + ((col_high - col_low)/2) + 1
      end if
      index = index + 1
    end do
    
    if ((row_low*8)+col_low > max) then
      max = (row_low*8)+col_low
    end if
    ! lmao Fortran starts inidices at 1
    seats((row_low*8)+col_low + 1) = .true.
  end do

  print *, "MAX:", max
  ! print *, seats

  i = 1
  do while (seats(i) .eqv. .false.)
    i = i + 1
  end do

  do while (i < 1024)
    if (seats(i) .eqv. .false.) then
      print *, "SEAT:", i - 1
      exit
    end if
    i = i + 1
  end do
end program main
