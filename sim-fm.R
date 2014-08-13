# Low Pass Filter (LPF)
lpf <- function(signal, time, cutoff, smplfreq){
	offset <- min(signal)
	if(offset>0){
		offset = 0
	}
	spec <- fft(signal + abs(offset))
	idx = cutoff/(smplfreq/length(signal))
	spec[idx:length(spec)] = 0
	abs(fft(spec, inverse=TRUE))/length(spec)+offset 
}

N <- 10000 # Sampling Frequency
t <- 1:N/N # Time
C = 1	 # Carrier Amplitude
fc= 30     # Carrier Frequency
m = 0.2    # Signal Amplitude
fs= 3	 # Signal Frequency
fl= fc     # Local Osc Freq

wc = 2*pi*fc
ws = 2*pi*fs

# FM Modulation
Vfm <- C*sin(wc*t + m*sin(ws*t))

# I/Q Modulation
I = Vfm*sin(wc*t)
Q = Vfm*cos(wc*t)

# Apply LPF
I2 <- lpf(I, t, fs*3, N)
Q2 <- lpf(Q, t, fs*3, N)

# Demodulation signal
Vdm <- atan(Q2/I2)/m
