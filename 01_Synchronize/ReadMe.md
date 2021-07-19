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
needs to be postponed until everyone got served.

But threads don't have common sense.

They use
[`Synchronize()`](https://www.freepascal.org/docs-html/rtl/classes/tthread.synchronize.html)
to explicitly ask the main thread of the application to take over the
organizing.

The main thread has one queue for all `Synchronize()` calls. First come first
serve. Everyone has to wait in line. The main thread and all remaining waiting
threads are blocked from other tasks.

### Synchronize demo

The code isn't to complicated. There are more verbose comments, where it gets
interesting. So check it out. Just a couple of general remarks here:

First, it stick to the office image.

The `main` routine is in `synchronize_01.pas`.

It sets up a bunch of coffee drinkers, gets them started and waits for them to
be finished. Finally a report is printed.

The class `TCoffeDrinker` in `..\00_Common\U_Consumers.pas` is the template for
all the coffee drinkers. It is where all the fun stuff happens. That's why it
has a lot more comments in it.

All that's left we need is a coffee maker. That class is in
`..\00_Common\U_Producers.pas`.

How all comes together can be found in the set-up sequence of the main routine.

This is a report of a sample run. The fields are:

 #1 time of reporting
 #2 ThreadID of thread reporting
 #3 identification text
 #4 coffee drinker's CustomerID
 #5 coffee drinker's ThreadID
 #6 message

```
running...
18:16:56.531 6024 reporting for coffee drinker  2 (4296): I want Cappuccino.
18:16:56.546 6024 reporting for coffee drinker  2 (4296): It took me   15ms to get my Cappuccino.
18:16:56.609 6024 reporting for coffee drinker  2 (4296): It took me   63ms to drink my Cappuccino.
18:16:56.655 6024 reporting for coffee drinker  1 (4416): I want Espresso.
18:16:56.655 6024 reporting for coffee drinker  9 (3620): I want Americano.
18:16:56.671 6024 reporting for coffee drinker  9 (3620): It took me   16ms to get my Americano.
18:16:56.702 6024 reporting for coffee drinker  1 (4416): It took me   31ms to get my Espresso.
18:16:56.702 6024 reporting for coffee drinker  4 (6492): I want Cappuccino.
18:16:56.702 6024 reporting for coffee drinker  5 (6184): I want Cappuccino.
18:16:56.719 6024 reporting for coffee drinker  5 (6184): It took me   17ms to get my Cappuccino.
18:16:56.719 6024 reporting for coffee drinker  7 (6524): I want Cappuccino.
18:16:56.719 6024 reporting for coffee drinker  9 (3620): It took me   48ms to drink my Americano.
18:16:56.720 6024 reporting for coffee drinker  4 (6492): It took me    1ms to get my Cappuccino.
18:16:56.783 6024 reporting for coffee drinker  7 (6524): It took me   63ms to get my Cappuccino.
18:16:56.798 6024 reporting for coffee drinker  1 (4416): It took me   96ms to drink my Espresso.
18:16:56.799 6024 reporting for coffee drinker  4 (6492): It took me   79ms to drink my Cappuccino.
18:16:56.799 6024 reporting for coffee drinker  5 (6184): It took me   80ms to drink my Cappuccino.
18:16:56.799 6024 reporting for coffee drinker  6 (2384): I want Americano.
18:16:56.815 6024 reporting for coffee drinker  6 (2384): It took me   16ms to get my Americano.
18:16:56.877 6024 reporting for coffee drinker  6 (2384): It took me   62ms to drink my Americano.
18:16:56.877 6024 reporting for coffee drinker  7 (6524): It took me   94ms to drink my Cappuccino.
18:16:56.926 6024 reporting for coffee drinker  3 (2564): I want Cappuccino.
18:16:56.926 6024 reporting for coffee drinker 10 (3536): I want Americano.
18:16:56.929 6024 reporting for coffee drinker  8 (7440): I want Espresso.
18:16:56.940 6024 reporting for coffee drinker  3 (2564): It took me   14ms to get my Cappuccino.
18:16:56.959 6024 reporting for coffee drinker 10 (3536): It took me   19ms to get my Americano.
18:16:56.979 6024 reporting for coffee drinker  8 (7440): It took me   20ms to get my Espresso.
18:16:56.998 6024 reporting for coffee drinker 10 (3536): It took me   39ms to drink my Americano.
18:16:57.064 6024 reporting for coffee drinker  3 (2564): It took me  124ms to drink my Cappuccino.
18:16:57.111 6024 reporting for coffee drinker  8 (7440): It took me  132ms to drink my Espresso.
Heap dump by heaptrc unit of D:\PoC\fpc\thread_poc\01_Synchronize\bin\win64\synchronize_01.exe
745 memory blocks allocated : 56541/60080
745 memory blocks freed     : 56541/60080
0 unfreed memory blocks : 0
True heap size : 196608 (192 used in System startup)
True free heap : 196416
```

Note that the id of the reporting thread is always the same and always different
from the coffee drinkers' ThreadIDs, even so the reports are generated by
different coffee drinker threads. This is the effect of calling the report
function using `Synchronize()`. It indeed put the `TCoffeeDrinker.ReportTime()`
method in the context of the main thread. That's why the `GetThreadID()` call in
this method always sees the main thread's ThreadID.

The other point to note is, that the order of the messages is rather random and
it will most likely be different for every new run. That shows that things are
indeed running in parallel.
