package main

import (
	"fmt"
	"runtime"
	"sync"
	"sync/atomic"
)

// race condition

var (
	// Increment by all go routine
	counter int64
	wg      sync.WaitGroup
)

func main() {
	// Add a count of two, one for each goroutine.
	wg.Add(2)

	// Create two goroutines.
	go incCounter(1)
	go incCounter(2)

	// Wait for the goroutines to finish.
	wg.Wait()
	fmt.Println("Final Counter:", counter)
}

// incCounter increments the package level counter variable.
func incCounter(id int) {
	// Schedule the call to Done to tell main we are done.
	defer wg.Done()

	for count := 0; count < 50000; count++ {
		// Capture the value of Counter.
		atomic.AddInt64(&counter, 1)

		// Yield the thread and be placed back in queue.
		runtime.Gosched()
	}
}
