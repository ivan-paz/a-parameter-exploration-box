////----------------------------------
////----------------------------------
////----------------------------------
////-- 6 knobs and butons interface
////----------------------------------
////----------------------------------
////----------------------------------
////----------------------------------
s.boot;

(
Ndef(\x, {|freq = 440, freq2=660, freq3=528, cutoff = 1000, amp = 0.5, gate=1, out = 0|
	var snd;
	freq = freq + SinOsc.kr(freq*1/2, 0, freq/2, 0);

	snd = Saw.ar([freq, freq+1, freq-1, freq2, freq3] * [0.99,1])*0.1;

	snd = snd + VarSaw.ar(0.99*[freq, freq + 1, freq - 1, freq2, freq3, freq2+1, freq3+1],0, LFTri.kr(7.13).range(0.0,0.2)) * 0.1;

	snd = Mix(snd);
	snd = FreeVerb.ar(snd, 0.51, 0.5, 0.6) * 2;
	snd = snd * 8;
	snd = RLPF.ar(snd, SinOsc.kr([0.1, 2], 0, [1700,480], [4000,700,5000])/[20.51,20], SinOsc.ar(0.1,1.5*pi)+1.05)/3;
	snd = Mix(snd);

	snd = MoogFF.ar(snd, SinOsc.kr(0.08, 0.4, cutoff/1000, cutoff), 3, 0);

	snd = snd * EnvGen.ar(Env.adsr(0.4, 0.01,0.8,0.4), gate, doneAction:2);

	snd = [snd , AllpassC.ar(snd, 0.5, 0.2 + SinOsc.ar(0.2).range(0,0.005), 0.3)];
	snd = snd * amp;
	Out.ar(out,snd)
})
)
Ndef(\x).set(\freq, 100, \freq2, 400, \freq3, 300, \amp, 0.8, \cutoff, 100)
Ndef(\x).set(\gate, 0)
Ndef(\x).play
Ndef(\x).stop

(
//  conexion arduino
s.boot;
p = ArduinoSMS("/dev/tty.usbmodem1421", 9600);
loadRelative("compress_subspaces_function.scd");
)

(
~instances = [];
~splitRules = [];
)

(
p.close;
Ndef(\x).stop;
)

(
var analogPrev0 = 0, analogPrev1=0, analogPrev2 = 0, analogPrev3 = 0, analogPrev4 = 0, analogPrev5 = 0,
digital2Prev = 0,digital3Prev =0, digital4Prev = 0, digital5Prev = 0, digital6Prev = 0, digital7Prev = 0,
keysValues, instance = [], savePlay = 0, selectClass = 0;
p.action = {|... msg|

	~analog0 = msg[0];
	~analog1 = msg[1];
	~analog2 = msg[2];
	~analog3 = msg[3];
	~analog4 = msg[4];
	~analog5 = msg[5];

	~digital2 = msg[6];
	~digital3 = msg[7];
	~digital4 = msg[8];
	~digital5 = msg[9];
	~digital6 = msg[10];
	~digital7 = msg[11];



	if(~digital7 != digital7Prev){
		digital7Prev = ~digital7;
		if(digital7Prev ==1){savePlay = savePlay + 1}
	};
	if(savePlay % 2 == 0){//switch   //--EXPLORING MODE



		if(~analog0 != analogPrev0){
			msg.postln;
			analogPrev0 = ~analog0;
			Ndef(\x).set(\freq, analogPrev0.linlin(0,1023,0,1000))
		};
		if(~analog1 != analogPrev1){
			//msg.postln;
			analogPrev1 = ~analog1;
			Ndef(\x).set(\freq2, analogPrev1.linlin(0,1023, 0,2000) )
		};
		if(~analog2 != analogPrev2){
			//msg.postln;
			analogPrev2 = ~analog2;
			Ndef(\x).set(\freq3, analogPrev2.linlin(0,1023,0,10000) )
		};
		if(~analog3 != analogPrev3){
			//msg.postln;
			analogPrev3 = ~analog3;
			Ndef(\x).set(\cutoff, analogPrev3.linlin(0,1023,50,10000) )
		};
		if(~analog4 != analogPrev4){
			//msg.postln;
			analogPrev4 = ~analog4;
			Ndef(\x).set(\amp, analogPrev4.linlin(0,1023,0,1) )
		};
		if(~analog5 != analogPrev5){
			//msg.postln;
			analogPrev5 = ~analog5;
			//Ndef(\x).set(\amp, analogPrev5.linlin(0,1023,0,1) )
		};

		//Compression
		if(~digital6 != digital6Prev){
			digital6Prev = ~digital6;
			~classes = ~countClasses.value(~instances);
			~acceptableDifference = ~maxParametersRange.value(~instances);
			'compressing . . . '.postln;
			~compressedInstances = ~uncompletedClassesCompression.value(~instances, ~classes);
			~bag = ~bagOfRules_uncompleted.value(~compressedInstances);
			~splitRules = ~splitRules_uncompleted.value(~bag);
			~splitRules.do{ |x,i| 'Rules class '.post; (i+1).postln; x.do{ |y| y.postln};
				if(x.size == 0){'there are no rules for class: '.post; (i+1).postln}};
		};

		//CLASS1
		if(~digital2 != digital2Prev){
			msg.postln; digital2Prev = ~digital2;
			keysValues = Ndef(\x).getKeysValues;
			keysValues.do{|key| instance = instance.add(key[1])};
			instance = instance.add(1);
			'instance  : '.post; instance.postln;
			if(~instances.includesEqual(instance)){'already saved!'.postln}
			{'salved!'.postln; ~instances = ~instances.add(instance)};
			instance = []
		};
		//CLASS2
		if(~digital3 != digital3Prev){
			msg.postln; digital3Prev = ~digital3;
			keysValues = Ndef(\x).getKeysValues;
			keysValues.do{ |key|
				instance = instance.add(key[1]);
			};
			instance = instance.add(2);
			'instance  : '.post; instance.postln;
			if(~instances.includesEqual(instance)){'already saved!'.postln}
			{'salved!'.postln; ~instances = ~instances.add(instance)};
			instance = []
		};
		//CLASS3
		if(~digital4 != digital4Prev){
			msg.postln; digital4Prev = ~digital4;
			keysValues = Ndef(\x).getKeysValues;
			keysValues.do{ |key|
				instance = instance.add(key[1]);
			};
			instance = instance.add(3);
			'instance  : '.post; instance.postln;
			if(~instances.includesEqual(instance)){'already saved!'.postln}
			{'salved!'.postln; ~instances = ~instances.add(instance)};
			instance = []
		};
		//CLASS4
		if(~digital5 != digital5Prev){
			msg.postln; digital5Prev = ~digital5;
			keysValues = Ndef(\x).getKeysValues;
			keysValues.do{ |key|
				instance = instance.add(key[1]);
			};
			instance = instance.add(4);
			'instance  : '.post; instance.postln;
			if(~instances.includesEqual(instance)){'already saved!'.postln}
			{'salved!'.postln; ~instances = ~instances.add(instance)};
			instance = []
		};
	}//--switch
	{   // PLAY MODE
		var rule, keys;
		//'playing mode'.postln;
		if(~splitRules.notNil){

			//class1 rules
		if(~analog0 != analogPrev0){
			analogPrev0 = ~analog0;
			analogPrev0 = analogPrev0.linlin(0,1023, 0,~splitRules[0].size -1).round;
			rule = ~splitRules[0][analogPrev0];
			[analogPrev0,rule].postln;
			keys = [];
			rule.do{|x|
				var val;
				if(x.class==Array){val=x.choose; keys = keys.add(val)}{keys = keys.add(x)}
			};
			//keys.postln;
			Ndef(\x).set(\freq,keys[0],\freq2, keys[1], \freq3, keys[2],\cutoff, keys[3], \amp, keys[4])
		};

			//class 2 rules
		if(~analog1 != analogPrev1){
			analogPrev1 = ~analog1;
			analogPrev1 = analogPrev1.linlin(0,1023, 0, ~splitRules[1].size -1).round;
			rule = ~splitRules[1][analogPrev1];
			[analogPrev1,rule].postln;
			keys = [];
			rule.do{ |x|
				var val;
				if(x.class==Array){val=x.choose; keys = keys.add(val)}{keys = keys.add(x)}
			};
			//keys.postln;
				Ndef(\x).set(\freq,keys[0],\freq2, keys[1], \freq3, keys[2],\cutoff, keys[3], \amp, keys[4])		};

			//class 3 rules
		if(~analog2 != analogPrev2){
			analogPrev2 = ~analog2;
			analogPrev2 = analogPrev2.linlin(0,1023, 0, ~splitRules[2].size -1).round;
			rule = ~splitRules[2][analogPrev2];
			[analogPrev1,rule].postln;
			keys = [];
			rule.do{ |x|
				var val;
				if(x.class==Array){val=x.choose; keys = keys.add(val)}{keys = keys.add(x)}
			};
			//keys.postln;
			Ndef(\x).set(\freq,keys[0],\freq2, keys[1], \freq3, keys[2],\cutoff, keys[3], \amp, keys[4])
		};
			//class 4 rules
		if(~analog3 != analogPrev3){
			analogPrev2 = ~analog3;
			analogPrev2 = analogPrev3.linlin(0,1023, 0, ~splitRules[2].size -1).round;
			rule = ~splitRules[3][analogPrev3];
			[analogPrev1,rule].postln;
			keys = [];
			rule.do{ |x|
				var val;
				if(x.class==Array){val = x.choose; keys = keys.add(val)}{keys = keys.add(x)}
			};
			//keys.postln;
			Ndef(\x).set(\freq,keys[0],\freq2, keys[1], \freq3, keys[2],\cutoff, keys[3], \amp, keys[4])
		};

			//Introduce here modifications in the playing mode

		}

	}


};
Ndef(\x).play
)


(
p.close;
Ndef(\x).stop;
)























