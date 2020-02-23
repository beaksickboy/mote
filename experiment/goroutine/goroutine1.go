package main

import (
	"fmt"
	"runtime"
	"sync"
)

/*
Single logical processor

program that creates two goroutines that display the English alphabet with lower and uppercase letters
in a concurrent
*/

func main() {
	// Use one logical processor
	runtime.GOMAXPROCS(1)

	var wg sync.WaitGroup

	// Wait 2 goroutines to finish
	wg.Add(2)

	fmt.Println("Start goroutines")

	go func() {
		defer wg.Done()
		for count := 0; count < 3; count++ {
			for char := 'a'; char < 'a'+26; char++ {
				fmt.Printf("%c ", char)
			}
		}
	}()

	go func() {
		defer wg.Done()
		for count := 0; count < 3; count++ {
			for char := 'a'; char < 'a'+26; char++ {
				fmt.Printf("%c ", char)
			}
		}
	}()

	fmt.Println("Wait to finish")
	wg.Wait()

	fmt.Println("Done")

}
