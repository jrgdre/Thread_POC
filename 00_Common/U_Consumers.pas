{!  Common data structures, Consumers.

	@copyright
		(c)2021 J.Drechsler

	@license
		MIT:
			Permission is hereby granted, free of charge, to any person
			obtaining a copy of this software and associated documentation files
			(the "Software"), to deal in the Software without restriction,
			including without limitation the rights to use, copy, modify, merge,
			publish, distribute, sublicense, and/or sell copies of the Software,
			and to permit persons to whom the Software is furnished to do so,
			subject to the following conditions:
			The above copyright notice and this permission notice shall be
			included in all copies or substantial portions of the Software.

	@author
		jrgdre: J.Drechsler

	@version
		1.0.0 2021-07-18 jrgdre, initial release
}
unit U_Consumers;
{$mode Delphi}

interface

uses
	classes,
	U_Beverages;

type
	{!	States of a coffee drinker.
	}
	TConsumerStatus = (
		csWanting = 0,
		csGrabbing,
		csHaving,
		csDone
	);

	{! Prototype of a IWantCoffee event handler procedure.
	}
	TOnIWantCoffee = procedure(const typeOfCoffee: TCoffee) of object;

	{!	Archetype of a coffee drinker.

		Drinking coffee enables a coffee drinker to work independently,
		hence he is to be modelled as a `TThread` descendent.
	}
	TCoffeeDrinker = class(TThread)
	private
		FThreadID     : TThreadID;
		FCoffee       : TCoffee;
		FStatus       : TConsumerStatus;
		FTickEnd      : QWord;
		FTickStart    : QWord;
		FOnIWantCoffee: TOnIWantCoffee;
	protected
		procedure GrabCoffee ; overload;
		procedure DrinkCoffee; overload;
		procedure ReportTime; overload;
	public
		procedure Execute; override;  //!< Where the work is done.
		//
		property OnIWantCoffee: TOnIWantCoffee write FOnIWantCoffee;
	end;

implementation

uses
	sysutils;

{ TCoffeeDrinker }

{!	Execute the coffee drinker tasks.

	This merhod calls `TCoffeeDrinker` thread's own `GrabCoffee()` procedure
	using the `TThread.Synchronize()` function.

	That actually makes the main thread make the call in it's context. This
	assures that maximal one coffee drinkers `GrabCoffee()` method is executed
	at any time.
}
procedure TCoffeeDrinker.Execute;
begin
	FThreadID  := GetThreadID;

	// randomly select the type of coffee we want this time,
	// from the list of coffees known to us
	FCoffee    := TCoffee(Random(Ord(High(TCoffee))+1));

	FStatus    := csGrabbing;
	FTickStart := GetTickCount64;

	Synchronize(GrabCoffee);    // <---- coffee machine is shared

	FTickEnd   := GetTickCount64;
	FStatus    := csHaving;
	Synchronize(ReportTime);

	FTickStart := GetTickCount64;

	DrinkCoffee;                // <-- don't need anyone to drink my coffee

	FTickEnd   := GetTickCount64;
	FStatus    := csDone;
	Synchronize(ReportTime);
end;

{!	Grab a coffee.

	Since there is only one coffee machine, we have to make sure that our access
	is `Synchronized()`.

	To be able to send the type of coffee we want as a parameters of the
	`FOnIWantCoffee` procedure, we need this parameterless GrabCoffee method,
	since `Synchronize()` only accepts parameterless procedures.
}
procedure TCoffeeDrinker.GrabCoffee;
begin
	// First we have to make sure a coffe maker is registered with us to provide
	// us with coffee, whenever we want one.

	// If so, we tell that one that we now want some coffee and the kind of
	// coffee we want.

	if Assigned(FOnIWantCoffee) then begin
		FOnIWantCoffee(FCoffee);
	end;
end;

{!	Drink the coffee.

	It takes between 30..100ms to drink the coffee.

	This is a normal thread method, that can be executed in parallel, without
	caring for other threads.
}
procedure TCoffeeDrinker.DrinkCoffee;
begin
	Sleep(30+Random(70));
end;

{!	Report the time it took to grab a coffee or to drink the coffee.

	Even so it is poor design in general, not to make things more confusing
	this method writes directly to `StdOut`.

	But `StdOut`is a shared ressource that can only be safely accessed by the
	main thread.

	So any call to this method has to be made through the
	`TThread.Synchronize()`	method, to  make sure it is the main thread that is
	accessing `StdOut`.

	Also, during a call made using `Synchronize()` this thread is halted,
	waiting for `Synchronize()`to return. So it is safe for the method to not
	only access `StdOut`, but also any member variable of the thread object.
}
procedure TCoffeeDrinker.ReportTime;
begin
	case FStatus of
		csHaving: Writeln(Format(
			'%d reporting for coffee drinker %d: It took me %dms to get my %s.',
			[GetThreadID, FThreadID, (FTickEnd-FTickStart), StrCoffee[FCoffee]]
		));
		csDone: Writeln(Format(
			'%d reporting for coffee drinker %d: It took me %dms to drink my %s.',
			[GetThreadID, FThreadID, (FTickEnd-FTickStart), StrCoffee[FCoffee]]
		));
	end;
end;

end.
