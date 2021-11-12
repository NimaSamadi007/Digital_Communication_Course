function dict = MyHuffman(symbols, prob_dist)
%MYHUFFMAN calculates huffman code based on the distribution
%parameters: 
%   prob_dist: probability distibution of charachtares
%   symbols: input symbols (during code I will use 1:length(symbol) instead
%            of input symbols. However at the end I will convert them
%   dict: huffman dictionary  

    symbol_num = length(prob_dist);
    [prob_dist, symbol_indices] = sort(prob_dist, 'descend');
    nodes = ConstructLeaves(prob_dist);
    trees = nodes;
    
    internal_nodes = -1;
    while size(trees, 1) > 1
        % sort tree by second entry (probablity) descend
        trees = SortByEntry(trees, 2, 'ascend');
        % combine two improbable nodes and form another one
        new_node = {internal_nodes, trees{1, 2} + trees{2, 2} ...
                    trees{1, 1}, trees{2, 1}, ''};
        % delete two nodes
        trees = DeleteCellElement(trees, 1);
        trees = DeleteCellElement(trees, 1);
        % append internal node to tree (tree is like a queue)
        trees = AppendCellElement(trees, new_node);
        % append internal node to nodes
        nodes = AppendCellElement(nodes, new_node);
        internal_nodes = internal_nodes - 1;
    end
    % from nodes find huffman code recursively
    shape = size(nodes);
    nodes = CalCode(nodes, shape(1), ' ', symbol_num);
    % extract symbol nodes 
    dict = NodesToCodes(nodes, symbol_num);
    % map input symbols and my symbols
    dict = SymbolMapper(dict, symbols, symbol_indices);
    % sort symbol by symbol name (must be integer)
    dict = SortByEntry(dict, 1, 'ascend');
end


function leaves = ConstructLeaves(prob_dist)
% Makes each symbol a leaf: [symbol, probability, left_child, right_child, code_word]
% 0 means that there is no child
    leaves = cell(length(prob_dist), 5);
    for i=1:length(prob_dist)
        leaves(i, :) = {i, prob_dist(i), 0, 0, ''};
    end
end

function nodes = CalCode(nodes, index, prefix, len)
% Assigns huffman code recursively to each symbol
    if nodes{index, 3} < 0
        nodes = CalCode(nodes, len + abs(nodes{index, 3}), ...
                        strcat(prefix, '1'), len); 
    else
        code_node_index = nodes{index, 3};
        nodes{code_node_index, 5} = strcat(prefix, '1');
    end
    
    if nodes{index, 4} < 0
        nodes = CalCode(nodes, len + abs(nodes{index, 4}), ...
                        strcat(prefix, '0'), len); 
    else
        code_node_index = nodes{index, 4};
        nodes{code_node_index, 5} = strcat(prefix, '0');
    end
    return;
end

function out_cell = AppendCellElement(in_cell, cell_item)
    out_cell = in_cell;
    out_cell(end+1, :) = cell_item;
end

function out_cell = DeleteCellElement(in_cell, index)
% Deletes one cell element in index position
    out_cell = in_cell;
    out_cell(index, :) = [];
end

function out_tree = SortByEntry(tree, entry_index, type)
    out_tree = cell(size(tree));
    entry = ExtractEntry(tree, entry_index);
    [~, indices] = sort(entry, type);
    for i=1:size(tree, 1)
        out_tree(i, :) = tree(indices(i), :); 
    end
end

function entry = ExtractEntry(tree, index)
% Extracts element in tree, used in sorting
    entry = zeros(1, size(tree, 1));
    for i=1:size(tree, 1)
       entry(i) = tree{i, index}; 
    end
end

function codes = SymbolMapper(codes, symbols, indices)
%SYMBOLMAPPER maps my symbols to input symbols
    for i=1:length(codes)
        codes{i, 1} = symbols(indices(i));
    end
end

function codes = NodesToCodes(nodes, symbol_num)
% Extracts codes and symbols
    codes = cell(symbol_num, 2);
    for i=1:symbol_num
        codes{i, 1} = nodes{i, 1};
        codes{i, 2} = nodes{i, 5};
    end
end

