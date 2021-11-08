function dist = CalDist(in_text, len, symbol_length)
    dist = zeros(1, len);
    offset = 10 ^ (symbol_length-1) - 1;
    for i = 1:length(in_text)
        symbol = in_text(i);
        dist(symbol - offset) = dist(symbol - offset) + 1;
    end
    dist = dist ./ length(in_text);
end