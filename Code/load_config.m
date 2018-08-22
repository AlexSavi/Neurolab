%% Function Name: load_config
%
% Inputs:
%   fileName (string) : A valid .xls configuration file (see config.xls) 
%
% Outputs:
%   output (1x3 cell array) : {6x1 string 6x1 cell 6x1 string}
%
% $Date: August 20, 2018
% ________________________________________

function output = load_config(fileName, sheetName, startRow, endRow)

    % If no sheet is specified, read first sheet
    if nargin == 1 || isempty(sheetName)
        sheetName = 1;
    end
    
    % If row start and end points are not specified, define defaults
    if nargin <= 3
        sheetName = 'Feuille1';
        startRow = 2; % avoids title row.
        endRow = 100; % can be augmented or reduced according to data.
    end

    config = import_file(fileName, sheetName, startRow, endRow);

    labels = cellstr(config{:,1});
    psych_colors_string = config{:,2};
    plot_colors = config{:,3};

    psych_colors = {};

    for i = 1:length(psych_colors_string)
        entry = psych_colors_string(i);
        cell_entry = { str2num(cell2mat(entry)) };
        psych_colors(end+1, 1) = cell_entry;
    end
    
    labels = labels(~cellfun('isempty',labels));
    psych_colors = num2cell(psych_colors(~cellfun('isempty',psych_colors)));
    plot_colors(strcmp('',plot_colors)) = [];
    
    output = {labels psych_colors plot_colors};
end
