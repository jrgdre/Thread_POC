# Thread POC

This project exists to tests some concepts around multi-thread programming in
Pascal.

It is mostly developed with Free Pascal using VSCode (plus OmniPascal) and
tested on with gdb:

- MS-Windows 7  (D:\tools\msys64\mingw64\bin\gdb.exe)
- Ubuntu 18.04  (/usr/bin/gdb)

## Why

People say programming multi-threading applications is hard.

Well, they are not completely wrong. But it is also not rocket since.

From what I observe, the problem, especially for the younger generation of
programmers, comes from the two most successful concepts of the
pre-multi-threading era they grow up with and take for granted:

- problem oriented programming
- object oriented programming

Modern programming languages allow us to care more for _what_ problem we want to
solve, than _how_ the problem is solved. Especially if you write non-enterprise
scale applications.

Object oriented programming allows us to stick stuff together and share a lot of
code between related entities.

This unfortunately can make it hard to keep track of who owns what and what is
accessed by whom and when.

Also being able to put data structures and code together in a class (-tree)
unfortunately makes it way to easy to fall into design traps, like mixing up
data code and business logic code.

What might only be of small consequence in a single thread applications, can
become a major headache if one tries to re-use that code in a multi-threaded
environment.

Funny enough, the older generation has, from what I see, a little bit of an
advantage here. When they started, pretty much all that was there was data-
structures and functions. You just _could_ not weld the things together wrong.
And even so one or the other might have picked up some nasty habits over the
years, it seems to be easier to shake them now.

Also the application developer now finds itself in the same position system
developers are in since the times we left DOS behind.

Operating systems have to handle the needs of different processes, that run at
the same time. E.g. everyone wants time on one of the CPUs, needs access to mass
storage, etc. But some of these resources can only handle one thing at a time.
So OS programmers have to make sure that there systems put every thing in order
and everyone gets a fair share.

In single thread applications, the application programmer does not have problems
like that. All the resources of the program are used by one thread alone. No
sharing is needed.

With multi-thread applications things are more like in a smaller version of the
OS. There are resources that can only handle one request at a time. But now it
is the task of the application programmer to put everything in order. If not
done right, the application can create sporadic errors, that are hard to fix.

So multi-thread application programming has new challenges, that are actually
old virtues of good programmers. We have to go back again to thinking more about
_how_ we actually solve a problem, effective and efficient.

That is what this prove of concept project is all about.

## How

I (like probably all of us) usually write a small test application, whenever I
want to try something, I'm not to sure about how it's done right yet. It's
usually way easier to move the results to the program I'm actually working on
later, then it is trying to clean up the mess all the experimenting would create
in the production code.

Usually I keep my POC's in some folder on my local disc.

But hey, maybe someone else has use for that! So why not share it?

Also, if it's in a public repository I always know where to find it and others
might peer review it, help me to find better solutions and clear up some
mistakes.

So here it is, enjoy!
