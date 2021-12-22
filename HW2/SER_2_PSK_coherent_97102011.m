function SER_val = SER_2_PSK_coherent_97102011(N, EbN0_dB)
%SER_2_PSK_COHERENT_97102011 2-PSK coherent modulation
    M = 2;
    K = log2(M);
    
    % noise power
    EB_N0_w = 10 ^ (EbN0_dB / 10);  
    N0_w = (1 / (K * EB_N0_w));

    symbs = SymbolGenerator(N, K);
    dec_symbs = Bin2Dec(symbs, K);
    mod_signal = ConstellationMapper(dec_symbs, M);
    recieved_signal = Channel(mod_signal, N0_w);
    detected_signal = Demodulator(recieved_signal, M);
    SER_val = CalSER(dec_symbs, detected_signal);

end

function bin_symbols = SymbolGenerator(num, K)
% generates random binary symbols. Number of
% symbols is determined by 'num'
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

function mod_signal = ConstellationMapper(symbols, M)
% mappes symbols to corresponding inphase and quadrature components
% t_sig: (inphase, quadrature)
    mod_signal = zeros(2, length(symbols));
    % mapping each symbol
    for i=1:length(symbols)
        mod_signal(:, i) = [cos(2*pi*symbols(i) / M); sin(2*pi*symbols(i) / M)];
    end
end

function n_sig = Channel(t_sig, N0)
% simulates AWGN channel
    N0_db = 10 * log10(N0);
    noise = wgn(size(t_sig, 1), size(t_sig, 2), N0_db);
    n_sig = t_sig + noise;
end

function detected_symbols = Demodulator(n_sig, M)
% demodulator in reciever and converting gray to decimal
    m = 0:M-1;
    detected_symbols = zeros(1, size(n_sig, 2));
    basis_vec = [cos(2*pi*m/M)', sin(2*pi*m/M)']';
    for i=1:size(n_sig, 2)
        distance_vec = ((basis_vec(1, :) - n_sig(1, i)).^2 + ...
                       (basis_vec(2, :) - n_sig(2, i)).^2).^(0.5);
        [~, min_index] = min(distance_vec);
        detected_symbols(i) = min_index - 1;
    end
end

function ber = BERCal(bin_t, bin_r)
% calculated BER
% bin_t : binary transmitted signals
% bin_r: binary received signals
    bin_r_flattened = bin_r';
    bin_r_flattened = bin_r_flattened(:)';
    error = length(find(bin_r_flattened ~= bin_t));
    ber = error / (length(bin_t));
end

function ser = CalSER(t_symbs, r_symbs)
% calculates symbol error rate 
% t_signal: transmitted signal
% r_signal: recieved signal
    error = length(find(t_symbs ~= r_symbs));
    ser = error / (length(t_symbs));
end
