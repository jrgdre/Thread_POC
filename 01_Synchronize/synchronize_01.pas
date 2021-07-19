{!  Demo program for TThread.Synchronized

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
program synchronize_01;
{$mode Delphi}

uses
	classes,
	sysutils,
{$ifdef unix}
	cthreads,
	cmem, // the c memory manager is on some systems much faster for multi-threading
{$endif}
	U_Beverages in '..\00_Common\U_Beverages.pas',
	U_Consumers in '..\00_Common\U_Consumers.pas',
	U_Producers in '..\00_Common\U_Producers.pas';

const
	CNT_COFFEE_DRINKERS = 10;

var
	coffeeDrinker : TCoffeeDrinker;
	coffeeDrinkers: Array[1..CNT_COFFEE_DRINKERS] of TCoffeeDrinker;
	coffeeMaker   : TCoffeeMaker;
	i             : NativeUInt;
	reports       : TStringList;

procedure OnReport(const report: String);
begin
	reports.Add(report);
end;

begin
	reports     := TStringList .Create;
	coffeeMaker := TCoffeeMaker.Create;
	try
		// set-up
		for i := Low(coffeeDrinkers) to High(coffeeDrinkers) do begin
			coffeeDrinkers[i]               := TCoffeeDrinker.Create(True);
			coffeeDrinkers[i].ConsumerID    := i;
			coffeeDrinkers[i].OnIWantCoffee := coffeeMaker.MakeCoffee;
			coffeeDrinkers[i].OnReport      := OnReport;
		end;

		// run
		WriteLn('running...');
		for coffeeDrinker in coffeeDrinkers do
			coffeeDrinker.Start;

		// shut down
		for coffeeDrinker in coffeeDrinkers do
			coffeeDrinker.WaitFor;

		// report
		reports.Sort;
		for i := 0 to reports.Count-1 do
			WriteLn(reports[i]);

	finally
		for i := Low(coffeeDrinkers) to High(coffeeDrinkers) do
			FreeAndNil(coffeeDrinkers[i]);

		if Assigned(coffeeMaker) then
			FreeAndNil(coffeeMaker);

		if Assigned(reports) then
			FreeAndNil(reports);
	end;
end.
