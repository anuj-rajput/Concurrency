#  Groups & Semaphores

Sometimes, instead of just tossing a job into a queue, you need to process a group of jobs. They don't all have to run at the same time, but you need to know when they have all completed. Apple provides dispatch groups for this exact scenario.

## DispatchGroup
`DispatchGroup` is what you'll use when you want to track the completion of a group of tasks.

```swift
let group = DispatchGroup()

someQueue.async(group: group) { ... your work ... }
someQueue.async(group: group) { ... more work ... }
someOtherQueue.async(group: group) { ... other work ... }

group.notify(queue: DispatchQueue.main) { [weak self] in 
    self?.textLabel.text - "All jobs have completed"
}
```
Groups are not hardwired to a single dispatch queue. You can use a singke group, yet submit jobs to multiple queues, depending on the priority of the task.
`DispatchGroup`s provide a `notify(queue:)` method, which can be used to be notify as soon as every job submitted has finished.

### Synchronous waiting
If you can't respond asynchronously to the group's completion notification, then you can use the `wait` method o the dispatch group. It's a synchronous method that will block the current queue until all jobs have finished.

```swift
let group = DispatchGroup()

someQueue.async(group: group) { ... }
someQueue.async(group: group) { ... }
someOtherQueue.async(group: group) { ... }

if group.wait(timeout: .now() + 60) == .timedOut {
    print("The jobs didn't finish in 60 seconds")
}
```
This blocks the current thread. Never ever call `wait` on the main queue.

### Wrapping asynchronous methods
If you call an asynchronous method of the closure, then the closure will `complete` before the internal asynchronous method has completed.

You can call the provided `enter` and `leave` methods on `DispatchGroup` to tell the task that it's not done until the internal calls have completed.

```swift
queue.dispatch(group: group) {
    // count is 1
    group.enter()
    // count is 2
    someAsyncMethod {
        defer { group.leave() }
        
        // Perform your work here,
        // count goes back to 1 once completed
    }
}
```
By calling `group.enter()`, you let the dispatch group know that there is another block of code running, which should be counted towards the group's overall completion status. You have to pair that with a corresponding `group.leave()` call or you'll never be signaled of completion.
You will usually want to use a `defer` statement, so that, no matter how you exit the closure, the `group.leave()` code executes.

```swift
func myAsyncAdd(lhs: Int, rhs: Int, completion: @escaping (Int) -> Void) {
    // Lots of cool code here
    completion(lhs + rhs)
}

func myAsyncAddForGroups(group: DispatchGroup, lhs: Int, rhs: Int, completion: @escaping (Int) -> Void) {
    group.enter()
    
    myAsyncAdd(lhs: lhs, rhs: rhs) { result in
        defer { group.leave() }
        
        completion(result)
    }
}
```
The wrapper method takes a parameter for the group that it will count against, and then the rest of the arguments should be exactly the same as that of the method you're wrapping.
If you write a wrapper method, then testing iis simplified to a single location to validate proper pairing of `enter` and `leave` calls.


## Semaphores
There are times when you really need to control how many threads have access to a shared resource.
If you're downloading data from the network, for example, you may wish to limit how many downloads happen at once. You'll use a dispatch queue to offload the work, and you'll use dispatch groups so that you know when all the downloads have completed. However, you only want to allow four downloads to happen at once because you know the data you're getting is quite large and resource-heavy to process.

By using a `DispatchSemaphore`, you can handle exactly that use case

When creating a semaphore, you specify how many concurrent accesses to the resource are allowed. If you wish to enable four network downloads at once, then you pass in 4. If you're trying to lock a resource for exclusive access, then you'd just specify 1.

Just as you had to be sure to call leave on a dispatch group, you'll want to be sure to `signal` when you're done using the resource. Using a `defer` block is the best option as there's then no way to leave without letting go of the resource
