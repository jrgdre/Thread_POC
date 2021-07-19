## Synchronize

This POC plays with Pascal's `TThread.Synchronize()` procedure.

[`TThread.Synchronize()`](https://www.freepascal.org/docs-html/rtl/classes/tthread.synchronize.html)
```
Synchronizes the thread by executing the method in the main thread.
```

Imagine a situation in an office, with a number of colleagues. It's right before
the meeting and everyone _needs_ coffee, now! But there is only one machine.

[Common sense](https://quoteinvestigator.com/2014/04/29/common-sense/)
(if available) makes people organize themselves in those situations. They line
up and wait there turn (woman and children first, etc.). The meeting of course
needs to be  postponed until everyone got served.

But threads don't have common sense.

They use
[`Synchronize()`](https://www.freepascal.org/docs-html/rtl/classes/tthread.synchronize.html)
to explicitly ask the main thread of the application to take over the
organizing.

The main thread has one queue for all `Synchronize()` calls. First come first
serve. Everyone has to wait in line. The main thread and all remaining waiting
threads are blocked from other tasks.

### Synchronize demo

Let's stick to the office image.

The class `TCoffeDrinker` in `.\00_Common\I_Data.pas` is the template for all
the coffee drinkers.
