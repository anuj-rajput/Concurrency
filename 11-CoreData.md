#  Core Data

While mixing concurrency and Core Data is no longer complicated in modern versions of iOS, there are still a couple of key concepts that you'll want to be aware of. Just like most of UIKit, Core Data is not thread safe.

## NSManagedObjectContext is not thread safe
The `NSManagedObjectContext`, which gets created as part of an `NSPersistentContainer` from your `AppDelegate`, is tied to the main thread. This means that you can only use that context on the main UI thread.

There are two methods available on the `NSManagedObjectContext` class to help with concurrency:
- `perform(_:)`
- `performAndWait(_:)`

What both methods do is ensure that whatever action you pass to the closure is executed on the same queue that created the context.
The first methods is an asynchronous method while the second is synchronous.

## Importing data
```swift
persistentContainer.performBackgroundTask { context in
    for json in jsonDataFromServer {
        let obj = MyEntity(context: context)
        obj.populate(from: json)
    }
    
    do {
        try context.save()
    } catch {
        fatalError("Failed to save context")
    }
}
```
Core Data will generate a new context on a private queue for you to work with so that you don’t have to worry about any concurrency issues. Be sure not to use any other context in the closure or you’ll run into tough to debug runtime issues.

```swift
let childContext = NSManagedObjectContext(concurrecyType: .privateQueueConcurrencyType)
childContext.parent = persistentContainer.viewContext

childContext.perform {
    ...
}
```

## NSAsynchronousFetchRequest
When you use an `NSFetchRequest` to query Core Data, the operation is synchronus. If you're just grabbing a single object, that's perfectly acceptable. When you're performing a time-consuming query, such as retrieving data to pouplate a `UITableView`, then you'll prefer to perform the query asynchronously. Using `NSAsynchrounousFetchRequest` is the obvious solution.

```swift
let ageKeyPath = #keyPath(Person.age)

let fetchRequest = Person.fetchRequest() as NSFetchRequest<Person>
fetchRequest.predicate = NSPredicate(format: "%K > 13", ageKeyPath)

let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { [weak self] result in
    guard let self = self,
          let people = result.fiinalResult else {
          return
    }
    
    self.tableDatat = people
    
    DispatchQueue.main.async {
        self.tableView.reloadData()
    }
}

do {
    let backgroundContext = persistentContainer.newBackgroundContext()
    try backgroundContext.execute(asyncFetch)
} catch let error {
    // handle error
}
```

## Sharing an NSManagedObject
If two separate threads both need to access to the same object, you must pass the `NSManagedObjectId` instead of the actual `NSManagedObject`. You can get the `NSManagedObjectId` via the `objectID` property.

```swift
let objectId = someEntity.objectID

DispatchQueue.main.async { [weak self] in
    guard let self = self else { return }
    
    let myEntity = self.managedObjectContext.object(with: objectId)
    self.addressLabel.text = myEntity.address
}
```
### Using ConcurrencyDebug
Add `-com.apple.CoreData.ConcurrencyDebug 1` to your app's scheme to catch calling Core Data methods on the wrong thread in the debugger.
