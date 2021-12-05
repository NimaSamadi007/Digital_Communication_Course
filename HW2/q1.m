clc
clear
close

% constants:
M_BIT = 3;
NUM_SYMBOL = 20;

% generates NUM_SYMBOLs of binary digits 
% enter M to make sure the length of symbols are
% a multiple of M (zero is concatenated)
symbols = SymbolGenerator(NUM_SYMBOL, M_BIT);
[gray_symbols, dict] = Bin2Gray(symbols, M_BIT);
gray_symbols
dec_symbols = Gray2Dec(gray_symbols, M_BIT)

function bin_symbols = SymbolGenerator(num, M)
% generates random binary symbols. Number of
% symbols is determined by 'num'
    bin_symbols = randi([0, 1], 1, num);
    if rem(num, 3)
        bin_symbols = [bin_symbols, zeros(1, M - rem(num, 3))];
    end
end

function [gray_symbols, dict] = Bin2Gray(bin_symbols, M)
% converts M binary digits to one gray symbol    
    gray_symbols = zeros(1, length(bin_symbols));
    dict = GrayDictGenerator(M);
    for i=1:M:length(bin_symbols)
        bin_symbol = bin_symbols(i:i+M-1);
        index = bi2de(bin_symbol, 'left-msb');
        gray_symbols(i:i+M-1) = dict(index+1, M+1:end);
    end
end

function dict = GrayDictGenerator(M)
% generates gray dict for converting binary to gray
    dict = zeros(2 ^ M, 2 * M);
    bin_repr = de2bi(0 : 2^M-1, M, 'left-msb');
    dict(:, 1:M) = bin_repr;
    
    % MSBs are same for binary and gray code
    dict(:, M+1) = dict(:, 1);
    for i=1:M-1
        dict(:, M+i+1) = double( xor(dict(:, i), dict(:, i+1)) );
    end
end

function dec_symbols = Gray2Dec(gray_symbols, M)
% converts gray symbols to decimal representation
    dec_symbols = zeros(1, length(gray_symbols) / M);
    for i=1:M:length(gray_symbols)
        dec_symbols((i-1) / M + 1) = bi2de(gray_symbols(i:i+M-1), 'left-msb');
    end
end