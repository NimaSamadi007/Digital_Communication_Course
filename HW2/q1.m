clc
%clear
close

% constants:
M_BITs = [2, 4, 8, 16];
N = 100000;
% in dBW - assume symbols energy equals 1 watt
EbN0_dB = -6:2:12;

ber_vals = zeros(length(M_BITs), length(EbN0_dB));
%%%%%%%%%%%%%% Part A: %%%%%%%%%%%%%%%%%%%%%
for j=1:length(M_BITs)
    fprintf("Calculating BER for %d-PSK \n", M_BITs(j))
    for i=1:length(EbN0_dB)
        ber_vals(j, i) = BER_MPSK_97102011(M_BITs(j), N, EbN0_dB(i));
    end
end

fprintf("Plotting ... \n");
% Plot BER vs SNR for each M
figure;
for j=1:length(M_BITs)
    semilogy(EbN0_dB, ber_vals(j, :), '-*')
    hold on
end
grid on
title('BER vs Eb/N0')
xlabel('\epsilon_b/N_0 (dB)')
ylabel('Bit Error Rate')
legend('b-psk', '4-psk', '8-psk', '16-psk');

%%%%%%%%%%%%%%%% Part B: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

theo_ber_vals = zeros(length(M_BITs), length(EbN0_dB));
for i=1:length(M_BITs)
    for j = 1:length(EbN0_dB)
        theo_ber_vals(i, j) = CalTheoreticalBER(M_BITs(i), EbN0_dB(j));
    end
end

figure;
for i=1:4
    subplot(2, 2, i);
    semilogy(EbN0_dB, theo_ber_vals(i, :), '-o')
    hold on
    semilogy(EbN0_dB, ber_vals(i, :), '-*')
    grid on
    title("BER for " + string(M_BITs(i)) + "-PSK")
    legend('Theoretical BER', 'estimated BER')
end

%%%%%%%%%%%%%%%% Part C: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% constellation plotting - not included in final code - just for reporting
%{
ber = BER_MPSK_97102011(8, N, -6);
ber = BER_MPSK_97102011(8, N, 0);
ber = BER_MPSK_97102011(8, N, 4);
ber = BER_MPSK_97102011(8, N, 8);
ber = BER_MPSK_97102011(8, N, 10);
ber = BER_MPSK_97102011(8, N, 12);
%}
%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%
function ber = CalTheoreticalBER(M, eb_n0_db)
    eb_n0_w = 10 ^ (eb_n0_db / 10);
    tmp = qfunc(sqrt(2*eb_n0_w*log2(M)) * sin(pi/M));
    ber = tmp * 2 / (log2(M));
end


