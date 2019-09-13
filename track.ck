BPM tempo;

.8 => dac.gain;
tempo.setBPM(110.0);

Drums drums;
ARP arp;

drums.play(0);
tempo.note * 8 => now;
drums.play(1);
arp.play();
tempo.note * 16 => now;
drums.play(2);
tempo.note * 8 => now;
drums.play(1);
tempo.note * 16 => now;
drums.play(2);
tempo.note * 16 => now;
drums.play(1);
tempo.note * 8 => now;
drums.play(0);
tempo.note * 8 => now;