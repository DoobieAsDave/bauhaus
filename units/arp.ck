public class ARP {
    BPM tempo;

    ADSR env;
    Echo echo;

    SinOsc sin => env => echo => NRev rev => BPF bpf => Gain master => dac;
    echo => Gain feedback => echo;

    SqrOsc ftf => env => echo => master;
    TriOsc oct => env => echo => master;
    SawOsc sub => LPF lpf => master;

    400 :: ms => echo.max;
    .2 => echo.mix;

    .2 => lpf.Q;

    .05 => ftf.gain => oct.gain => sub.gain;
    .05 => master.gain;

    int notes[4];

    function void play() {       
       spork ~ arpeggiator();
    }

    function void arpeggiator() {
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
                    env.set(Math.random2(20, 75) :: ms, Math.random2(5, 100) :: ms, Math.random2f(.2, .5), Math.random2(5, 400) :: ms);

                    Math.random2(250, 400) :: ms => echo.delay;             
                    Math.random2f(.1, .3) => feedback.gain;

                    Math.random2f(.2, .45) => rev.mix;

                    notes[Math.random2(0, notes.cap() - 1)] * Math.random2(1, 2) => bpf.freq;
                    Math.random2f(.3, .6) => bpf.Q;

                    for (0 => int step; step < notes.cap(); step++) {
                        Std.mtof(notes[step]) => sin.freq;
                        sin.freq() * 1.5 => ftf.freq;
                        sin.freq() * 2 => oct.freq;                
                        (sin.freq() * .5) * .5 => sub.freq;

                        sub.freq() + 10.0 => lpf.freq;

                        env.keyOn();                    
                        tempo.thirtiethNote => now;
                        env.keyOff();
                        tempo.thirtiethNote => now;
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
}