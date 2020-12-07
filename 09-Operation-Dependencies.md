#  Operation Dependencies

Making one operation dependent on another provides two specific benefits for the interactions between operations:
- Ensures that the dependent operationdoes not begin before the prerequisite operation has completed
- Provides a clean way to pass data from the first operation to the second operation automatically.

## Modular design
Classes should ideally perform a single task, enabling reuse within and across projects. If you had built the networking code into the tilt shift operation directly, then it wouldn't be usable for an already-bundled image.

While you could add many initialization parameters specifying whether or not the image would be provided or downloaded from the network, that bloats the class. Not only does it increase the long- term maintenance of the class — imagine switching from URLSession to Alamofire.

## Specifyinig dependencies
Adding or removing dependency requires just a single method call on the *dependent* operation.
```swift
let networkOp = NetworkImageOperation()
let decryptOp = DecryptOperation()
let tiltShiftOp = TiltShiftOperation()

// To remove dependency
tiltShiftOp.removeDependency(op: decryptOp)
```
The `Operation` class also provides a read-only property, `dependencies`, which will return an array of `Operation`s, which are marked as dependencies for the given operation.

### Avoiding the pyramid of doom
Dependencies have the added side effect of making the code much simpler to read. If you tried to write three chained operations together using GCD, you'd end up with a pyramid of doom.

The following example is how it will be represented using GCD:
```swift
let network = NetworkClass()
network.onDownload { raw in 
    guard let raw = raw else { return }
    
    let decrypt = DecryptClass(raw)
    decrypt.onDecrypted { decrypted in 
        guard let decrypted = decrypted else { return }
        
        let tilt = TiltShiftClass(decrypted)
        tilt.onTiltShifted { tilted in 
            guard let tilted = tilted else { return }
        }
    }
}
```
Which one is going to be easier to understand and maintain for the junior developer who takes over your project once you move on to bigger and better things?

## Watch out for deadlock
If the dependency graph draws a straight line, then there's no possibility of a deadlock

![No Deadlock](/images/NoDeadlock.png)

It's completely valid to have operations from one operation queue depend on an operation from another operation queue. As long as there are no loops, you're safe from deadlock.

![No Deadlock](/images/NoDeadlock2.png)

However, if you start seeing loops, you've almost certainly run into a deadlock.

![Deadlock Warning](/images/DeadlockWarning.png)

- Operation 2 can't start until operation 5 is done.
- Operation 5 can't start until operation 3 is done.
- Operation 3 can't start until operation 2 is done.

If you start and end with the same operation number in a cycle, you've hit deadlock. None of the operations will ever be executed.

## Passing data between operations
### Using protocols
```swift
import UIKit
protocol ImageDataProvider {
    var image: UIImage? { get }
}
```

### Adding extensions
While you could have simply added ImageDataProvider to the class definition, the Swift Style Guide recommends the extension approach instead.

```swift
extension NetworkImageOperation: ImageDataProvider {}
````

```swift
extension TiltShiftOperation: ImageDataProvider {
    var image: UIImage? { return outputImage }
}
```

Remember that an extension can be placed anywhere, in any file. Since you created both operations, it makes sense of course to place the extension right alongside the class.

### Searching for the protocol
