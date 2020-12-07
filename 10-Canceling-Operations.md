#  Canceling Operations

With an operation, you have the capability of canceling a running operation as long as it's written properly. This is very useful for long operations that can become irrelevant over time. For instance, the user might leave the screen or scroll away from a cell in a table view. There's no sense in continuing to load data or make complex calculations if the user isn't going to see the result.

## The magic of cancel
Once you schedule an operation into an operation queue, you no longer have any control over it. The queue will schedule and manage the operation from then on. The one and only change you can make, once it's been added to the queue, is to call the `cancel` method of `Operation`.

## Cancel and cancelAllOperations
The interface to cancel an operation is quite simple. If you just want to cancel a specific `Operation`, then you can call the `cancel` method. If, on the other hand, you wish to cancel all operations that are in an operation queue, then you should call the `cancelAllOperations` method defined on `OperationQueue`


