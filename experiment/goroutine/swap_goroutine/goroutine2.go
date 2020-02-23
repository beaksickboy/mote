package main

import (
	"fmt"
	"runtime"
	"sync"
)

// Demonstrate swap auto go routine
var wg sync.WaitGroup

func main() {
	// run concurrently
	runtime.GOMAXPROCS(1)
	// parallel
	runtime.GOMAXPROCS(runtime.NumCPU())

	wg.Add(2)
	fmt.Println("Start")
	go printPrime("fuck")
	go printPrime("yeah")

	wg.Wait()
	fmt.Println("done")
}

func printPrime(prefix string) {
	// Schedule the call to Done to tell main we are done.
	defer wg.Done()

next:
	for outer := 2; outer < 5000; outer++ {
		for inner := 2; inner < outer; inner++ {
			if outer%inner == 0 {
				continue next
			}
		}
		fmt.Printf("%s:%d\n", prefix, outer)
	}
	fmt.Println("Completed", prefix)
}
