#  Thread Sanitizer

## Why the sanitizer?
The Thread Sanitizer, commonly referred to as TSan, is a tool Apple provides as part of the LLVM compiler. TSan allows you to identify when multiple threads attempt to access the same memory without providing proper access synchronization.

TSan is only supported when runnon on the simulator.
