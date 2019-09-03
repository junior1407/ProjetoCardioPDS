Fs = 1000;
t = linspace(0,1,Fs);
x = cos(2*pi*100*t)+0.5*randn(size(t));

K = triang(Fs+1)
fc = 150;
Wn = (2/Fs)*fc;
b = fir1(Fs,Wn,'low',kaiser(Fs+1,3));

fvtool(b,1,'Fs',Fs)
*
y = filter(b,1,x);

plot(t,x,t,y)
xlim([0 0.1])

xlabel('Time (s)')
ylabel('Amplitude')
legend('Original Signal','Filtered Data')