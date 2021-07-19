{!  Common data structures, Beverages.

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
unit U_Beverages;
{$mode Delphi}

interface

type
	{!	Coffee types we know about.
	}
	TCoffee = (
		cAmericano = 0,
		cCappuccino,
		cEspresso
	);

const
	StrCoffee: Array [TCoffee] of String = (
		'Americano',
		'Cappuccino',
		'Espresso'
	);

implementation
end.
