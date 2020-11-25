#  GCD & Operations

## Grand Central Dispatch
Its purpose is to queue up *tasks* - either a method or a closure - that can be run in parallel, depending on availability of resources; it then executes the tasks on an available processor core.

All of the tasks that GCD manages for you are placed into GCD-managesd first-in, first-out (FIFO) queues.

### Synchronous and asynchronous tasks
When running a task synchronously, the app will wait and block the current run loop until execution finishes before moving on to the next task. Alternatively, a task that is run asynchronously will start, but return execution to the app immediately.

In general, you'll want to take any long-running non-UI task that you can find and make it run asynchronously in the background.

```
// Class level variable
let queue = DispatchQueue(label: "com.anujrajput.worker")

// Somewhere in the function
queue.async {
    // Call slow non-UI methods here
    
    DispatchQueue.main.async {
        // Update the UI here
    }
}
```

### Serial and concurrent queues
Serial queues only have a single thread associated with them and thus only allow a single task to be executed at any given time.

A concurrent queue, on the other hand, is able to utilize as many threads as the system has resources for. Threads will be created and released as necessary on a concurrent queue.

### Asynchronous doesn't mean concurrent
Just because your tasks are asynchronous doesn't mean they will run concurrently.

You're actually able to submit asynchronous tasks to either a serial queue or a concurrent queue. Being synchronous or asynchronous simply identifies whether or not the queue on which you're running the task must wait for the task to complete before it can spawn the next task.

Categorizing something as serial versus concurrent identifies whether the queue has a single thread or multiple threads available to it. Submitting three asynchronous tasks to a serial queue means that each task has to completely finish before the next task is able to start as there is only one thread available.

A task being synchronous or not speaks to the source of the task. Being serial or concurrent speaks to the destination of the task.


## Operations
### Operation subclassing
`Operations` are fully functional classes that can be submitted to an `OperationQueue`, just like you'd submit a closure of work to a `DispatchQueue` for GCD.

Operations can exist in any of the following states:
- `isReady`
- `isExecuting`
- `isCancelled`
- `isFinished`

### Bonus features
Operations provide greate control over the tasks as we can now handle such common needs as cancelling the task, reporting the state of the task, wrapping asynchronous tasks into an operation and specifying dependencies between various tasks.

### BlockOperation
If you don't want to also create a DispatchQueue, then you can instead utilize the `BlockOperation` class.

`BlockOperation` subclasses `Operation` for you and manages the concurrent execution of one or more closures on the default global queue.

Block operations run concurrently. If you need them to run serially, you'll need to setup a dispatch queue instead.

## Which should you use?
GCD tends to be simpler to work with for simple tasks you just need to execute and forget.

Operations provide much more functionality when you need to keep track of a job or maintain the ability to cancel it.

If you're just working with methods or chunks of code that need to be executed, GCD is a fitting choice.

If you're working with objects that need to encapsulate data and functionality then you're more likely to utilize Operations.
