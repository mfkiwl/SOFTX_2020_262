function [sim_pulse_2,y_tx_matched,t_sim_pulse_2]=generate_sim_pulse (params,F1,F2)

f_s_ori=1.5*1e6;

D_1=nanmax(F1.DecimationFactor,1);
D_2=nanmax(F2.DecimationFactor,1);
filt_1=(F1.Coefficients(1:2:end)+1j*F1.Coefficients(2:2:end));
filt_2=(F2.Coefficients(1:2:end)+1j*F2.Coefficients(2:2:end));

f_s_sig=(1/(params.SampleInterval(1)));
FreqStart=(params.FrequencyStart(1));
FreqEnd=(params.FrequencyEnd(1));

pulse_length=(params.PulseLength(1));
pulse_slope=(params.Slope(1));

t_sim_pulse=linspace(0,pulse_length,(pulse_length*f_s_ori))';

np=length(t_sim_pulse);


nwtx=2*floor(pulse_slope*np);
wtxtmp  = hann(nwtx);
%wtxtmp = triang(nwtx);
nwtxh   = ceil(nwtx/2);
env_pulse = [wtxtmp(1:nwtxh); ones(np-nwtx,1); wtxtmp(nwtxh+1:end)];

% k_sweep=(FreqEnd-FreqStart)/t_sim_pulse(end);
% phi_sweep=2*pi*(FreqStart*t_sim_pulse+k_sweep/2*t_sim_pulse.^2);
% sim_pulse_2=env_pulse.*((exp(1i*phi_sweep)));

f_sweep=chirp(t_sim_pulse,FreqStart,t_sim_pulse(end),FreqEnd);
sim_pulse=env_pulse.*f_sweep;


%Filter simulated pulse to create match filter%


f_s_dec(1)=f_s_ori/D_1;
f_s_dec(2)=f_s_dec(1)/D_2;
d_fact=f_s_dec(2)/f_s_sig;

%     t_filt_1=1/f_s_ori*(0:(length(filt_1)-1))';
%     t_filt_2=1/f_s_dec(1)*(0:(length(filt_2)-1))';

sim_pulse_1=conv(sim_pulse/nanmax(abs(sim_pulse)),filt_1,'same');
sim_pulse_1=downsample(sim_pulse_1,D_1);


sim_pulse_2=conv(sim_pulse_1/nanmax(abs(sim_pulse_1)),filt_2,'same');
sim_pulse_2=downsample(sim_pulse_2,D_2);

sim_pulse_2=sim_pulse_2/nanmax(sim_pulse_2);

y_tx_matched=conj(flipud(sim_pulse_2));

%
t_sim_pulse_1=downsample(t_sim_pulse,D_1);
t_sim_pulse_2=downsample(t_sim_pulse_1,D_2);


% figure();
% subplot(3,1,1)
% plot(t_sim_pulse*1e3,real(sim_pulse)/nanmax(real(sim_pulse)),'b');
% grid on;
% subplot(3,1,2)
% plot(t_sim_pulse_1*1e3,real(sim_pulse_1)/nanmax(real(sim_pulse_1)),'k');
% grid on;
% subplot(3,1,3)
% plot(t_sim_pulse_2*1e3,real(sim_pulse_2)/nanmax(real(sim_pulse_2)),'r');
% grid on;
% xlabel('Time(ms)');


d_fact=round(d_fact);

t_sim_pulse_2=t_sim_pulse_2(1:d_fact:end);
sim_pulse_2=sim_pulse_2(1:d_fact:end);
y_tx_matched=y_tx_matched(1:d_fact:end);




