clear
close
clc

% symbols and their distribution

symbols = 10:42;
dist = [9.1, 4.4, 0.7, 4.9, 0.2, 1, 0.4, 0.8, 1.2, 6.4, 0.2, ...
        7.5, 2.2, 0.1, 3.1, 2.7, 0.6, 0.2, 0.6, 0.1, 1.2, 0.2, ...
        1.4, 1.1, 2.9, 1.2, 2.5, 5.9, 6.4, 6, 6.2, 8.1, 10.5] ./ 100;

TEXT_LEN = 2000;
text = GenRandomText(TEXT_LEN, symbols, dist);
my_dict = MyHuffman(symbols, dist);
matlab_dict = huffmandict(symbols, dist);

huffman_coded = HuffmanEncoder(text, symbols, my_dict);
matlab_huffman = huffmanenco(text, matlab_dict);

text = char(strjoin(string(text),''));
[lempel_coded, lempel_dict] = MyLempelZiv(text, 2);


%%%%%%%%%%%%%%%%%%%%% compression rate %%%%%%%%%%%%%%%%%%%%%%%%
disp("Matlab Huffman coding compresion")
disp((TEXT_LEN * 6) / length(matlab_huffman));
disp("Avg lenght: " + string(length(matlab_huffman)));
disp("My Huffman coding compresion")
huffman_coded_length = length(char(strjoin(huffman_coded, '')));
disp((TEXT_LEN * 6) / huffman_coded_length);
disp("Avg lenght: " + string(huffman_coded_length));
disp("Lempel-Ziv coding compresion rate")
lempel_coded_length = length(char(strjoin(string(lempel_coded), '')));
disp((TEXT_LEN * 6) / (lempel_coded_length + TEXT_LEN));
disp("Avg lenght: " + string(lempel_coded_length));

%%%%%%%%%%%%%%%%%%%%% dict length %%%%%%%%%%%%%%%%%%%%%%%%%%%%
huffman_dict_len = 0;
lempel_dict_len = 0;

%for i=1:size(my_dict, 1)
    
%end


function random_text = GenRandomText(len, symbols, dist)
%GENRANDOMTEXT generated a random text with length of len from symbols
    random_text = zeros(1, len);
    cdf_dist = cumsum(dist);
    uni_dist = rand(1, len);
    for i=1:len
        indices = find( (cdf_dist - uni_dist(i)) >= 0);
        random_text(i) = symbols(indices(1));
    end
end


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

    
    
    
    
    
    
    
    
    
    
    
    

    
    