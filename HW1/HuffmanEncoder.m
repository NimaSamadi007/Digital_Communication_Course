function coded_text = HuffmanEncoder(text, symbols, dict)
%HUFFMANENCODER encodes text using dict - dict must be cell(n, 2) There are n symbols
    len = length(text);
    coded_text = strings(1, len);
    for i=1:len
        symbol = text(i);
        coded_text(i) = dict{symbols == symbol, 2};
    end
end
