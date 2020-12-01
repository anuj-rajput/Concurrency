#  Concurrency Problems

- Race conditions
- Deadlocks
- Priority inversion

## Race conditions
Threads that share the same process, which also includes your app itself, share the same address space. Each thread is trying to read and write to the same shared resource. If you aren't careful, you can run into *race conditions* in which multiple threads are trying to write to the same variable at the same time.

You can usually solve race conditions with a serial queue, as long as you know they are happening. If your program has a variable that needs to be accessed concurrently, you can wrap the reads and writes with a private queue

```swift
private let threadSafeCountQueue = DispatchQueue(label: "countQueue")
private var _count = 0

public var count: Int {
    get {
        return threadSafeCountQueue.sync {
            _count
        }
    }
    set {
        threadSafeCountQueue.sync {
            _count = newValue
        }
    }
}
```

### Thread barrier
Sometimes, your shared resource requires more complex logic in its getters and setters than a simple variable modification. Locking is very hard to implement properly. Instead, you can use Apple's *dispatch barrier* from GCD.

If you create  a concurrent queue, you can process as many read type tasks as you want as they can all run at the same time. WHen the variable needs to be written to, then you need to lock down the queue so that everything already submitted completes, but no new submissions are run until the update completes.

Creating a dispatch barrier:
```swift
private let threadSafeCountQueue = DispatchQueue(label: "countQueue", attributes: .concurrent)
private var _count = 0
public var count: Int {
    get {
        return threadSafeCountQueue.sync {
            return _count
        }
    }
    set {
        threadSafeCountQueue.async(flags: .barrier) { [unowned self] in 
            self._count = newValue
        }
    }
}
```

## Deadlock
Accidentally calling `sync` against the current dispatch queue is the most common occurrence of deadlocks.

If you're using semaphores to control access to multiple resources, be sure that you ask for resources in the same order. If thread 1 requests a hammer and then a saw, whereas thread 2 requests a saw and a hammer, you can deadlock. Thread 1 requests and receives hammer at the same time thread 2 requests and receives a saw. Then thread 1 asks for a saw - without releasing the hammer - but thread 2 owns the resource so thread 1 must wait. Thread 2 asks for a saw, but thread 1 still owns the resource, so thread 2 must wait for the saw to become available. Both threads are now in deadlock as neither can progress until their requested resources are freed, which will never happen.

## Priority inversion
Priority inversion occurs when a queue with a lower quality of service is given higher system priority than a queue with a higher quality of service, or QoS.

If you are using a `.userInitiated` queue and a `.utility` queue and you submit multiple tasks to the latter queue with a `.userInteractive` quality of service, you could end up in a situation in which the latter queue is assigned a higher priority and all the other tasks in the queue, most of which are `.utility` quality of service will end up runnign before the tasks from `.userInitiated` queue. To avoid this: If you need a higher quality of service, use a different queue.   

The common situation when priority inversion occurs is when a higher quality of service queue shares a resource with a lower quality of service queue. When the lower queue gets a lock on the object, the higher queue now has to wait. Until the lock is released, the high priority queue is effectively stuck doing nothing while low priority tasks run.
