%% Q1 - 1), 2) and 3)
clear
close
clc

% symbols and their distribution

symbols = 10:42;

% Symbols distribution
%dist = [9.1, 4.4, 0.7, 4.9, 0.2, 1, 0.4, 0.8, 1.2, 6.4, 0.2, ...
%        7.5, 2.2, 0.1, 3.1, 2.7, 0.6, 0.2, 0.6, 0.1, 1.2, 0.2, ...
%        1.4, 1.1, 2.9, 1.2, 2.5, 5.9, 6.4, 6, 6.2, 8.1, 10.5] ./ 100;

% Optimal distribution for maximum compressing ration
dist = (1/2) .^ ([1:32, 32]);
TEXT_LEN = 2000;
text = GenRandomText(TEXT_LEN, symbols, dist);
my_dict = MyHuffman(symbols, dist);
matlab_dict = huffmandict(symbols, dist);

huffman_coded = HuffmanEncoder(text, symbols, my_dict);
matlab_huffman = huffmanenco(text, matlab_dict);

text = char(strjoin(string(text),''));
[lempel_coded, max_bits] = MyLempelZiv(text, 2);


%%%%%%%%%%%%%%%%%%%%% 1) compression rate %%%%%%%%%%%%%%%%%%%%%%%%
disp("Matlab Huffman coding compresion")
disp((TEXT_LEN * 6) / length(matlab_huffman));
disp("Avg lenght: " + string(length(matlab_huffman)));
disp("My Huffman coding compresion")
huffman_coded_length = length(char(strjoin(huffman_coded, '')));
disp((TEXT_LEN * 6) / huffman_coded_length);
disp("Avg lenght: " + string(huffman_coded_length));
disp("Lempel-Ziv coding compresion rate")
lempel_coded_length = length(lempel_coded);
disp((TEXT_LEN * 6) / (lempel_coded_length * (max_bits + 6) ));
disp("Avg lenght: " + string(lempel_coded_length * (max_bits + 6)));

%%%%%%%%%%%%%%%%%%%%% 1) dict length %%%%%%%%%%%%%%%%%%%%%%%%%%%%
huffman_dict_len = 0;

for i=1:length(my_dict)
   huffman_dict_len = huffman_dict_len + length(my_dict{i, 2}); 
end

disp("Huffman dictionary required bits: " + string(huffman_dict_len))


%% Q1 - 4)

clear
close
clc

fid = fopen('./Files/Text/file2.txt');
dataInDecimal = fread(fid);


TEXT_LEN = length(dataInDecimal);
% symbols are between 32 to 121 which are 90. So I map [32, 121] to
% [100, 189] interval and each symbol have a offset of +68

symbols = 100:(100 + max(dataInDecimal) - min(dataInDecimal));
symbol_length = 3;
offset = (100 - min(dataInDecimal));

dataInDecimal = dataInDecimal + offset;
dist = CalDist(dataInDecimal, length(symbols), symbol_length);

my_dict = MyHuffman(symbols, dist);
matlab_dict = huffmandict(symbols, dist);

huffman_coded = HuffmanEncoder(dataInDecimal, symbols, my_dict);
matlab_huffman = huffmanenco(dataInDecimal, matlab_dict);

text = char(strjoin(string(dataInDecimal),''));
[lempel_coded, max_bits] = MyLempelZiv(text, 3);


disp("Matlab Huffman coding compresion")
disp((TEXT_LEN * 6) / length(matlab_huffman));
disp("Avg lenght: " + string(length(matlab_huffman)));
disp("My Huffman coding compresion")
huffman_coded_length = length(char(strjoin(huffman_coded, '')));
disp((TEXT_LEN * 6) / huffman_coded_length);
disp("Avg lenght: " + string(huffman_coded_length));
disp("Lempel-Ziv coding compresion rate")
lempel_coded_length = length(lempel_coded);
disp((TEXT_LEN * 6) / (lempel_coded_length * (max_bits + 6) ));
disp("Avg lenght: " + string(lempel_coded_length * (max_bits + 6)));


%{
function Mismatch(symbols, dist, dict1, dict2)
%MISMATCH prints mismatches:
    len = length(symbols);
    for i=1:len
        if length(dict1{i, 2}) ~= length(dict2{i, 2})
            disp("Length Mismatch in i = " + string(i))
            disp("My dict length: " + string(length(dict1{i, 2})) + ...
                 " Matlab dict length: " + string(length(dict2{i, 2})));
            disp("Symbol: " + string(symbols(i)) ...
                 + " With prob: " + string(dist(i)));
        end
    end
end

function chr = ConvertArrToChar(arr)
%CONVERTARRTOCHAR converts binary array to coressponded char
    chr = ' ';
    string_arr = string(arr);
    for i=1:length(string_arr)
        chr = char(strcat(chr, string_arr(i)));
    end
end
%}
    
    
    
    
    
    
    
    
    
    
    
    

    
    