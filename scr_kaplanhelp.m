%
tidy;

datapath = '/Volumes/DATA/surveySimple.xlsx';
T = readtable(datapath);
Qs = T(:,6:20);
Mods = table2cell(T(:,2));

coursenames = {'FC017', 'FC018', 'FC020', 'FC021','FC023', 'FC026',...
    'FC040','PM010', 'PM060', 'PM061', 'PM506'};

%%
clc
%ix=1;
for ix=1:length(coursenames)
    thistable = Qs(contains(Mods,coursenames{ix}), :);
    thisst.stronglyagree = sum(contains(thistable.Variables, '5'));
    thisst.agree = sum(contains(thistable.Variables, '4'));
    thisst.neither = sum(contains(thistable.Variables, '3'));
    thisst.disagree = sum(contains(thistable.Variables, '2'));
    thisst.stronglydisagree = sum(contains(thistable.Variables, '1'));
    thisst.total = sum(contains(Mods,coursenames{ix}));
    
    thisst.calcmatrix = [thisst.stronglyagree
        thisst.agree
        thisst.neither
        thisst.disagree
        thisst.stronglydisagree];
    thisst.wavg = sum(thisst.calcmatrix.*repmat([5;4;3;2;1], 1,...
        size(thisst.calcmatrix,2))./thisst.total);
    
    thisst.calcmatrix = [thisst.calcmatrix; thisst.wavg];
    
    fnames = fieldnames(thisst);
    fnames{6} = ['Weighted_Avg-' coursenames{ix}];
    fnames(7:end) = [];
    
    varTypes = {'double'};
    Taux = table('Size',size(thisst.calcmatrix),...
        'VariableTypes',repmat(varTypes,1,size(thisst.calcmatrix,2)), ...
        'RowNames', fnames);
    Taux.Variables = thisst.calcmatrix;
    Taux(:,16:end) = [];
    
    outxls = '/Volumes/DATA/outputpoll.xlsx';
    writetable(Taux,outxls,'Sheet',ix, 'WriteRowNames',true);
    
    
end

%%

tidy;

path2data = '/Volumes/DATA/surveySimple.xlsx';
T = readtable(path2data);
moduleCodes = unique(T.modulecode);
tutors = unique(T.tutor);
programme = unique(T.programme);

AvgScores = zeros(length(moduleCodes), length(6:20));
AvgScoresPerTutor = zeros(length(tutors), length(6:20));
AvgScoresPerProgramme = zeros(length(programme), length(6:20));

for ix=1:length(moduleCodes)
    AvgScores(ix,:) = mean(T(contains(T.modulecode, moduleCodes{ix}),6:20).Variables,1);
end

for ix=1:length(tutors)
    AvgScoresPerTutor(ix,:) = mean(T(contains(T.tutor, tutors{ix}),6:20).Variables,1);
end

for ix=1:length(programme)
    AvgScoresPerProgramme(ix,:) = mean(T(contains(T.programme, programme{ix}),6:20).Variables,1);
end

% Move to table before saving 
headings = [{'module'} T.Properties.VariableNames(6:20)];
tavgScore = table('Size', [length(moduleCodes) length(5:20)], ...
    'VariableTypes', ...
    {'string', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double'});
tavgScore.Properties.VariableNames = headings;
tavgScore.module = moduleCodes;
tavgScore(:, 2:end).Variables = AvgScores;

headings = {'module', 'Delivery', 'Materials', 'Assessment'};
tavgPerQ = table('Size', [length(moduleCodes) 4], ...
    'VariableTypes', {'string', 'double', 'double', 'double'});
tavgPerQ.Properties.VariableNames = headings;
tavgPerQ.module = moduleCodes;
tavgPerQ(:,2).Variables = mean(AvgScores(:,1:5), 2);
tavgPerQ(:,3).Variables = mean(AvgScores(:,6:9), 2);
tavgPerQ(:,4).Variables = mean(AvgScores(:,10:14), 2);

headings = [{'tutor'} T.Properties.VariableNames(6:20)];
tavgScorePerTutor = table('Size', [length(tutors) length(5:20)], ...
    'VariableTypes', ...
    {'string', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double'});
tavgScorePerTutor.Properties.VariableNames = headings;
tavgScorePerTutor.tutor = tutors;
tavgScorePerTutor(:, 2:end).Variables = AvgScoresPerTutor;

headings = [{'programme'} T.Properties.VariableNames(6:20)];
tavgScorePerProgramme = table('Size', [length(programme) length(5:20)], ...
    'VariableTypes', ...
    {'string', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double'});
tavgScorePerProgramme.Properties.VariableNames = headings;
tavgScorePerProgramme.programme = programme;
tavgScorePerProgramme(:, 2:end).Variables = AvgScoresPerProgramme;

outxls = '/Volumes/DATA/outputpoll.xlsx';
writetable(tavgScore,outxls,'Sheet',1);
writetable(tavgPerQ,outxls,'Sheet',2);
writetable(tavgScorePerProgramme,outxls,'Sheet',3);
writetable(tavgScorePerTutor,outxls,'Sheet',4);