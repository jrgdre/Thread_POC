{!  Common data structures, Producers.

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
		1.0.0 2021-07-19 jrgdre, initial release
}
unit U_Producers;
{$mode Delphi}

interface

uses
    U_Beverages;

type
	{!	Not multi-threading enabled coffee maker.
	}
	TCoffeeMaker = class
	public
		procedure MakeCoffee(const typeOfCoffee: TCoffee);
	end;

implementation

uses
    classes,
    sysutils;

{ TCoffeeMaker }

{!	Make a coffee.

	Plain old object. Nothing to see here.

	It takes the coffee maker between 110..140ms to make a coffe,
	depending on the type of coffee and some random factors.
}
procedure TCoffeeMaker.MakeCoffee(
	const typeOfCoffee: TCoffee
);
var
	ran: Integer;
begin
	ran := Random(10)+10;
	case typeOfCoffee of
		cAmericano : Sleep(100+ran);
		cCappuccino: Sleep(110+ran);
		cEspresso  : Sleep(120+ran);
	end;
	TThread.Yield;
end;

end.
