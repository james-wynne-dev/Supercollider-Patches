~beat = 60/120;
q = 4 * ~beat;
s.meter;
s.plotTree;

// Bass Drum
(
SynthDef.new(\BD, {
	// oscillator 1 args
	arg f1=50, osc1Amp=0.5,
	atk=0.01, rel=0.01,
	pEnv1St=1.4, pEnv1Dur=0.1,
	fm=30, fmMin=0.9, fmMax=1.1,

	// oscillator2 args
	f2=80, osc2Amp=0.3,
	atk2=0.01, rel2=0.01,
	pEnv2St=1.4, pEnv2Dur=0.1,
	fm2=30, fm2Min=0.9, fm2Max=1.1;

	var sig, env, env2, osc1, osc2, pEnv1, pEnv2;

	// ocillator 1 with fm and pitch envelope
	pEnv1 = XLine.kr(pEnv1St,1,pEnv1Dur);
	f1 = f1 * SinOsc.kr(fm * pEnv1).exprange(fmMin,fmMax);
	env = EnvGen.kr(Env.perc(atk, rel),doneAction:2);
	osc1 = SinOsc.ar(f1 * pEnv1) * osc1Amp;

	// oscillator 2 with fm and pitch envelope
	pEnv2 = XLine.kr(pEnv2St,1,pEnv2Dur);
	f2 = f2 * SinOsc.kr(fm2 * pEnv2).exprange(fm2Min,fm2Max);
	env2 = EnvGen.kr(Env.perc(atk2, rel2));
	osc2 = SinOsc.ar(f2 * pEnv2) * env2 * osc2Amp;

	// sum oscillators and output
	sig = osc1 + osc2 * env;
	Out.ar(0, Pan2.ar(sig))
}).add;


SynthDef.new(\bass,{
	arg freq=50, amp=0.2, numharm=30, cutoff=600,
	atk=0.1,decay=0.2,sus=0.6,rel=0.3, rq=1, t_gate=0;
	var sig, env, width;
	width = LFTri.kr(0.5).range(0.1,0.9);
	env = EnvGen.kr(Env.perc(atk,rel),t_gate);
	sig = {
		VarSaw.ar(
			freq * LFNoise1.kr(1).exprange(0.99,1.01),
			0,
			LFNoise1.kr(0.2).exprange(0.1,0.9)
		)
	}!2;
	// sig = Splay.ar(sig);
	sig = RLPF.ar(sig, cutoff,rq);
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig));
}).add;

SynthDef.new(\noiseSnr, {
	arg amp, atk=0.01, rel=0.7;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel), doneAction:2);
	sig = WhiteNoise.ar(amp) * env;
	Out.ar(0, Pan2.ar(sig,0));
}).add;


SynthDef.new(\twinkle, {
	arg freq=440, amp=0.1, atk=0.01,
	rel=0.2, pos=0,	delaytime=0.18, delayAmt=0.3;
	var sig, env, delay, total;
	env = EnvGen.kr(Env.perc(atk,rel),doneAction:2);
	sig = SinOsc.ar(freq);
	sig = sig * env * amp;
	sig = Pan2.ar(sig, pos);
	delay = (delayAmt * DelayC.ar(total + sig, 1,delaytime));
	total = sig + delay;
	Out.ar(0, total);
}).add;

)

(
Pdef(
	\twinkles,
	Pbind(
		\instrument, \twinkle,
		\octave, 6,
		\degree, Pxrand([1,3,5,6,7],inf),
		\scale, Scale.dorian,
		\dur, 1/16,
		\stretch, q,
		\rel,0.5,
		\amp,0.1,
		\pos, Pwhite(-0.8,0.8,inf)
	)
).play(quant:q);
)

(
Pdef(
	\Snr,
	Pbind(
		\instrument, \noiseSnr,
		\dur, Pseq([1/4],inf),
		\stretch, q,
		\amp, Pseq([Rest,0.1],inf)
	);
).play(quant:q);
)


(
~bass = Synth.new(\bass,[\t_gate,1]);

Pdef(\bassSeq,
    Pbind(
		\type, \set,
		\id, ~bass.nodeID,
		\args,[\atk,\decay,\sus,\rel,
		\amp,\cutoff,\rq,\t_gate, \freq],
		\dur, Pseq([1/8],inf),
		\stretch, q,
		\degree, Pseq([Pseq([0],14),5, 8],inf),
		\scale, Scale.dorian,
		\octave, 3,
		\atk,Pwhite(0.01,0.05,inf),
		\decay,Pwhite(0.05,0.1,inf),
		\sus, 0.3,
		\rel, Pwhite(0.8,0.9,inf),
		\amp,Pseq([Pseq([Rest,1],7),1,1],inf) * 0.5,
		\cutoff, Pwhite(800, 1000 ,inf),
		\rq, Pwhite(2,2.5,inf),
		\t_gate, 1
	)
).quant_(q);
)

// .quant_(q)
)
(
Pdef(
	\BDrum,
	Pbind(
		\instrument, \BD,
		\dur, Pseq([1/4, 1/4, 1/4, 1/4],inf),
		\stretch, q,

		// oscillator 1 arguments
		\f1, 52,
		\osc1Amp, 0.6,
		\atk, 0.01,
		\rel, 0.4,
		\pEnv1St, 1.4,
		\pEnv1Dur, 0.4,
	    \fm, 30,
		\fmMin, 0.95,
		\fmMax, 1.05,

	    // oscillator2 args
		\f2, 81,
		\osc2Amp, 0.2,
		\atk2, 0.01,
		\rel2, 0.05,
		\pEnv2St, 1.2,
		\pEnv2Dur, 0.2,
		\fm2, 30,
		\fm2Min, 0.9,
		\fm2Max, 1.1
	);
).play(quant:q);
)
















