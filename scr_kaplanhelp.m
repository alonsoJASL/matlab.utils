%



datapath = '/Volumes/DATA/Data.csv';
T = readtable(datapath);
Qs = T(:,14:end);
Mods = T(:,10);

coursenames = {'FC017', 'FC018', 'FC020', 'FC021','FC023', 'FC026',...
    'FC040','PM010', 'PM060', 'PM061', 'PM506'};

%%
clc
%ix=1;
for ix=1:length(coursenames)
    thistable = Qs(contains(Mods.Variables,coursenames{ix}), :);
    thisst.stronglyagree = sum(contains(thistable.Variables, '5'));
    thisst.agree = sum(contains(thistable.Variables, '4'));
    thisst.neither = sum(contains(thistable.Variables, '3'));
    thisst.disagree = sum(contains(thistable.Variables, '2'));
    thisst.stronglydisagree = sum(contains(thistable.Variables, '1'));
    thisst.total = sum(contains(Mods.Variables,coursenames{ix}));
    
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