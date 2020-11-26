#  Queues & Threads

## Threads
A thread is really a *thread of execution*, and it;s how a running process splits tasks across resources on the system.

You can have as many threads executing at once as you have cores in your device's CPU.

Advantages to splitting app's work into multiple threads:
- Faster execution: By running tasks on threads, it's possible for work to be done concurrently, which will allow it to finish faster than running everything serially.
- Responsiveness: If you only perform user-visible work on the main UI thread, then users won't notice that the app slows down or freezes up periodically due to work that could be performed on another thread.
- Optimized resource consumption: Threads are highly optimized by the OS.

## Dispatch queues
The way you work with threads is by creating a `DispatchQueue`. When you create a queue, the OS will potentially create and assign one or more threads to the queue.

```swift
let label = "com.anujrajput.mycoolapp.networking"
let queue = DispatchQueue(label: label)
```
It's best to use a reverse- DNS style name, as shown above (e.g. com.company.app), since the label is what you'll see when debugging and it's helpful to assign it meaningful text.

### The main queue
When the app starts, a  `main` dispatch queue is automatically created. It's a serial queue that's responsible for the UI. Apple has made is available as a class variable, which you can access via `DispatchQueue.main`

To create a concurrent queue, simply pass in the .concurrent attribute, like so
```swift
let label = "com.anujrajput.mycoolapp.networking"
let queue = DispatchQueue(label: label, attributes: .concurrent)
```
### Quality of service (QoS)
When using a concurrent dispatch queue, you'll need to tell iOS how important the tasks are that get sent to the queue so that it can properly prioritize the work that needs to be done against all the other tasks.

Higher priority work has to be performed faster, likely taking more system resources to complete and requiring more energy than lower-priority work.

If you need a concurrent queue but don't want to manage your own, you can use the `global` class method on `DispatchQueue` to get one of the pre-defined global queues:
```swift
let queue = DispatchQueue.global(qos: .userInteractive)
```

#### .userInteractive
The `.userInteractive` QoS is recommended for tasks that the user directly interacts with. UI updating calculations, animations or anything needed to keep the UI responsive and fast.

#### .userInitiated
The `.userInitiated` queue should be used when the use kicks off a task from the UI that needs to happen immediately, but can be done asynchronously. e.g. Opening a document or reading from database. 

#### .utility
You'll want to use the `.utility` dispatch queue for the tasks that would typically include a progress indicator such as long-running computations, I/O, networking or continuous data feeds.

#### .background
For the tasks user is not directly aware of, you should use the `.background` queue. They don't require user interaction and are not time sensitive. e.g. Prefetching, database maintenance, syncing with remote servers and backups.

#### .default and .unspecified
This exists between `.userInitiated` and `.utility` and should not be specified directly.
