%% Bartlett

%win_baseline_bartlett = bartlett (N +1) ;
wvtool(win_baseline_bartlett)
%b_baseline_bartlett = fir1 (N , fc_baseline/(Fs/2) ,'high',win_baseline_bartlett , flag ) ;
fvtool(b_baseline_bartlett,1,'Fs', Fs)
axis([0 50 -inf inf])


%b_60hz_bartlett = fir1 (N , [ fc1_60hz fc2_60hz]/(Fs/2) ,'stop', win_60hz_bartlett,lag) ;
fvtool(b_60hz_bartlett,1,'Fs', Fs)

%% Hamming

%win_baseline_hamming = hamming(N +1) ;
wvtool(win_baseline_hamming);

%b_baseline_hamming = fir1 (N , fc_baseline/(Fs/2) ,'high',win_baseline_hamming, flag );
fvtool(b_baseline_hamming,1,'Fs', Fs)
axis([0 50 -inf inf])
%b_60hz_hamming = fir1 (N , [ fc1_60hz fc2_60hz ]/( Fs /2) ,'stop',win_60hz_hamming , flag );
fvtool(b_60hz_hamming,1,'Fs', Fs)

%% Kaiser

%win_baseline_kaiser = kaiser (N +1, beta ) ;
wvtool(win_baseline_kaiser);

%b_baseline_kaiser = fir1 (N , fc_baseline /( Fs /2) ,'high',win_baseline_kaiser , flag );
fvtool(b_baseline_kaiser,1,'Fs', Fs)
axis([0 50 -inf inf])

%b_60hz_kaiser = fir1 (N , [ fc1_60hz fc2_60hz ]/( Fs /2) ,'stop',win_60hz_kaiser , flag );
fvtool(b_60hz_kaiser,1,'Fs', Fs)


%% Equiripple
%b_baseline_equiripple = firpm (N , [0 fstop_baseline fpass_baseline Fs/2]/( Fs /2) , [0 0 1 1] , [ Wstop_baseline Wpass_baseline ], { dens }) ;
fvtool(b_baseline_equiripple,1,'Fs', Fs)
axis([0 50 -inf inf])


%b_60hz_equiripple = firpm (N , [0 fpass1_60hz fstop1_60hz fstop2_60hz fpass2_60hz Fs /2]/( Fs /2) , [1 1 0 0 1 1] , [ Wpass1_60hz Wstop_60hz Wpass2_60hz ] , { dens }) ;
fvtool(b_60hz_equiripple,1,'Fs', Fs)