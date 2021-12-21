function BER = BER_MPSK_97102011(M, N, EbN0_dB)
%BER_MPSK_97102011 calculates BER for M-PSK modulation
    % Constants:
    EB_N0_w = 10 ^ (EbN0_dB / 10);
    N0_w = (1 / (log2(M) * EB_N0_w));

    bin_t_symbols = SymbolGenerator(N, log2(M));
    [gray_t_symbols, dict] = Bin2Gray(bin_t_symbols, log2(M));
    dec_t_symbols = Gray2Dec(gray_t_symbols, log2(M));
    transmitted_signal = ConstellationMapper(dec_t_symbols, M);
    % add white noise to transmitted signal
    noisy_signal = Channel(transmitted_signal, N0_w / 2);
    % demodulation and converting to binary
    dec_r_symbols = Demodulator(noisy_signal, M);
    bin_r_symbols = Dec2BinConv(dec_r_symbols, log2(M), dict(:, end));

    BER = BERCal(bin_t_symbols, bin_r_symbols);
end

function bin_symbols = SymbolGenerator(num, M)
% generates random binary symbols. Number of
% symbols is determined by 'num'
    rng(1);
    bin_symbols = randi([0, 1], 1, num);
    if rem(num, M)
        bin_symbols = [bin_symbols, zeros(1, M - rem(num, M))];
    end
end

function [gray_symbols, dict] = Bin2Gray(bin_symbols, M)
% converts M binary digits to one gray symbol    
    gray_symbols = zeros(1, length(bin_symbols));
    dict = GrayDictGenerator(M);
    for i=1:M:length(bin_symbols)
        bin_symbol = bin_symbols(i:i+M-1);
        index = bi2de(bin_symbol, 'left-msb');
        gray_symbols(i:i+M-1) = dict(index+1, M+1:end-1);
    end
end

function dict = GrayDictGenerator(M)
% generates gray dict for converting binary to gray
% first col: gray decimal repr
% next M col: binary repr
% last M col: gray repr
    dict = zeros(2 ^ M, 2 * M + 1);
    bin_repr = de2bi(0 : 2^M-1, M, 'left-msb');
    dict(:, 1:M) = bin_repr;
    
    % MSBs are same for binary and gray code
    dict(:, M+1) = dict(:, 1);
    % construct gray codes
    for i=1:M-1
        dict(:, M+i+1) = double( xor(dict(:, i), dict(:, i+1)) );
    end
    dict(:, end) = bi2de(dict(:, M+1:2*M), 'left-msb');
end

function dec_symbols = Gray2Dec(gray_symbols, M)
% converts gray symbols to decimal representation
    dec_symbols = zeros(1, length(gray_symbols) / M);
    for i=1:M:length(gray_symbols)
        dec_symbols((i-1) / M + 1) = bi2de(gray_symbols(i:i+M-1), 'left-msb');
    end
end

function t_sig = ConstellationMapper(symbols, M)
% mappes symbols to corresponding inphase and quadrature components
% t_sig: (inphase, quadrature)
    num_symbols = length(symbols);
    t_sig = zeros(num_symbols, 2);
    % mapping each symbol
    for i=1:num_symbols
        % m_i = [0, M-1]
        %m_i = find(gray_symb_dict == symbols(i)) - 1;
        t_sig(i, :) = [cos(2*pi*symbols(i) / M), sin(2*pi*symbols(i) / M)];
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
    detected_symbols = zeros(1, size(n_sig, 1));
    basis_vec = [cos(2*pi*m/M)', sin(2*pi*m/M)'];
    for i=1:size(n_sig, 1)
        distance_vec = ((basis_vec(:, 1) - n_sig(i, 1)).^2 + ...
                       (basis_vec(:, 2) - n_sig(i, 2)).^2).^(0.5);
        [~, min_index] = min(distance_vec);
        detected_symbols(i) = min_index - 1;
    end
end

function bin_symbols = Dec2BinConv(dec_symbols, M, gray_symbols)
% converts decimal symbols to flattened binary symbols
    bin_symbols = zeros(1, M * length(dec_symbols));
    for i=1:length(dec_symbols)
        m_dec = find(gray_symbols == dec_symbols(i));
        bin_symbols((i-1)*M+1:i*M) = de2bi(m_dec - 1, M, 'left-msb');
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
