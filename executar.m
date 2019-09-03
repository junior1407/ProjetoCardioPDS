clear ;
clc ;
close ;
%%
nome_teste = 'a01'; %pode ser 'a01' ou 'b01' ou 'c01'   
%%
% Propriedades e adicao de ruido
Fs = 1000; % frequencia de amostragem

wfdb2mat(strcat('dados\',nome_teste,'\',nome_teste))
[t , signal ] = rdmat (strcat('dados\',nome_teste,'\',nome_teste,'m')); % importacao do arquivo para variaveis
% internas

ts = (0:1/1000:( size ( signal ,1) -1) /100) ; % criacao do vetor de tempo
ecg = spline (t , signal , ts ); % mudanca da frequencia de amostragem do
%sinal

f_baseline = 0.3; % frequencia do ruido de base
f_60hz = 60; % frequencia do ruido de rede
coeff_60hz = 0.05; % amplitude do ruido de base
coeff_baseline = 0.3; % amplitude do ruido de base
signal_60hz = cos (2* pi * f_60hz * ts ) ;
signal_baseline = cos (2* pi * f_baseline * ts );
noise = coeff_60hz * signal_60hz + coeff_baseline * signal_baseline ; % sinal
%de ruido
ecg_noise = ecg + noise ;
%%
% Imagem do sinal com e sem ruido
figure ('Name','Sinal de ECG original e corrompido','NumberTitle', ...
   'off');
plot ( ts (1:5000) , ecg(1:5000) ,'b');
hold on
plot ( ts (1:5000) , ecg_noise (1:5000) ,'r');
hold off
title ('Sinal de ECG com adicao de ruido');
legend ({'Sinal original','Sinal com adicao de ruido'},'location', ...
   'southeast','FontSize', 20) ;
ylabel ('Amplitude ( mV )');
xlabel ('Tempo (s)');
%%
% Parametros de filtros FIR Highpass
fstop_baseline = 0.3;
fpass_baseline = 2;
fc_baseline = 1.5;
Wstop_baseline = 1;
Wpass_baseline = 0.5;
dens = 20;
N = 500;
flag ='noscale';
beta = 0.5;
%%
% Filtros FIR Highpass
b_baseline_equiripple = firpm (N , [0 fstop_baseline fpass_baseline Fs/2]/( Fs /2) , ...
[0 0 1 1] , [ Wstop_baseline Wpass_baseline ], { dens }) ;
win_baseline_kaiser = kaiser (N +1 , beta ) ;
b_baseline_kaiser = fir1 (N , fc_baseline /( Fs /2) ,'high',...
win_baseline_kaiser , flag );
win_baseline_bartlett = bartlett (N +1) ;
b_baseline_bartlett = fir1 (N , fc_baseline/(Fs/2) ,'high',win_baseline_bartlett , flag ) ;


win_baseline_hamming = hamming ( N +1) ;
b_baseline_hamming = fir1 (N , fc_baseline /( Fs /2) ,'high',...
win_baseline_hamming , flag );
%%
% Parametros de filtros filtros FIR Bandstop
fpass1_60hz = 58.5;
fstop1_60hz = 59.9;
fstop2_60hz = 60.1;
fpass2_60hz = 61.5;
Wpass1_60hz = 0.5;
Wstop_60hz = 20;
Wpass2_60hz = 0.5;
N = 500;
fc1_60hz = 58.5;
fc2_60hz = 61.5;
%%
% Filtros FIR Bandstop
b_60hz_equiripple = firpm (N , [0 fpass1_60hz fstop1_60hz fstop2_60hz fpass2_60hz Fs /2]/( Fs /2) , [1 1 0 0 1 ...
1] , [ Wpass1_60hz Wstop_60hz Wpass2_60hz ] , { dens }) ;
win_60hz_kaiser = kaiser ( N +1 , beta );
b_60hz_kaiser = fir1 (N , [ fc1_60hz fc2_60hz ]/( Fs /2) ,'stop',...
win_60hz_kaiser , flag );
win_60hz_bartlett = bartlett (N +1) ;
b_60hz_bartlett = fir1 (N , [ fc1_60hz fc2_60hz ]/( Fs /2) ,'stop',...
win_60hz_bartlett , flag ) ;
win_60hz_hamming = hamming (N +1) ;
b_60hz_hamming = fir1 (N , [ fc1_60hz fc2_60hz ]/( Fs /2) ,'stop',...
win_60hz_hamming , flag );
%%
% Parametros de filtros IIR Highpass
Astop_baseline = 20;
Apass_baseline = 0.5;
match ='stopband';
%%
% Filtros IIR Highpass
Hd_baseline_butter = designfilt ('highpassiir','StopbandFrequency',...
fstop_baseline , ...
'PassbandFrequency', fpass_baseline ,'StopbandAttenuation',...
Astop_baseline , ...
'PassbandRipple', Apass_baseline ,'SampleRate', Fs ,'DesignMethod',...
'butter');
Hd_baseline_cheby1 = designfilt ('highpassiir','StopbandFrequency',...
fstop_baseline , ...
'PassbandFrequency', fpass_baseline ,'StopbandAttenuation',...
Astop_baseline , ...
'PassbandRipple', Apass_baseline ,'SampleRate', Fs ,'DesignMethod',...
'cheby1');
Hd_baseline_cheby2 = designfilt ('highpassiir','StopbandFrequency',...
fstop_baseline , ...
'PassbandFrequency', fpass_baseline ,'StopbandAttenuation',...
Astop_baseline , ...
'PassbandRipple', Apass_baseline ,'SampleRate', Fs ,'DesignMethod',...
'cheby2');
Hd_baseline_ellip = designfilt ('highpassiir','StopbandFrequency',...
fstop_baseline , ...
'PassbandFrequency', fpass_baseline ,'StopbandAttenuation',...
Astop_baseline , ...
'PassbandRipple', Apass_baseline ,'SampleRate', Fs ,'DesignMethod',...
'ellip');
%%
% Parametros de filtros IIR Bandstop
Apass1_60hz = 0.5;
Astop_60hz = 20;
Apass2_60hz = 0.5;
%%
Hd_60hz_butter = designfilt ('bandstopiir','PassbandFrequency1',...
fpass1_60hz , ...
'StopbandFrequency1', fstop1_60hz ,'StopbandFrequency2', fstop2_60hz, ...
'PassbandFrequency2', fpass2_60hz ,'PassbandRipple1', Apass1_60hz ,...
...
'StopbandAttenuation', Astop_60hz ,'PassbandRipple2', Apass2_60hz ,...
...
'SampleRate', Fs ,'DesignMethod','butter');
Hd_60hz_cheby1 = designfilt ('bandstopiir','PassbandFrequency1',...
fpass1_60hz , ...
'StopbandFrequency1', fstop1_60hz ,'StopbandFrequency2', fstop2_60hz, ...
'PassbandFrequency2', fpass2_60hz ,'PassbandRipple1', Apass1_60hz ,...
...
'StopbandAttenuation', Astop_60hz ,'PassbandRipple2', Apass2_60hz ,...
'SampleRate', Fs ,'DesignMethod','cheby1');
Hd_60hz_cheby2 = designfilt ('bandstopiir','PassbandFrequency1',...
fpass1_60hz , ...
'StopbandFrequency1', fstop1_60hz ,'StopbandFrequency2', fstop2_60hz, ...
'PassbandFrequency2', fpass2_60hz ,'PassbandRipple1', Apass1_60hz ,...
...
'StopbandAttenuation', Astop_60hz ,'PassbandRipple2', Apass2_60hz ,...
...
'SampleRate', Fs ,'DesignMethod','cheby2');
Hd_60hz_ellip = designfilt ('bandstopiir','PassbandFrequency1',...
fpass1_60hz , ...
'StopbandFrequency1', fstop1_60hz ,'StopbandFrequency2', fstop2_60hz, ...
'PassbandFrequency2', fpass2_60hz ,'PassbandRipple1', Apass1_60hz ,...
...
'StopbandAttenuation', Astop_60hz ,'PassbandRipple2', Apass2_60hz ,...
...
'SampleRate', Fs ,'DesignMethod','ellip');
%%
% Aplicacao dos filtros FIR
ecg_equiripple = filtfilt ( b_60hz_equiripple , 1 , filtfilt (...
b_baseline_equiripple , 1 , ecg_noise )) ;
ecg_kaiser = filtfilt ( b_60hz_kaiser , 1, filtfilt ( b_baseline_kaiser , 1 ,...
ecg_noise )) ;
ecg_bartlett = filtfilt ( b_60hz_bartlett , 1 , filtfilt ( b_baseline_bartlett,...
1, ecg_noise ));
ecg_hamming = filtfilt ( b_60hz_hamming , 1 , filtfilt ( b_baseline_hamming ,...
1, ecg_noise ));
%%
% Aplicacao dos filtros IIR
ecg_butter = filtfilt ( Hd_60hz_butter , filtfilt ( Hd_baseline_butter ,...
ecg_noise )) ;
ecg_cheby1 = filtfilt ( Hd_60hz_cheby1 , filtfilt ( Hd_baseline_cheby1 ,...
ecg_noise )) ;
ecg_cheby2 = filtfilt ( Hd_60hz_cheby2 , filtfilt ( Hd_baseline_cheby2 ,...
ecg_noise )) ;
ecg_ellip = filtfilt ( Hd_60hz_ellip , filtfilt ( Hd_baseline_ellip ,...
ecg_noise ) );
%%
% Sinal Equiripple
figure ('Name','Sinal de ECG original e filtrado','NumberTitle','off');
plot ( ts (1:5000) , ecg (1:5000) ,'k');
hold on
plot ( ts (1:5000) , ecg_equiripple (1:5000) ,'m');
hold off
title ('Sinal de ECG filtrado');
legend ({'Sinal original','Sinal filtrado'},'location','southeast','FontSize', 14) ;
ylabel ('Amplitude ( mV )');
xlabel ('Tempo (s)');
%%
% Sinal Kaiser
figure ('Name','Sinal de ECG original e filtrado','NumberTitle','off')
;
plot ( ts (1:5000) , ecg (1:5000) ,'k');
hold on
plot ( ts (1:5000) , ecg_kaiser (1:5000) ,'m');
hold off
title ('Sinal de ECG filtrado');
legend ({'Sinal original','Sinal filtrado'},'location','southeast','FontSize', 14) ;
ylabel ('Amplitude ( mV )');
xlabel ('Tempo (s)');
%%
% Sinal Bartlett
figure ('Name','Sinal de ECG original e filtrado','NumberTitle','off')
;
plot ( ts (1:5000) , ecg (1:5000) ,'k');
hold on
plot ( ts (1:5000) , ecg_bartlett (1:5000) ,'m');
hold off
title ('Sinal de ECG filtrado');
legend ({'Sinal original','Sinal filtrado'},'location','southeast','FontSize', 14) ;
ylabel ('Amplitude ( mV )');
xlabel ('Tempo (s)');
%%
% Sinal Hamming
figure ('Name','Sinal de ECG original e filtrado','NumberTitle','off')

;
plot ( ts (1:5000) , ecg (1:5000) ,'k');
hold on
plot ( ts (1:5000) , ecg_hamming (1:5000) ,'m');
hold off
title ('Sinal de ECG filtrado');
legend ({'Sinal original','Sinal filtrado'},'location','southeast','FontSize', 14) ;
ylabel ('Amplitude ( mV )');
xlabel ('Tempo (s)');
%%
% Sinal Butter
figure ('Name','Sinal de ECG original e filtrado','NumberTitle','off')
;
plot ( ts (1:5000) , ecg (1:5000) ,'k');
hold on
plot ( ts (1:5000) , ecg_butter (1:5000) ,'m');
hold off
title ('Sinal de ECG filtrado');
legend ({'Sinal original','Sinal filtrado'},'location','southeast','FontSize', 14) ;
ylabel ('Amplitude ( mV )');
xlabel ('Tempo (s)');
%%
% Sinal Chebyshev I
figure ('Name','Sinal de ECG original e filtrado','NumberTitle','off')
;
plot ( ts (1:5000) , ecg (1:5000) ,'k');
hold on
plot ( ts (1:5000) , ecg_cheby1 (1:5000) ,'m');
hold off
title ('Sinal de ECG filtrado');
legend ({'Sinal original','Sinal filtrado'},'location','southeast','FontSize', 14) ;
ylabel ('Amplitude ( mV )');
xlabel ('Tempo (s)');
%%
% Sinal Chebyshev II
figure ('Name','Sinal de ECG original e filtrado','NumberTitle','off')
;
plot ( ts (1:5000) , ecg (1:5000) ,'k');
hold on
plot ( ts (1:5000) , ecg_cheby2 (1:5000) ,'m');
hold off
title ('Sinal de ECG filtrado');
legend ({'Sinal original','Sinal filtrado'},'location','southeast','FontSize', 14) ;
ylabel ('Amplitude ( mV )');
xlabel ('Tempo (s)');
%%
% Sinal Elliptico
figure ('Name','Sinal de ECG original e filtrado','NumberTitle','off')
;
plot ( ts (1:5000) , ecg (1:5000) ,'k');
hold on
plot ( ts (1:5000) , ecg_ellip (1:5000) ,'m');
hold off
title ('Sinal de ECG filtrado');
legend ({'Sinal original','Sinal filtrado'},'location','southeast','FontSize', 14) ;
ylabel ('Amplitude ( mV )');
xlabel ('Tempo (s)');
%%
% Calculo dos valores de potencia
L = length ( ecg );
P = @( x) ( norm (x) .^2) /L;
P_log = @( x) 10* log10 (x);
P_ecg = P ( ecg );
P_ecg_db = P_log ( P_ecg );
P_noise = P( noise );
P_noise_db = P_log ( P_noise );
P_equiripple = P( ecg_equiripple );
P_equiripple_db = P_log ( P_equiripple );
P_kaiser = P ( ecg_kaiser );
P_kaiser_db = P_log ( P_kaiser );
P_bartlett = P( ecg_bartlett );
P_bartlett_db = P_log ( P_bartlett );
P_hamming = P ( ecg_hamming ) ;
P_hamming_db = P_log ( P_hamming );
P_butter = P ( ecg_butter );
P_butter_db = P_log ( P_butter );
P_cheby1 = P ( ecg_cheby1 );
P_cheby1_db = P_log ( P_cheby1 );

P_cheby2 = P ( ecg_cheby2 );
P_cheby2_db = P_log ( P_cheby2 );
P_ellip = P( ecg_ellip );
P_ellip_db = P_log ( P_ellip );
%%
% Calculo dos valores de SNR
SNR = @( x ,y) x/ y;
SNR_db = @(x ,y ) x - y;
SNR_ecg = SNR ( P_ecg , P_noise ) ;
SNR_ecg_db = SNR_db ( P_ecg_db , P_noise_db ) ;
SNR_equiripple = SNR ( P_equiripple , P_noise ) ;
SNR_equiripple_db = SNR_db ( P_equiripple_db , P_noise_db );
SNR_kaiser = SNR ( P_kaiser , P_noise ) ;
SNR_kaiser_db = SNR_db ( P_kaiser_db , P_noise_db );
SNR_bartlett = SNR ( P_bartlett , P_noise );
SNR_bartlett_db = SNR_db ( P_bartlett_db , P_noise_db ) ;
SNR_hamming = SNR ( P_hamming , P_noise );
SNR_hamming_db = SNR_db ( P_hamming_db , P_noise_db );
SNR_butter = SNR ( P_butter , P_noise ) ;
SNR_butter_db = SNR_db ( P_butter_db , P_noise_db );
SNR_cheby1 = SNR ( P_cheby1 , P_noise ) ;
SNR_cheby1_db = SNR_db ( P_cheby1_db , P_noise_db );
SNR_cheby2 = SNR ( P_cheby2 , P_noise ) ;
SNR_cheby2_db = SNR_db ( P_cheby2_db , P_noise_db );
SNR_ellip = SNR ( P_ellip , P_noise );
SNR_ellip_db = SNR_db ( P_ellip_db , P_noise_db );
%%
% Calculo dos valores de tensao pico a pico
vpp = @( x ) max ( x) - min ( x);
vpp_ecg = vpp ( ecg );
vpp_equiripple = vpp ( ecg_equiripple );

vpp_kaiser = vpp ( ecg_kaiser );
vpp_bartlett = vpp ( ecg_bartlett );
vpp_hamming = vpp ( ecg_hamming );
vpp_butter = vpp ( ecg_butter );
vpp_cheby1 = vpp ( ecg_cheby1 );
vpp_cheby2 = vpp ( ecg_cheby2 );
vpp_ellip = vpp ( ecg_ellip ) ;

%%
% Salvando variaveis de resultados
%savefile_snr = strcat ('SNR_', name ,'. mat');
%save ( savefile_snr ,'SNR *');
%savefile_vpp = strcat ('Vpp_', name ,'. mat');
%save ( savefile_vpp ,'vpp *');