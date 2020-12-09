#!/bin/bash

input=( `cat "input.txt" `)

inLen=${#input[@]}

invalid=-1

# Part 1
# for (( i=25; i<$inLen; i++ ));
# do
#     valid=false
#     for (( j=1; j<=24; j++ ));
#     do
#         for (( k=j+1; k<=25; k++ ));
#         do
#             sum=$((input[$i - $j] + input[$i - $k]))
#             if [ $sum -eq ${input[$i]} ]
#             then
#                 valid=true
#                 break 2
#             fi
#         done
#     done

#     if [ $valid == false ]
#     then
#         echo "Invalid at $i ${input[$i]}"
#         invalid=$i
#     fi
# done
# echo "i $invalid"

# Part 2
invalid=498
left=0
right=1
invalid_val=${input[$invalid]}
sum=$(( ${input[$left]}+${input[$right]} ))

while [ $right -lt $invalid_val ]
do
    if [ $sum -lt $invalid_val ]
    then
        ((right++))
        ((sum+=${input[$right]}))
    elif [ $sum -gt $invalid_val ]
    then
        ((sum-=${input[$left]}))
        ((left++))
    else

        break
    fi
done

min=${input[$left]}
max=${input[$left]}
slLen=$(( $right - $left ))
for n in "${input[@]:$left:$slLen}" ; do
    ((n > max)) && max=$n
    ((n < min)) && min=$n
done

echo "max + min = $(( $max + $min ))"
