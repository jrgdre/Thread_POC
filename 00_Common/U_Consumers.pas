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

	{! Prototype of a report event handler procedure.
	}
	TOnReport = procedure(const report: String);

	{!	Archetype of a coffee drinker.

		Drinking coffee enables a coffee drinker to work independently,
		hence he is to be modelled as a `TThread` descendent.
	}
	TCoffeeDrinker = class(TThread)
	private
		FConsumerID   : NativeUInt;
		FThreadID     : TThreadID      ;
		FCoffee       : TCoffee        ;
		FStatus       : TConsumerStatus;
		FEnd          : TDateTime      ;
		FStart        : TDateTime      ;
		FOnIWantCoffee: TOnIWantCoffee ;
		FOnReport     : TOnReport      ;
	protected
		procedure GrabCoffee ; overload;
		procedure DrinkCoffee; overload;
		procedure ReportTime ; overload;
	public
		procedure Execute; override;  //!< Where the work is done.
		//
		property ConsumerID   : NativeUInt read FConsumerID write FConsumerID;
		property OnIWantCoffee: TOnIWantCoffee write FOnIWantCoffee;
		property OnReport     : TOnReport      write FOnReport;
	end;

implementation

uses
	dateutils,
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
	FThreadID := GetThreadID;

	// It takes the drinker between 0..999ms to realize that he wants a coffee.
	Sleep(Random(1000));

	// He now randomly select the type of coffee he wants, from the list of
	// coffees. The Random() call itself has different runtimes on different
	// calls.
	FCoffee := TCoffee(Random(Ord(High(TCoffee))+1));

	FStart := Now;
	Synchronize(ReportTime); // <-- report time when he made up his mind

	Synchronize(GrabCoffee); // <-- coffee machine is shared
	DrinkCoffee;             // <-- I don't need any help to drink my coffee

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
	FStatus := csGrabbing;
	FStart  := Now;

	// First we have to make sure a coffe maker is registered with us to provide
	// us with coffee, whenever we want one.

	// If so, we tell that one that we now want some coffee and the kind of
	// coffee we want.

	if Assigned(FOnIWantCoffee) then
		FOnIWantCoffee(FCoffee);

	FEnd    := Now;
	FStatus := csHaving;	// Not getting one is not even an option!
	Synchronize(ReportTime);
end;

{!	Drink the coffee.

	It takes between 30..100ms to drink the coffee.

	This is a normal thread method, that can be executed in parallel, without
	caring for other threads.
}
procedure TCoffeeDrinker.DrinkCoffee;
begin
	FStart  := Now;

	Sleep(30+Random(71));

	FEnd    := Now;
	FStatus := csDone;
	Synchronize(ReportTime);
end;

{!	Report the time it took to reach different stages.

	This is a more tricky one to understand.

	At a glance it looks like there is nothing dangerous in here. We only access
	member variables. What can possibly go wrong, right?

	Well the trap lies in the function call `FOnReport(str)`.

	The implementation of this function is provided by some outside source, we
	have no control over. It can contain who knows what.

	And for a report function the chances are actually pretty high, that it
	will write to some shared resource.

	So any call to this method has to be made through the
	`TThread.Synchronize()`	method, to  make sure that the main thread can keep
	things in order.

	Also, during a call made using `Synchronize()` this thread is halted,
	waiting for `Synchronize()`to return. So it is safe for the method to access
	any member variable, even so it runs in the context of the main thread.
}
procedure TCoffeeDrinker.ReportTime;
var
	str: String;
begin
	if not Assigned(FOnReport) then
		Exit;
	case FStatus of
		csWanting:
			str := Format(
				'%s %4d reporting for coffee drinker %2d (%4d): I want %s.',
				[FormatDateTime('hh:nn:ss.zzz', FStart),
				 GetThreadID,
				 FConsumerID,
				 FThreadID,
				 StrCoffee[FCoffee]]
			);
		csHaving:
			str := Format(
				'%s %4d reporting for coffee drinker %2d (%4d): It took me %4dms to get my %s.',
				[FormatDateTime('hh:nn:ss.zzz', FEnd),
				 GetThreadID,
				 FConsumerID,
				 FThreadID,
				 MilliSecondsBetween(FStart, FEnd),
				 StrCoffee[FCoffee]]
			);
		csDone:
			str := Format(
				'%s %4d reporting for coffee drinker %2d (%4d): It took me %4dms to drink my %s.',
				[FormatDateTime('hh:nn:ss.zzz', FEnd),
				 GetThreadID,
				 FConsumerID,
				 FThreadID,
				 MilliSecondsBetween(FStart, FEnd),
				 StrCoffee[FCoffee]]
			);
	end;
	FOnReport(str);
end;

end.
