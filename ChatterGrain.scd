/*    Aims

To make iterative metallic sound; attacking grain; make controllable by Pdef;
Stereo;
Rate variable by ?
Pos variable by?

*/
                                // load sound into buffer



~chatBufL = Buffer.readChannel(s,"F:/User Library/Samples/Instrument_Samples/SynthHarpOrgan/Synth Harp D2.wav", channels: [0] );
~chatBufL.play;
~chatBufL.free;


~chatBufR = Buffer.readChannel(s,"D:/Cubase 5 Projects/Solaris/Audio/SpringPad Mid B.wav", channels: [1] );
~chatBufR.play;
~chatBufR.free;



                                // create grain envelope



(
var winenv = Env([0, 1, 1, 0], [0.3, 0.4, 0.3], [-3, 1, 3]).discretize;
~grainEnv = Buffer.sendCollection(s, winenv, 1);
)
~grainEnv.plot;
~grainEnv.free;

//([0, 1, 0], [0.5, 0.5], [8, -8])



                                    // SynthDef Mono

(
SynthDef.new(\chatterGrain, {
	arg rate=1, tRate=5, grainLenMin=0.5, grainLenMax=0.6,grainVarRate=0.5,
	sndBuf, envbufnum= -1, amp=0.1, pan=0, tRateMin=4, tRateMax=6,
	tRateVibRate=1, posChangePerSec=0.01, posMin=0.1, posMax=0.2,
	panMin= -1.0, panMax=1.0, randSize=0.1;
	var sig, trig, sampleChangePerSec, pos, randPos;
	randPos = LFNoise0.ar(500, mul: randSize);
	pos = Phasor.ar(1, posChangePerSec/SampleRate.ir, posMin, posMax) + randPos;
	trig = Impulse.ar(LFCub.kr(tRateVibRate).range(tRateMin, tRateMax));
	sig = GrainBuf.ar(
		2,
		trig,
		SinOsc.kr(grainVarRate).range(grainLenMin, grainLenMax),
		sndBuf,
		rate,
		pos,
		4,
		TRand.ar(panMin, panMax, trig),
		envbufnum,
		mul: amp
	);
	Out.ar(0, sig);
}).add;
)
                                 // Create Mono Synth and set

(
x = Synth.new(\chatterGrain, [\sndBuf, ~chatBufL,\pos, 0.4,
	\grainLen, 0.05, \tRateMin, 16, \tRateMax, 18, \envbufnum, -1]);
)
(
x.set(
	\rate, 1,
	\tRateMin, 80,
	\tRateMax, 100,
	\tRateVibRate, 1,
	\posMin, 0.2,
	\posMax, 0.9,
	\posChangePerSec, 0.01,
	\randSize, 0.01,
	\amp, 0.5,
	\panMin, -1,
	\panMax, 1,
	\grainVarRate, 0.2 ,
	\grainLenMin, 0.1,
	\grainLenMax, 0.2,
);
)
x.free;
s.meter;




                                    // SynthDef Stereo

(
SynthDef.new(\chatterGrainStereo, {
	arg rate=1, grainLen=0.5, sndBufL, sndBufR,
	envbufnum= -1, amp=0.3, tRateMin=4, tRateMax=6,
	tRateVibRate=1, posChangePerSec=0.1, posMin=0.1, posMax=0.9,
	panMin= -0.5, panMax=0.5, panWidth=1.0;
	var sigL, sigR, panL, panR, pos, sig, pan, trig;
	trig = Impulse.ar(LFCub.kr(tRateVibRate).range(tRateMin, tRateMax));
	pan = TRand.ar(panMin, panMax, trig);
	panL = pan - panWidth/2;
	panR = pan + panWidth/2;
	pos = Phasor.ar(1, posChangePerSec/SampleRate.ir, posMin, posMax );
	sigL = GrainBuf.ar(
		2,
		trig,
		grainLen,
		sndBufL,
		rate,
		pos,
		4,
		panL,
		envbufnum,
		mul: amp
	);
	sigR = GrainBuf.ar(
		2,
		trig,
		grainLen,
		sndBufR,
		rate,
		pos,
		4,
		panR,
		envbufnum,
		mul: amp

	);
	Out.ar(0, sigL);
	Out.ar(0, sigR);
}).add;
)



                                 // Create Stereo Synth and set

(
y = Synth.new(\chatterGrainStereo, [\sndBufL, ~chatBufL , \sndBufR, ~chatBufR,
\envbufnum, -1]);
)
(
y.set(\rate, 1.0,
	\tRate, 10,
	\grainLen, 0.06,
	\amp, 0.5,
	\tRateMin, 10,
	\tRateMax, 15,
	\tRateVibRate, 0.7,
	\posChangePerSec, 0.02,
	\posMin, 0.08,
	\posMax, 0.15,
	\panMin, -0.5,
	\panMax, 0.5,
	\panWidth, 1.0);
)
x.free;
s.meter;






                                 // Pdef to control granulation

(
Pdef(
	\chatterPat,
	Pmono(
		\chatterGrain,
		//\sndBuf, ~chatBufL,
		\delta, 0.1,
		\tRate, Pseq([1.0, 1.1, 1.2, 1.3, 1.2, 1.1, 1.0],inf)*20,
		\grainLen, Pwhite(0.4, 0.6, inf)*0.2,
		\rate, Pwhite(0.9, 1.1, inf),
		\pos, Pwhite(0.4,0.42, inf),
		\pan, Pwhite(-0.2, 0.2, inf),
		\db, -6
	);
).play;


)


//set quant    - .play(quant:1.875);
//change pdef  - .quant_(1.875);
