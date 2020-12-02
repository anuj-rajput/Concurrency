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

                                  ↗  isCancelled
Operation → isReady → isExecuting              ↓
                                                          ↘  isFinished
