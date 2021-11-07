function [codes, dict] = MyLempelZiv(input_data, symbol_len)
%MYLEMPELZIV calculates lempelziv code based on the input data
%PARAMETERS
%       input_data: input string to be coded
%       symbol_len: input symbol length

    observed_symbols = {};
    codes = {};
    
    % Add first item to the observed symbol list:
    observed_symbols = AppendToCell(observed_symbols, input_data(1:symbol_len));
    % Add first item to the codes list:
    coded_symbol = AddIndex(0, input_data(1:symbol_len));
    codes = AppendToCell(codes, coded_symbol);
    
    origin = symbol_len + 1;
    for i=symbol_len+1:symbol_len:length(input_data)
        current_symbol = input_data(origin:i+symbol_len-1);
        % current symbol doesn't exists
        if ~SymbolExists(observed_symbols, current_symbol)
            % add new symbol to the observed symbols list
            observed_symbols = AppendToCell(observed_symbols, current_symbol);
            if i == origin
                % new symbol
                last_symb_ind = 0;
            else
                % there is another symbol
                last_symb_ind = FindSymbolIndex(observed_symbols, ...
                                        current_symbol(1:end-symbol_len));
            end
            % add index to the first of chr
            coded_symbol = AddIndex(last_symb_ind, current_symbol(end-symbol_len+1:end));
            codes = AppendToCell(codes, coded_symbol);
            origin = i+symbol_len;
        end
    end
    % if last symbols are ramining:
    if origin <= i
        current_symbol = input_data(origin:end);
        last_symb_ind = FindSymbolIndex(observed_symbols, current_symbol);
        coded_symbol = AddIndex(last_symb_ind, '!');
        codes = AppendToCell(codes, coded_symbol);
    end
    dict = observed_symbols;
end

function mod_cell = AppendToCell(in_cell, item)
%APPENDTOCELL append an item to the cell array
    in_cell{end+1} = item;
    mod_cell = in_cell;
end

function flag = SymbolExists(in_cell, symbol)
%SYMBOLEXISTS checks if a symbol exists in a cell array
    flag = any(strcmp(in_cell, symbol));
end

function index = FindSymbolIndex(in_cell, symbol)
%FINDSYMBOLDINDEX finds the symbol index in cell array
    index = find(strcmp(in_cell, symbol));
end

function symbol = AddIndex(index, chr)
%ADDINDEX adds index to the begining of chr
    index_bin = strjoin(string(de2bi(index, 'left-msb')), '');
    symbol = char(index_bin + chr);
end