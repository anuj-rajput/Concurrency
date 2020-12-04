#  Operation Queues

Just like with GCD's `DispatchQueue`, the `OperationQueue` class is what you use to manage the scheduling of and `Operation` and the maximum number of operations that can run simultaneously.

`OperationQueue` allows you to add work in three separate ways:
- Pass an `Operation`.
- Pass a closure.
- Pass an array of `Operation`s.

## OperationQueue mangement
The operation queue executes operations that are *ready*, according to quality of service values and any dependencies the operation has. Once you have added an `Operation` to the queue, it will run until it has completed or been canceled.

Once you have added an `Operation` to an `OperationQueue`, you can't add that same `Operation` to any other `OperationQueue`.

### Waiting for completion
If you look under the hood of `OperationQueue`, you'll notice a method called `waitUntilAllOperationsAreFinished`. It does exactly what its name suggests. Never call this method on a main UI thread.

### Quality of service
The default quality of service level of an operations queue is `.background`. You can set QoS on the operation queue but keep in mind that it will be overridden when you add a task with a higher priority in it.

### Pausing the queue
You can pause the dispatch queue by setting the `isSuspended` property to `true`. In-flight operations will continue to run but newly added operations will not be scheduled until you change `isSuspended` back to `false`.

### Maximum number of operations
By default, the operation queue will run as many jobs as your device is capable of handling at once. Set `maxConcurrentOperationCount` property on the operation queue to limit the number. If it is 1 then it becomes a serial queue.

### Underlying DispatchQueue
Before you add any operations to an `OperationQueue`, you can specify an existing `DispatchQueue` as the `underlyingQueue`. If you do so, keep in mind that the quality of service of the dispatch queue will override any value you set for the operation queue's quality of service
