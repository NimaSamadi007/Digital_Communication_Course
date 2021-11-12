%% Text file coding
clear
close
clc

files = ["file1", "file2", "file3"];
for file=files
    disp("Text " + file + " coding")
    fid = fopen("./Files/Text/"+file+".txt");
    dataInDecimal = fread(fid);

    TEXT_LEN = length(dataInDecimal);
    BIT_NUM = ceil(log2(length(unique(dataInDecimal))));

    fprintf("Required bits for each symbol: %d \n", BIT_NUM)
    fprintf("Original Number of bits: %d \n", TEXT_LEN * BIT_NUM);
    
    uniq_symbols = unique(dataInDecimal);
    
    symbols = 100:(100 + max(dataInDecimal) - min(dataInDecimal));
    symbol_length = 3;
    offset = (100 - min(dataInDecimal));

    dataInDecimal = dataInDecimal + offset;
    tic
    dist = CalDist(dataInDecimal, length(symbols), symbol_length);
    my_dict = MyHuffman(symbols, dist);
    huffman_coded = HuffmanEncoder(dataInDecimal, symbols, my_dict);
    huffman_coded_length = length(char(strjoin(huffman_coded, '')));
    toc
    fprintf("Number symbols in Huffman: %d \n", length(uniq_symbols));
    fprintf("Compressed Number of bits: %d \n", huffman_coded_length);
    fprintf("My Huffman coding compresion: %f \n", ...
            (TEXT_LEN * BIT_NUM) / huffman_coded_length);
    tic
    text = char(strjoin(string(dataInDecimal),''));
    [lempel_coded, max_bits] = MyLempelZiv(text, 3);
    toc
    lempel_coded_length = length(lempel_coded);
    fprintf("Compressed Number of bits: %d \n", lempel_coded_length * (max_bits + BIT_NUM));
    fprintf("Lempel-Ziv coding compresion rate: %f \n", ...
            (TEXT_LEN * BIT_NUM) / (lempel_coded_length * (max_bits + BIT_NUM)));
    disp("--------------------------------------");
end


%% Image file coding:
clear
close
clc


images = ["image1.tif", "image2.png", "image3.jpg", "image4.jpg", "image5.jpg"];
%images = ["image3.jpg"];
for img_file=images
    disp(img_file + " coding")
    img = imread("./Files/Image/"+img_file);
    img_vec = cast(img(:), 'int32');

    IMG_LEN = length(img_vec);
    BIT_NUM = ceil(log2(length(unique(img_vec))));

    fprintf("Required bits for each symbol: %d \n", BIT_NUM)
    fprintf("Original Number of bits: %d \n", IMG_LEN * BIT_NUM);
    
    uniq_symbols = unique(img_vec);
    
    symbols = 100:(100 + max(img_vec) - min(img_vec));
    symbol_length = 3;
    offset = (100 - min(img_vec));

    img_vec = img_vec + offset;
    tic
    dist = CalDist(img_vec, length(symbols), symbol_length);
    my_dict = MyHuffman(symbols, dist);
    huffman_coded = HuffmanEncoder(img_vec, symbols, my_dict);
    huffman_coded_length = length(char(strjoin(huffman_coded, '')));
    toc
    fprintf("Number symbols in Huffman: %d \n", length(uniq_symbols));
    fprintf("Compressed Number of bits: %d \n", huffman_coded_length);
    fprintf("My Huffman coding compresion: %f \n", ...
            (IMG_LEN * BIT_NUM) / huffman_coded_length);
    tic
    text = char(strjoin(string(img_vec),''));
    [lempel_coded, max_bits] = MyLempelZiv(text, 3);
    toc
    lempel_coded_length = length(lempel_coded);
    fprintf("Compressed Number of bits: %d \n", lempel_coded_length * (max_bits + BIT_NUM));
    fprintf("Lempel-Ziv coding compresion rate: %f \n", ...
            (IMG_LEN * BIT_NUM) / (lempel_coded_length * (max_bits + BIT_NUM)));
    disp("--------------------------------------");
end


