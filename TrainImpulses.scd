(
SynthDef.new(\dustAud,{
	arg freq=40, out=0, amp=0.1;
	var sig;
	sig = Dust.ar(freq, amp);
	Out.ar(out, sig);
}).add;


SynthDef.new(\dustCtl,{
	arg freq=40, out=0, amp=0.1;
	var sig;
	sig = Dust.kr(freq, amp);
	Out.kr(out, sig);
}).add;


SynthDef.new(\impulseCtl,{
	arg freq=80, out=0, amp=0.2;
	var sig;
	sig = Impulse.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add;

SynthDef.new(\impulseAud,{
	arg freq=80, out=0, amp=0.2;
	var sig;
	sig = Impulse.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add;

SynthDef.new(\sine, {
	arg freq=40, out=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq, mul:amp);
	Out.ar(out, sig);
}).add;

SynthDef.new(\saw, {
	arg freq=40, out=0, amp=0.1, cutOff=300;
	var sig;
	sig = Saw.ar(freq, mul:amp);
	sig = LPF.ar(sig, cutOff);
	Out.ar(out, sig);
}).add;

SynthDef.new(\whiteNoise, {
	arg out=16, amp=0.7;
	var sig;
	sig = WhiteNoise.ar(mul:amp);
	Out.ar(out, sig);
}).add;

SynthDef.new(\pinkNoise, {
	arg out=16, amp=0.7;
	var sig;
	sig = PinkNoise.ar(mul:amp);
	Out.ar(out, sig);
}).add;

SynthDef.new(\pinkNoiseStereo, {
	arg out=16, amp=0.7;
	var sig;
	sig = PinkNoise.ar([amp]!2);
	Out.ar(out, sig);
}).add;

SynthDef.new(\playBufMono, {
	arg out=0, bufnum, amp=0.01, rate=1,
	t_trig=1, startPos=0, doneAction=0, loop=1;
	var sig;
	sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum), t_trig,
		startPos * BufRateScale.kr(bufnum) * BufSampleRate.kr(bufnum) ,
		loop, doneAction) * amp;
	Out.ar(out, sig);
}).add;



SynthDef.new(\playBufStereo, {
	arg out=0, bufnum, amp=0.01, rate=1,
	t_trig=1, startPos=0, doneAction=0, loop=1;
	var sig;
	sig = PlayBuf.ar(2, bufnum, rate * BufRateScale.kr(bufnum), t_trig,
		startPos * BufRateScale.kr(bufnum) * BufSampleRate.kr(bufnum),
		loop, doneAction) * amp;
	Out.ar(out, sig);
}).add;


SynthDef.new(\envErraticStereo, {
	arg in=16, out=0, freq=2, min=0.01, max=0.9;
	var sig;
	sig = In.ar(in, 2) * LFNoise1.kr(freq).exprange(min,max);
	Out.ar(out, sig);
}).add;

SynthDef.new(\envSineStereo, {
	arg in=16, out=0, freq=2, min=0.01, max=0.9;
	var sig;
	sig = In.ar(in, 2) * SinOsc.kr(freq).exprange(min,max);
	Out.ar(out, sig);

}).add;

SynthDef.new(\envTriStereo, {
	arg in=16, out=0, freq=2, min=0.01, max=0.9, waveShape=0.5,
	level=0.1;
	var sig;
	sig = In.ar(in, 2) * VarSaw.kr(freq, waveShape).exprange(min,max)
	* level;
	Out.ar(out, sig);

}).add;



)


























