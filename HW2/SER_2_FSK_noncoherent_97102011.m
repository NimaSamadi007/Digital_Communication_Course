function SER_val = SER_2_FSK_noncoherent_97102011(N, EbN0_dB)
%SER_2_NONFSK_COHERENT_97102011 2-FSK non-coherent modulation
    M = 2;
    K = log2(M);
    
    % noise power
    EB_N0_w = 10 ^ (EbN0_dB / 10);  
    N0_w = (1 / (K * EB_N0_w));    
       
    symbs = SymbolGenerator(N, K);
    dec_symbs = Bin2Dec(symbs, K);
    [inphase_comp, quadrature_comp] = ConstellationMapper(dec_symbs, M);
    [inphase_recieved, quadrature_recieved] = Channel(inphase_comp, quadrature_comp, N0_w);
    detected_signal = Demodulator(inphase_recieved, quadrature_recieved);
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

function [in_comp, qu_comp] = ConstellationMapper(dec_symbols, M)
% mappes decimal symbols to FSK signals and returns
% modulated signal which consists of inphase and quadrature components
% for symbol i => returns A such in i'th place there is one
% which i = [0, M-1]
    in_comp = zeros(length(dec_symbols), M);
    qu_comp = zeros(length(dec_symbols), M);
    for i=1:length(dec_symbols)
        in_comp(i, dec_symbols(i)+1) = 1;
    end
    % All quadrature components are zeros
end

function [n_inphase, n_quadrature] = Channel(in_sig, qu_sig, N0)
% simulates AWGN channel - N0 is in Watt
% the noise of PAM channel is one dimmenstional
    N0_db = 10 * log10(N0);
    noise_inphase = wgn(size(in_sig, 1), size(in_sig, 2), N0_db);
    noise_quadrature = wgn(size(qu_sig, 1), size(qu_sig, 2), N0_db);
    n_inphase = in_sig + noise_inphase;
    n_quadrature = qu_sig + noise_quadrature;
end

function detected_symbols = Demodulator(in_sig, qu_sig)
% demodulator in reciever and extracting symbols
    envelope_sig = in_sig.^2 + qu_sig.^2;
    [~, max_index] = max(envelope_sig, [], 2);
    detected_symbols = max_index' - 1;
end

function ser = CalSER(t_symbs, r_symbs)
% calculates symbol error rate 
% t_signal: transmitted signal
% r_signal: recieved signal
    error = length(find(t_symbs ~= r_symbs));
    ser = error / (length(t_symbs));
end
