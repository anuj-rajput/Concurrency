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

