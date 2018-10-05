// set tempo
// ? I think a dur value of 1 in Pbind means one beat - play(quant: 1.875); -play_quant(1.875);


TempoClock.default.tempo = 120/60;
q = 32;

s.meter;

(
Pdef(\hat,
	Pbind(
		\instrument, \hat,
		\delta, Pn(Pshuf([1/2, 1/4,1/4],8),inf),
		\amp,1,
		\freq,  Pkey(\delta) * 8000 + 8000,
		\bw, 0.05,
		\rel, Pwhite(0.005, 0.1, inf),
		\pan, ((Pkey(\freq) - 9000) * 0.0005) - 1
	);
).play(quant:q);
)

(
Pdef(\snare,
	Pbind(
		\instrument, \snare,
		\group, ~synths,
		\delta, 1,
		\amp,0.2,
		\rel, Pwhite(0.2,0.3, inf),
		\pan, Pseq([Rest,0],inf),
		\freq, Pwhite(8000,10000, inf),
		\send, 0.25,
		\group, ~synths
	);
).play(quant:q);
)



(
Pdef(\bDrum,
	Pbind(
		\instrument, \bDrum,
		\delta, 1,
		\amp,1.0,
		\freq, 70,
	);
).play(quant:q);
)




(
Pdef(\bass,
	Pbind(
		\type, \note,
		\instrument, \chaosBass,
		\dur, 8,
		\legato,0.5,
		\octave, 3,
		\scale, Scale.major,
		\root, 0,
		\degree, Pseq([Pn(2,2), Pn(-2,2)], inf) - 1 ,
		\amp,0.4 ,
		\pan, 0,
		\rez, 1,
		\coef, 0.8,
		//\group, ~synths
	);
).play(quant:q);
)






(
Pdef(\sineArp,
	Pbind(
		\type, \note,
		\instrument, \sinePerc,
		\dur, 1/2,
		\rel,Pwhite(0.7,1.2,inf),
		\octave, 5,
		\scale, Scale.major,
		\root,0,
		\degree, Pseq([Pshuf([2,4,5,6],8), Pshuf([5,6,7,9],8)],inf) - 1,
		\amp,0.1,
		\pan, Pseq([Pshuf([-1, 1, 1], 16)],inf),
		\fltF, Pwhite(2000, 4000, inf),
		\delay, 0.2,
		\group, ~synths

	);
).play(quant:q);
)

Proutine
(
a = Routine{
	arg a, b, c;
	a.yield;
	b.yield;
	c.yield;

	};
)

a.next;


/*
three arguments
scale [2,4,5,6]
length of segment [3,2]
number of times to repeat segment [2,1]


*/



(
Pdef(\klank,
	Pbind(
		\type, \note,
		\instrument, \klank,
		\rate, 1,
		\dur, 16,
		\legato,1,
		\scale, Scale.major,
		\root, 0,
		\degree, Prand([Pseq([9, 7]),Pseq([6, 5])],inf) - 1 ,
		\amp,0.45,
		\octave, 6,
		\verb, 2

	);
).play(quant:q);
)
Synth.new(\klank);




/*
~iim6 = [1,3,5,6]
~vadd2 = [4,5,6,8]
play(quant:q)
quant_(q)
*/
~iim6 = [1,3,5,6];
~vadd2 = [4,5,6,8];

s.meter;

s.plotTree;
Scale.directory;
Place
















