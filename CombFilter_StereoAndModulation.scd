

                             // Buffer and Buses



~soundComb = Buffer.read(s,"D:/Reaper/Train/Audio Files/ProcessedSounds/drumCombKlank_1_Bubbler_Cloud_1.wav");
~soundComb.free;
~soundComb.play;

Buffer.freeAll;

~combInStereo = Bus.audio(s, 2);

s.meter;
s.plotTree;



                                 // Synths

(
SynthDef.new(\playBufStereo, {
	arg out=0, bufnum, amp=0.01, rate=1,
	t_trig=1, startPos=0, doneAction=0, loop=1;
	var sig;
	sig = PlayBuf.ar(2, bufnum, rate * BufRateScale.kr(bufnum), t_trig,
		startPos * BufRateScale.kr(bufnum) * BufSampleRate.kr(bufnum),
		loop, doneAction) * amp;
	Out.ar(out, sig);
}).add;



SynthDef.new(\multiCombMod, {
	arg exIn,maxDelay=0.5, out=0,
	freq1=200,  decayTime1=0.5, amp1=0.2,
	freq2=500,  decayTime2=0.5, amp2=0.2,
	freq3=1000, decayTime3=0.5, amp3=0.2,
	freq4=2000, decayTime4=0.5, amp4=0.2,
	original = 0.1,
	fmodAmount=0, fmodRate=0.01,
	dmodRate=1, dmodAmount=0,
	aModRate=1, aModAmount=0;

	var sig, tempL, thru, sumL, freqMod, freq, dt, amp,
	sumR, tempR, left, right, busIn;



	left = ~combInStereo.subBus(0,1);
	right = ~combInStereo.subBus(1,1);

	//thru = In.ar(exIn, 2) * original;
	sumL = 0; sumR = 0;
	freq = [freq1, freq2, freq3, freq4];
	dt = [decayTime1, decayTime2, decayTime3, decayTime4];
	amp = [amp1, amp2, amp3, amp4];

	4.do{
		arg count;
		tempL = CombC.ar(
			In.ar(left, 1),
			maxDelay,
			freq[count].reciprocal * (1 + LFNoise1.kr(fmodRate, mul: fmodAmount)),
			dt[count] * (1 +LFNoise1.kr(dmodRate, dmodAmount)),
			amp[count] * (1 +LFNoise1.kr(aModRate, aModAmount))
		);
		sumL = tempL + sumL;
	};
		4.do{
		arg count;
		tempR = CombC.ar(
			In.ar(right, 1),
			maxDelay,
			freq[count].reciprocal * (1 + LFNoise1.kr(fmodRate, mul: fmodAmount)),
			dt[count] * (1 +LFNoise1.kr(dmodRate, dmodAmount)),
			amp[count] * (1 +LFNoise1.kr(aModRate, aModAmount))
		);
		sumR = tempR + sumR;
	};

	Out.ar(out, [sumL, sumR]);

}).add;

SynthDef.new(\multiCombModFilter, {
	arg exIn,maxDelay=0.5, out=0,
	freq1=200,  decayTime1=0.5, amp1=0.2,
	freq2=500,  decayTime2=0.5, amp2=0.2,
	freq3=1000, decayTime3=0.5, amp3=0.2,
	freq4=2000, decayTime4=0.5, amp4=0.2,
	filter1=150, filter2=600, filter3=2000, filter4=1000,
	original = 0.1,
	fmodAmount=0, fmodRate=0.01,
	dmodRate=1, dmodAmount=0,
	aModRate=1, aModAmount=0,
	bw=0.2, volume=0.5;

	var sig, tempL, thru, sumL, freqMod, freq, dt, amp,
	sumR, tempR, left, right, busIn, fill;

	fill = `[filter1, filter2, filter3, filter4];

	left = ~combInStereo.subBus(0,1);
	right = ~combInStereo.subBus(1,1);

	//thru = In.ar(exIn, 2) * original;
	sumL = 0; sumR = 0;
	freq = [freq1, freq2, freq3, freq4];
	dt = [decayTime1, decayTime2, decayTime3, decayTime4];
	amp = [amp1, amp2, amp3, amp4];

	4.do{
		arg count;
		tempL = CombC.ar(
			BBandPass.ar(In.ar(left, 1), fill[count], bw),
			maxDelay,
			freq[count].reciprocal * (1 + LFNoise1.kr(fmodRate, mul: fmodAmount)),
			dt[count] * (1 +LFNoise1.kr(dmodRate, dmodAmount)),
			amp[count] * (1 +LFNoise1.kr(aModRate, aModAmount))
		);
		sumL = tempL + sumL;
		sumL = sumL * volume;
	};
		4.do{
		arg count;
		tempR = CombC.ar(
			BBandPass.ar(In.ar(right, 1), fill[count].postln, bw),
			maxDelay,
			freq[count].reciprocal * (1 + LFNoise1.kr(fmodRate, mul: fmodAmount)),
			dt[count] * (1 +LFNoise1.kr(dmodRate, dmodAmount)),
			amp[count] * (1 +LFNoise1.kr(aModRate, aModAmount))
		);
		sumR = tempR + sumR;
		sumR = sumR * volume;
	};

	Out.ar(out, [sumL, sumR]);

}).add;
)




                           // create and set synths


z = Synth.new(\multiCombModFilter, [\exIn, ~combInStereo]);
y = Synth.new(\playBufStereo, [\out, ~combInStereo, \bufnum, ~soundComb]);

(
z.set(\freq1, 2000, \decayTime1, 0.3, \amp1, 0.2, \filter1, 2000,
	\freq2,9000,  \decayTime2, 0.3, \amp2, 0.0, \filter2, 9000,
	\freq3, 3000, \decayTime3, 0.3, \amp3, 0.2, \filter3, 3000,
	\freq4, 1500, \decayTime4, 0.3, \amp4, 0.05, \filter4, 1500,
	\original, 1.0,
	\fmodRate, 0.1, \fmodAmount, 0,
	\dmodRate, 1.0, \dmodAmount, 0.1,
	\aModRate, 0.2, \aModAmount, 0.1,
	\bw, 0.1,
	\volume, 0.7,
);
)



y.set(\amp, 1.0);
y.set(\loop, 1);
y.set(\t_trig, 1);
y.free;




