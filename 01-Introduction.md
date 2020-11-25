#  Introduction

## What is conurrency?
Wkipedia defines concurrency as "the decomposability property of a program, algortithm, or problem into order-independent or partially-ordered components or units."

Looking at the logic of the app to determine which pieces can run at the same time, and possibly in a random order, yet still result in a correct implementation of the data flow.

## Why use concurrency?
"It's too slow" is one of the main contributors to the app being uninstalled

A  beneficial side effect to using concurrency is that it helps us to spend a bit more time thinking about the app's overall architecture. Instead of just writing massive methods to "get the job done" you'll find yourself naturally writing smaller, more manageable methods that can run concurrently.

## How to use concurrency
Multiple tasks that modify the same resource (i.e., variable) can't run at the same time, unless you make them thread safe.

`Operation` class is built on top of Grand Central Dispatch, operations allow for handling of more complex scenarios such as reusable code to be run on a background thread, having one thread depend on another, and even cancelling an operation before it's started of completed.
