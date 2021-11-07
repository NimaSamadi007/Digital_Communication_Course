function avg_len = CalAvgLength(dist, dict)
%CALAVGDICTLENGTH calculates average dictionary length
%   dict: must be "n * 2 cell"
%   dist: symbol distribution
%   avg_len: average length with respect to huffman dict
    avg_len = 0;
    dict_len = length(dict);
    for i=1:dict_len
        avg_len = avg_len + length(dict{i, 2}) * dist(i);
    end
end