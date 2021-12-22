function SER_val = SER_2_PAM_coherent_97102011(N, EbN0_dB)
%SER_2_PAM_COHERENT_97102011 2-PAM coherent modulation
    M = 2;
    K = log2(M);
    
    % noise power
    EB_N0_w = 10 ^ (EbN0_dB / 10);  
    N0_w = (1 / (2 * K * EB_N0_w));
    
    symbs = SymbolGenerator(N, K);
    dec_symbs = Bin2Dec(symbs, K);
    mod_signal = dec_symbs;
    recieved_signal = Channel(mod_signal, N0_w);
    detected_signal = Demodulator(recieved_signal, M);
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

function n_sig = Channel(t_sig, N0)
% simulates AWGN channel - N0 is in Watt
% the noise of PAM channel is one dimmenstional
    N0_db = 10 * log10(N0);
    noise = wgn(1, length(t_sig), N0_db);
    n_sig = t_sig + noise;
end

function detected_symbols = Demodulator(n_sig, M)
% demodulator in reciever and extracting symbols
    % constellation points used to recover symbols
    const_points = 0:M-1;
    detected_symbols = zeros(1, length(n_sig));
    for i=1:length(n_sig)
        distance_vec = (const_points - n_sig(i)) .^ 2;
        [~, min_index] = min(distance_vec);
        detected_symbols(i) = min_index-1;
    end
end

function ser = CalSER(t_symbs, r_symbs)
% calculates symbol error rate 
% t_signal: transmitted signal
% r_signal: recieved signal
    error = length(find(t_symbs ~= r_symbs));
    ser = error / (length(t_symbs));
end

