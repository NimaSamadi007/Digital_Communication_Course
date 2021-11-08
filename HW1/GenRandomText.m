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