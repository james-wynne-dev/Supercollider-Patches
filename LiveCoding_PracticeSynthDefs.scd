(


SynthDef.new(\hat, {
	arg amp=0.5, rel=0.2, bw=1, freq = 2000, pan= -0.5;
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01,rel), doneAction:2);
	sig = BBandPass.ar(WhiteNoise.ar(amp), freq, bw) * env;
	Out.ar(0, Pan2.ar(sig,pan));
}).add;

SynthDef.new(\snare, {
	arg amp=0.5, rel=0.2, freq = 2000, pan= -0.5, rq=1, send=0.5;
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01,rel), doneAction:2);
	sig = WhiteNoise.ar(amp) * env;
	sig = BLowPass.ar(sig, freq, rq);
	sig = Pan2.ar(sig,pan);
	Out.ar(~send, sig * send);
	Out.ar(0, sig);
}).add;


SynthDef.new(\klank, {
	arg freq=200, gate=1, rate=0.2, decScale=1, verb=0.5, amp=0.2;
	var sig, imp, env;

	env = EnvGen.kr(Env.asr(1,1,2),gate,doneAction:2);

	imp = PinkNoise.ar(LFNoise1.kr(rate!2).exprange(0.001, 0.01)) ;

	sig = Klank.ar(
		`[[freq, freq*2, freq*3, freq*4, freq*5],
			[1, 0.5, 0.25, 0.2, 0.15],
			[1, 1, 1, 1, 1]],
		imp,
		decScale
	) * env * amp;

	sig = HPF.ar(sig,freq);
	sig = LPF.ar(sig, freq*3);

	Out.ar(~send, sig * verb);
	Out.ar(0, sig);
}).add;




SynthDef.new(\sinePerc, {
	arg freq, rel=1,amp=0.5,pan=0, fltF=2000, delay=0.2;
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, rel),doneAction:2);
	sig = LFTri.ar(freq, mul:amp);
	sig = BLowPass4.ar(sig, fltF);
	sig = sig * env;
	Out.ar(~delayIn, sig*delay);
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);

}).add;



SynthDef.new(\bass, {
	arg freq, amp;
	var sig1, sig2, env, temp, sig;

	env = EnvGen.kr(Env.perc(0.01,5), doneAction:2);

	sig1 = Pulse.ar(
		freq * LFNoise1.ar(0.5).exprange(0.99,1.01),  // freq
		LFNoise1.ar(0.5).exprange(0.1,0.8)  // width
	);

	sig2 = VarSaw.ar(
		freq * LFNoise1.ar(0.5).exprange(0.99,1.01),
		0,
		LFNoise1.ar(0.5).range(0.2,0.8)
	);

	//sig1 = LPF.ar(Pan2.ar(sig1, env * -1), env * 5000 + 2000);
	//sig2 = LPF.ar(Pan2.ar(sig1, env * 1), env * 5000 + 2000);

	sig = Pan2.ar(BLowPass4.ar((sig1 + sig2), 500 + (env * 2000),1),0) * env * amp;

	Out.ar(0, sig);
}).add;



SynthDef.new(\bDrum,{
	arg amp = 0.5, pan=0, freq=50;
	var env, sig;
	env = EnvGen.kr(Env.perc(0.007,0.05), doneAction:2);
	sig = SinOsc.ar(freq * LFNoise1.ar(10, 0.1), 0.5pi, 0.5) * env * amp;
	sig = Pan2.ar(sig,pan);
	Out.ar(0, sig);
}).add;


)

