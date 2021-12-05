function BER = BER_MPSK_97102011(M,N, EbN0_dB)
%BER_MPSK_97102011 calculates BER for M-PSK modulation
    % Constants:
    SYMBOL_NUM = 100000;

    bin_symbols = SymbolGenerator(SYMBOL_NUM);

end

function bin_symbols = SymbolGenerator(num)
% generates random binary symbols. Number of
% symbols is determined by 'num'
    bin_symbols = randi([0, 1], 1, num);
end

function gray_symbols = Bin2Gray(bin_symbols, M)
% converts M binary digits to one gray symbol

end