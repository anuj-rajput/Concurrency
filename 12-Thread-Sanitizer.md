#  Thread Sanitizer

## Why the sanitizer?
The Thread Sanitizer, commonly referred to as TSan, is a tool Apple provides as part of the LLVM compiler. TSan allows you to identify when multiple threads attempt to access the same memory without providing proper access synchronization.

TSan is only supported when runnon on the simulator.

## It's not code analysis
Thread Sanitizer is a runtime analysis. If an issue doesn't occur during execution, it won't be flagged.
You should try to run using the Thread Sanitizer frequently - and not just once. Enabling thr sanitizer has a pretty steep performance impact of anywhere between 2x to 20x CPU slowdown, and yet, you should run it often or otherwise integrate it into your workflow, so you don't miss out on the threading issues.
