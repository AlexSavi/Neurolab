function tableout = import_file(workbookFile,sheetName,startRow,endRow)
%IMPORT_FILE Import data from a spreadsheet
%   DATA = IMPORT_FILE(FILE) reads data from the first worksheet in the
%   Microsoft Excel spreadsheet file named FILE and returns the data as a
%   table.
%
%   DATA = IMPORT_FILE(FILE,SHEET) reads from the specified worksheet.
%
%   DATA = IMPORT_FILE(FILE,SHEET,STARTROW,ENDROW) reads from the specified
%   worksheet for the specified row interval(s). Specify STARTROW and
%   ENDROW as a pair of scalars or vectors of matching size for
%   dis-contiguous row intervals. To read to the end of the file specify an
%   ENDROW of inf.%
% Example:
%   config = import_file('config.xls','Feuille1',2,7);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2018/08/20 19:40:01

%% Import the data
[~, ~, raw] = xlsread(workbookFile, sheetName, sprintf('A%d:C%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    [~, ~, tmpRawBlock] = xlsread(workbookFile, sheetName, sprintf('A%d:C%d',startRow(block),endRow(block)));
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
end
stringVectors = string(raw(:,[1,2,3]));
stringVectors(ismissing(stringVectors)) = '';

%% Create table
tableout = table;

%% Allocate imported array to column variable names
tableout.Actionlabels = stringVectors(:,1);
tableout.Toolboxcolors = stringVectors(:,2);
tableout.Matlabcolors = stringVectors(:,3);

