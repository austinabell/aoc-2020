instructions = readlines("input.txt")

function runProgram(swap::Int64)::Tuple{Int64, Set{Int64}, Bool}
    run = Set{Int64}()
    swapable = Set{Int64}()
    accu = 0
    pc = 1
    
    while pc <= length(instructions)
        # Check if instruction has been run before
        if in(pc, run)
            return accu, swapable, false
        else
            push!(run, pc)
        end
        
        (name, val) = split(instructions[pc], " ")
        iv = parse(Int64, val)

        if swap == pc
            if name == "jmp"
                name = "nop"
            elseif name == "nop"
                name = "jmp"
            end
        end

        if name == "acc"
            accu += iv
        elseif name == "jmp"
            push!(swapable, pc)
            pc += iv
            continue
        elseif name == "nop"
            push!(swapable, pc)
        else
            println("unknown instruction: ", name)
        end
        pc += 1
    end

    return accu, swapable, true
end

# Run program without swaps, to get pc indices that can be swapped (jmp, nop)
# The logic of instructions can be deduplicated by spawning tasks or only forking the
# computation when each instruction is met. Maybe I'll come back to this, but the program rn runs
# instantly so it doesn't matter.
(accu, swapable, _) = runProgram(-1)

# Part 1
println("P1: ", accu)

for swap in swapable
    local (accu, _, halt) = runProgram(swap)
    if halt
       println("P2: ", accu)
       break
    end
end

