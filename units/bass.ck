BPM tempo;

LPF lpf;
ADSR adsr;

SawOsc bass => lpf => adsr => Gain master => dac;
SqrOsc sub => lpf => adsr => master;

[36, 32, 29, 31] @=> int notes[];

tempo.note => dur noteDuration;

1 => lpf.Q;

.2 => sub.gain;
.2 => master.gain;

/// Functions

function void sweepFilter(LPF f, dur t) {

}

/// Main

while(true) {
    for (0 => int step; step < notes.cap(); step++) {
        adsr.set(noteDuration * Math.random2f(.05, 0.1), noteDuration * .2, .8, noteDuration * .1);           

        Std.mtof(notes[step]) => bass.freq;
        bass.freq() * .5 => sub.freq;
        (bass.freq() * 2) * 2 => lpf.freq;

        adsr.keyOn();
        noteDuration * .8 => now;
        adsr.keyOff();
        noteDuration * .2 => now;
    }
}