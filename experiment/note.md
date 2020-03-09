
# Logical core vs Physical core
- Physical core are actual physical core
- Logical core = numb physical core * numb thread

Concurrency in Go is the ability for functions to run independent of each other.

> Parallelism is about doing a lot of things at once. Concurrency is about managing a lot of things at once 

- When a function is created as a goroutine, it’s treated as an independent unit of
work that gets scheduled and then executed on an available logical processor.
- Go runtime scheduler is a sophisticated piece of software that manages all
the goroutines that are created and need processor time

- The scheduler sits on top of the operating system, binding operating system’s threads to logical processors which, in turn, execute goroutines

-  CSP is a message-passing model that works by communicating data between goroutines instead of locking data to synchronize access.

- thread is a path of execution that’s scheduled by the operating system to run the code that you write in your functions

- Each `process contains at least one thread`, and the initial thread for each process is
called the main thread

- When the main thread terminates, the application terminates, because this path of the execution is the origin for the application

-  The operating system schedules threads to run against physical processors and the
Go runtime schedules goroutines to run against logical processors

- Each `logical processor` is individually` bound to a single operating system thread`.

- As goroutines are created and ready to run, they’re placed in the scheduler’s global run queue. Soon after, they’re assigned
to a logical processor and placed into a local run queue for that logical processor.

- From there, a goroutine waits its turn to be given the logical processor for execution. 

-  If a goroutine needs to make a network I/O call, the process is a bit different. In
this case, the goroutine is detached from the logical processor and moved to the runtime integrated network poller. Once the poller indicates a read or write operation is
ready, the goroutine is assigned back to a logical processor to handle the operation.

https://morsmachine.dk/netpoller

https://povilasv.me/go-scheduler/

- Based on the internal algorithms of the scheduler, a running goroutine can be
stopped and rescheduled to run again before it finishes its work. The scheduler does
this to prevent any single goroutine from holding the logical processor hostage. It will
stop the currently running goroutine and give another runnable goroutine a chance
to run. 


# Dectect go race condition
> go run -race filename.go

# Need to serialize access to an integer variable or a block of code
> atomic and sync packages may be a good solution

# Unbuffered channel
- channel with no capacity to hold any value before it’s received

# Buffered channel
- channel with capacity to hold one or more values before they’re received.

- don’t force goroutines to be ready at the same instant to perform sends and receives

- A receive will block only if there’s no value in the channel
to receive. A send will block only if there’s no available buffer to place the value being
sent

 This leads to the one big difference between unbuffered and buffered channels:
An unbuffered channel provides a guarantee that an exchange between two goroutines is performed at the instant the send and receive take place. A buffered channel
has no such guarantee

Channels provide an intrinsic way to safely share data between two goroutines.
 Unbuffered channels provide a guarantee between an exchange of data. Buffered channels do not.

go routine are user space thread, create and manage by go runtime, not the os lightweight compared to the os thread


Design your program as a collection of independent process
Design these process to eventually run in parallel

Design your code so the outcome alway the same(dequential or parallel)



# Must Read
https://blog.golang.org/godoc-documenting-go-code

Concurrency is not parallesm
https://www.youtube.com/watch?v=YEKjSzIwAdA&t=409s