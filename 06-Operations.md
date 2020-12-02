#  Operations

Both GCD and operations allow you to submit a chunk of code that should be run on a separate thread; however, operations allow for greater control over the submitted task. They add extra features such as dependencies on other operations, ability to cancel the running operation.

## Reusability
One of the reason you'd want to create an `Operation` is for reusability.

## Operation states
An operation has a state machine tthat represents its lifecycle.
- When it has been instantiated and is ready to run, it will transition to `isReady` state.
- At some point, you may invoke the `start` method, at which point it will move to the `isExecuting` state.
- If the app calls the `cancel` method, then it will transition to the `isCancelled` state before moving onto the `isFinished` state.
- If it's not canceled, then it will move directly from `isExecutting` to `isFinished`

Each of the states are read-only boolean properties on `Operation` class and you can query them at any point during the execution of the task to see whether or not the task is executing.

## BlockOperation
A `BlockOperation` manages the concurrent execution of one or more closures on the default global queue.

```swift
let operation = BlockOperation {
    print("2 + 3 = \(2 + 3)")
}
```
Being an `Operation`, it can take advantage of KVO (Key-Value Observing) notifications, dependencies and everything else that an `Operation` provides.

### Multiple block operations

