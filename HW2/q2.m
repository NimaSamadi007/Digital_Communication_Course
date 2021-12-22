clc
clear
close

N = 100000;
EbN0_dB = -4:2:14;
M_BITs = [2, 4, 8, 16, 32];

    
ser_vals = zeros(4, length(EbN0_dB));

for i=1:length(EbN0_dB)
    fprintf("Computing SER for SNR=%d dB ... \n", EbN0_dB(i)); 
    ser_vals(1, i) = SER_2_PAM_coherent_97102011(N, EbN0_dB(i));
    ser_vals(2, i) = SER_2_PSK_coherent_97102011(N, EbN0_dB(i));
    ser_vals(3, i) = SER_2_FSK_coherent_97102011(N, EbN0_dB(i));
    ser_vals(4, i) = SER_2_FSK_noncoherent_97102011(N, EbN0_dB(i));
end

figure;
for j=1:4
    semilogy(EbN0_dB, ser_vals(j, :), '-*')
    hold on
end
grid on
title('SER vs Eb/N0')
xlabel('\epsilon_b/N_0 (dB)')
ylabel('Symbol Error Rate')
legend('bPAM', 'bPSK', 'bFSK Coherent', 'bFSK Non-coherent');

%{
ser_vals = zeros(length(M_BITs), length(EbN0_dB));

for j=1:length(M_BITs)
    fprintf("Calculating BER for %d-FSK Coherent \n", M_BITs(j))
    for i=1:length(EbN0_dB)
        ser_vals(j, i) = SER_MFSK_coherent_97102011(M_BITs(j), N, EbN0_dB(i));
    end
end

fprintf("Plotting ... \n");
% Plot BER vs SNR for each M
figure;
for j=1:length(M_BITs)
    semilogy(EbN0_dB, ser_vals(j, :), '-*')
    hold on
end
grid on
title('SER vs Eb/N0')
xlabel('\epsilon_b/N_0 (dB)')
ylabel('Bit Error Rate')
legend('2-FSK', '4-FSK', '8-FSK', '16-FSK', '32-FSK');
%}