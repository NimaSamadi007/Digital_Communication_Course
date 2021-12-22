function SER_val = SER_MFSK_coherent_97102011(M, N, EbN0_dB)
%SER_2_FSK_COHERENT_97102011 2-FSK coherent modulation
    % noise power
    K = log2(M);
    
    EB_N0_w = 10 ^ (EbN0_dB / 10);  
    N0_w = (1 / (K * EB_N0_w));    
       
    symbs = SymbolGenerator(N, K);
    dec_symbs = Bin2Dec(symbs, K);
    mod_signal = ConstellationMapper(dec_symbs, M);
    recieved_signal = Channel(mod_signal, N0_w);
    detected_signal = Demodulator(recieved_signal);
    SER_val = CalSER(dec_symbs, detected_signal);

end

function bin_symbols = SymbolGenerator(num, K)
% generates random binary symbols. Number of
% symbols is determined by 'num' - each symbol
% uses K bit to be represented
    bin_symbols = randi([0, 1], 1, num);
    if rem(num, K)
        bin_symbols = [bin_symbols, zeros(1, K - rem(num, K))];
    end
end

function dec_symbols = Bin2Dec(bin_symbols, K)
% converts binary symbols to decimal which
% each symbol is K bits
    dec_symbols = zeros(1, length(bin_symbols) / K);
    for i=1:K:length(bin_symbols)
        dec_symbols((i-1)/K + 1) = bi2de(bin_symbols(i:i+K-1), 'left-msb');
    end
end

function mod_signal = ConstellationMapper(dec_symbols, M)
% mappes decimal symbols to FSK signals and returns
% modulated signal
% for symbol i => returns A such in i'th place there is one
% which i = [0, M-1]
    mod_signal = zeros(length(dec_symbols), M);
    for i=1:length(dec_symbols)
        mod_signal(i, dec_symbols(i)+1) = 1;
    end
end

function n_sig = Channel(t_sig, N0)
% simulates AWGN channel - N0 is in Watt
% the noise of PAM channel is one dimmenstional
    N0_db = 10 * log10(N0);
    noise = wgn(size(t_sig, 1), size(t_sig, 2), N0_db);
    n_sig = t_sig + noise;
end

function detected_symbols = Demodulator(n_sig)
% demodulator in reciever and extracting symbols
    [~, max_index] = max(n_sig, [], 2);
    detected_symbols = max_index'-1;
end

function ser = CalSER(t_symbs, r_symbs)
% calculates symbol error rate 
% t_signal: transmitted signal
% r_signal: recieved signal
    error = length(find(t_symbs ~= r_symbs));
    ser = error / (length(t_symbs));
end

