function [BIdentifiersCell, HeaderCell2Take] = ...
    ReadingVRheaderAndBmatrix(HeaderFile, BFile, RawTrialOutcomeStates, States, HeaderDeliminator, EndStatePositions2DealWith, FirstHeaderPos, LastHeaderPos)

%% Checking File Format
if iscell(HeaderFile)
    [~,~,format] = fileparts(HeaderFile{1});
else
    [~,~,format] = fileparts(HeaderFile);
end

%% Processing Header txt file
if strcmp(format,'.txt') == 1
    RawHeader = importdata(HeaderFile);
    SplitHeader = cellfun(@(x) split(x,HeaderDeliminator), RawHeader, 'uniformoutput', false);
    CombinedHeader = cat(1, SplitHeader{:});
    CleanedHeader = cellfun(@(x) strrep(x,'"',''), CombinedHeader, 'uniformoutput', false);
    CleanedHeader = cellfun(@(x) strrep(x,'&',''), CleanedHeader, 'uniformoutput', false);
    CleanedHeader = cellfun(@(x) strrep(x,'CStr',''), CleanedHeader, 'uniformoutput', false);
    CleanedHeader = cellfun(@(x) strrep(x,'(',''), CleanedHeader, 'uniformoutput', false);
    CleanedHeader = cellfun(@(x) strrep(x,')',''), CleanedHeader, 'uniformoutput', false);
    CleanedHeader = cellfun(@(x) strrep(x,' ',''), CleanedHeader, 'uniformoutput', false);
    HeaderCell = CleanedHeader(~cellfun('isempty',CleanedHeader));

elseif strcmp(format,'.xlsx') == 1
    [~, ExcelText] = xlsread(HeaderFile);
    ExcelHeader = {ExcelText{1,:}}';
    CleanedHeader = cellfun(@(x) strrep(x,'"',''), ExcelHeader, 'uniformoutput', false);
    CleanedHeader = cellfun(@(x) strrep(x,'&',''), CleanedHeader, 'uniformoutput', false);
    CleanedHeader = cellfun(@(x) strrep(x,'CStr',''), CleanedHeader, 'uniformoutput', false);
    CleanedHeader = cellfun(@(x) strrep(x,'(',''), CleanedHeader, 'uniformoutput', false);
    CleanedHeader = cellfun(@(x) strrep(x,')',''), CleanedHeader, 'uniformoutput', false);
    CleanedHeader = cellfun(@(x) strrep(x,' ',''), CleanedHeader, 'uniformoutput', false);
    HeaderCell = CleanedHeader(~cellfun('isempty',CleanedHeader)); 
end

%% Checking File Format
if iscell(BFile)
    [~,~,format] = fileparts(BFile{1});
else
    [~,~,format] = fileparts(BFile);
end

%% Reading BIdentifier Data
if strcmp(format,'.csv') == 1
    RawBIdentifiers = readtable(BFile);
    RawBIdentifiersCell = table2cell(RawBIdentifiers);
    % Speed Optimization
    % RawBIdentifiersCellSplit = cellfun(@(x) split(x,';'), RawBIdentifiersCell, 'uniformoutput', false);
    RawBIdentifiersCellSplit = cellfun(@(x) regexp(x, ';', 'split'), RawBIdentifiersCell, 'uniformoutput', false);
    RawBIdentifiersCleaned = cellfun(@(x) strrep(x,x{1,1}(1),''), RawBIdentifiersCellSplit, 'uniformoutput', false);
    Cells2TakeOut = zeros(length(RawBIdentifiersCleaned),1);
    Cells2TakeOut([1,2,3:2:length(RawBIdentifiersCleaned),length(RawBIdentifiersCleaned)],1) = 1;
    RawBIdentifiersCleaned(logical(Cells2TakeOut)) = [];
    % This line is to take out End States that happened within a trial (aka End
    % State that doesnt have its own Start State)
    RawBIdentifiersCleaned(EndStatePositions2DealWith) = [];
    TrialIdentifier = RawTrialOutcomeStates;
    BIdentifiersExtracted = cellfun(@(x) x(find(contains(x,TrialIdentifier))+1:end), RawBIdentifiersCleaned, 'uniformoutput', false);
    BIdentifiersCellTemp1 = BIdentifiersExtracted(~cellfun('isempty',BIdentifiersExtracted));
    FirstHeaderPosIndex = find(contains(HeaderCell, FirstHeaderPos));
    LastHeaderPosIndex = find(contains(HeaderCell, LastHeaderPos));
    % Restricting HeaderCell to the fields that are used
    HeaderCell2Take = HeaderCell(FirstHeaderPosIndex:LastHeaderPosIndex);
    nBIdentifiersExtracted = length(BIdentifiersCellTemp1{1});
    nHeadersExtracted = length(HeaderCell2Take);
    if nHeadersExtracted > nBIdentifiersExtracted
        BIdentifiersCellTemp2 = cellfun(@(x) x((nHeadersExtracted-nBIdentifiersExtracted)+1:end), BIdentifiersCellTemp1, 'uniformoutput', false);
    else 
        BIdentifiersCellTemp2 = cellfun(@(x) x((nBIdentifiersExtracted-nHeadersExtracted)+1:end), BIdentifiersCellTemp1, 'uniformoutput', false);
    end
    BIdentifiersCell = cellfun(@(x) NaN2Cell(x, nHeadersExtracted), BIdentifiersCellTemp2, 'uniformoutput', false); 

elseif strcmp(format,'.xlsx') == 1
    [ExcelData, ~] = xlsread(BFile);
    BIdentifiersExtracted = ExcelData(contains(States,TrialOutcomeStates),find(contains(HeaderCell,'newpos')):end);
    BIdentifiersTranspose = transpose(BIdentifiersExtracted);
    BIdentifiersCell = mat2cell(BIdentifiersTranspose, size(BIdentifiersExtracted,2),ones(1,size(BIdentifiersExtracted,1)))';
     
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cell Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CellOutput = NaN2Cell(CellInput, nHeadersExtracted)

CellOutput = CellInput;
if length(CellInput) < nHeadersExtracted
    CellOutput(1:nHeadersExtracted) = {'0'};
end
EmptyIndices = cellfun('isempty',CellOutput);
CellOutput(EmptyIndices) = {'0'};
end