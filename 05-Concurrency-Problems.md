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
