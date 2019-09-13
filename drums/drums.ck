public class Drums
{
    BPM tempo;

    SndBuf kick => JCRev kickRev => Gain master;
    SndBuf snare => NRev snareRev => master;
    SndBuf clap => Echo clapEcho => master;
    clapEcho => Gain clapFeedback => master;

    SndBuf hihat => Gain hihatVelo => master;
    SndBuf lowhat => Gain lowhatVelo => master;
    SndBuf openhat => Gain openhatVelo => master;

    master => dac;

    [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0] @=> int kickPattern[];
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0] @=> int snarePattern[];
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] @=> int hihatPattern[];
    [0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1] @=> int lowhatPattern[];
    [0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0] @=> int openhatPattern[];

    me.dir(-1) + "audio/kick.wav" => kick.read;
    me.dir(-1) + "audio/snare.wav" => snare.read;
    me.dir(-1) + "audio/clap.wav" => clap.read;
    me.dir(-1) + "audio/hihat.wav" => hihat.read;
    me.dir(-1) + "audio/lowhat.wav" => lowhat.read;
    me.dir(-1) + "audio/openhat.wav" => openhat.read;

    kick.samples() => kick.pos;
    snare.samples() => snare.pos;
    clap.samples() => clap.pos;
    hihat.samples() => hihat.pos;
    lowhat.samples() => lowhat.pos;
    openhat.samples() => openhat.pos;

    .02 => kickRev.mix;
    .1 => snareRev.mix;

    1.2 => openhat.rate;

    .1 => hihat.gain;
    .3 => lowhat.gain;
    .3 => openhatVelo.gain;

    .75 => master.gain;

    function void play(int mode) {
        if (mode == 0) {
            spork ~ intro();
        }
        else if (mode == 1) {
            spork ~ main();
        }
        else {
            spork ~ accent();
        }
    } 

    function void intro() {
        while(true) {
            for (0 => int step; step < kickPattern.cap(); step++) {
                if (kickPattern[step]) {
                    if (!snarePattern[step]) { 1 => kick.gain; }
                    else { .5 => kick.gain; }

                    0 => kick.pos;
                }
                if (snarePattern[step]) { 0 => snare.pos; }                
                
                tempo.sixteenthNote => now;
            }
        }
    }

    function void main() {
        while(true) {
            for (0 => int step; step < kickPattern.cap(); step++) {
                if (kickPattern[step]) {
                    if (!snarePattern[step]) { 1 => kick.gain; }
                    else { .5 => kick.gain; }

                    0 => kick.pos;
                }
                if (snarePattern[step]) { 0 => snare.pos; }
                if (hihatPattern[step]) { 0 => hihat.pos; }
                if (lowhatPattern[step]) { 0 => lowhat.pos; }
                if (openhatPattern[step]) { 0 => openhat.pos; }
                
                tempo.sixteenthNote => now;
            }
        }
    } 

    function void accent() {
        while(true) {
            for (0 => int step; step < kickPattern.cap(); step++) {
                if (kickPattern[step]) {
                    if (!snarePattern[step]) { 1 => kick.gain; }
                    else { .5 => kick.gain; }

                    0 => kick.pos;
                }
                if (snarePattern[step]) { 0 => snare.pos; }
                if (hihatPattern[step]) { 0 => hihat.pos; }
                if (lowhatPattern[step]) { 0 => lowhat.pos; }
                if (openhatPattern[step]) { 0 => openhat.pos; }

                if (step % 3 == 0) { 0 => lowhat.pos; }                
                
                tempo.sixteenthNote => now;
            }
        }
    }      
}


