BPM bpm;

SinOsc sin => Gain master => BPF bpf => dac;

SqrOsc ftf => master;
TriOsc oct => master;
SawOsc sub => LPF lpf => master;

1.0 / 4.0 => master.gain;

Std.mtof(60) => bpf.freq;
.3 => bpf.Q;

Std.mtof(48) => float sweepMin;
Std.mtof(96) => float sweepMax;
sweepMax - sweepMin => float sweepRange;

int notes[4];

while(true) {
    for (0 => int part; part < 4; part ++) {        
        if (part < 2) {
            [48, 51, 55, 58] @=> notes;
        }
        else {
            if (part == 2) {
                for (0 => int index; index < notes.cap(); index++) {
                    4 -=> notes[index];
                }
            }
            else {
                for (0 => int index; index < notes.cap(); index++) {
                    2 -=> notes[index];
                }
            }
        }        

        for (0 => int beat; beat < 4; beat++) {
            for (0 => int step; step < notes.cap(); step++) {                
                Std.mtof(notes[step]) => sin.freq;
                sin.freq() * 1.5 => ftf.freq;
                sin.freq() * 2 => oct.freq;                
                (sin.freq() * .5) * .5 => sub.freq;

                sub.freq() * 2 => lpf.freq;

                now + bpm.sixteenthNote => time then;
                then - bpm.thirtiethNote => time halfThen;                

                while(now < then) {
                    if (now < halfThen) {
                        if (bpf.freq() < sweepMax) {
                            (sweepMax - bpf.freq()) / 2 => float crement;

                            bpf.freq() + crement => bpf.freq;
                        }                      
                    }
                    else {
                        if (bpf.freq() > sweepMin) {
                            (bpf.freq() - sweepMin) / 2 => float crement;

                            bpf.freq() - crement => bpf.freq;
                        }
                    } 

                    <<< bpf.freq() >>>;         

                    bpm.sixteenthNote => now;
                }           
            }

            if (beat < 2) {   
                addOctave();

                if (beat == 1) {
                    reverseArray();
                }
            }
            else {            
                removeOctave();
            }
        }
    }
}

function void addOctave() {
    for (0 => int index; index < notes.cap(); index++) {
        12 +=> notes[index];
    }
}
function void removeOctave() {
    for (0 => int index; index < notes.cap(); index++) {
        12 -=> notes[index];
    }
}

function void reverseArray() {
    int notesCopy[4];

    0 => int notesIndex;
    for (notes.cap() - 1 => int index; index >= 0; index--) {
        notes[index] => notesCopy[notesIndex];
        notesIndex++;
    }

    notesCopy @=> notes;    
}

///

//(bpm.thirtiethNote / 2) / 2 => now;
                //(bpm.thirtiethNote / 3) / 2 => now;
                
                /* if (beat == 3 && step == (notes.cap() - 1) && Math.random2(0, 1)) {
                    now + bpm.sixteenthNote => time then;

                    while(now < then) {
                        <<< " hit" >>>;
                        Math.random2f(.5, 1.0) => ftf.gain;
                        Math.random2f(.5, 1.0) => oct.gain;
                        bpm.thirtiethNote / 2 => now;
                        1 => ftf.gain => oct.gain;
                        bpm.thirtiethNote / 2 => now;
                    }                
                }
                else {
                    bpm.sixteenthNote => now;
                } */