# Pulse-Code-Modulation-PCM-Simulator

This folder compresses our communication theory project, it's a Pulse code modulator/demodulator
It contains a .m for each function block of the pulse code modulator:
1-Sampler.m --> Sampling
2-UQuantizer.m --> Uniform Quantization
3-NUQuantizer.m --> Non-Uniform Quantization
4-Encoder.m
5.Decoder.m
6.Reconstruction.m

In addition to that, another .m file "main_Pro" is found. It utilizes those functions
It allows the user to enter a signal and its corresponding time array.
The User also enters the sampling frequency(fs), the number of levels(L), the maximum amplitude of the quantizer(mp).
The User enters the type of quantizer to be used whether Uniform or non-uniform.
He/she chooses on type of encoding for the encoder.  

