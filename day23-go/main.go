package main

import (
	"container/ring"
	"fmt"
	"strings"
	"time"
)

// Input is the part 1 puzzle input
const Input = "198753462"

func contains(cur *ring.Ring, val uint64) bool {
	c := cur
	for i := 0; i < c.Len(); i++ {
		if c.Value.(uint64) == val {
			return true
		}
		c = c.Next()
	}
	return false
}

func play(input int, moves uint64) *ring.Ring {
	cur := ring.New(input)
	cache := make([]*ring.Ring, input)
	max := uint64(input)
	for i := 0; i < len(Input); i++ {
		v := uint64(Input[i]) - 48
		cur.Value = v
		cache[v-1] = cur
		cur = cur.Next()
	}

	for i := len(Input) + 1; i <= input; i++ {
		cur.Value = uint64(i)
		cache[i-1] = cur
		cur = cur.Next()
	}

	// Perform all moves
	for i := uint64(0); i < moves; i++ {
		removed := cur.Unlink(3)
		next := cur.Value.(uint64)

		for {
			next--
			if next == 0 {
				next = max
			}

			if !contains(removed, next) {
				break
			}
		}

		cache[next-1].Link(removed)

		cur = cur.Next()
	}
	// Return ring pointer at the 1 cup
	return cache[1-1]
}

func cupsString(cur *ring.Ring) string {
	var out strings.Builder
	cur.Do(func(v interface{}) {
		if v.(uint64) != 1 {
			_, _ = fmt.Fprintf(&out, "%d", v.(uint64))
		}
	})
	return out.String()
}

func main() {
	// Part 1
	startTime := time.Now()
	fmt.Println("P1", cupsString(play(9, 100)), "took", time.Since(startTime))

	// Part 2
	startTime = time.Now()
	o := play(1_000_000, 10_000_000)
	fmt.Println("P2", o.Next().Value.(uint64)*o.Next().Next().Value.(uint64), "took", time.Since(startTime))
}
