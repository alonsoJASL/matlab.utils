% SCRIPT: Mixed effects model. 
% A better way to statistically prove that the amplitudes change (mostly
% decrease) with the distance.
%
%% Clear / create synthetic data
tidy;

t = [0 2.3 5 8 10];
x = repmat(40.*exp(-t./10), 19,1) + repmat([5 4 3 2 1],19,1).*randn(19,5);

T = table(x(:,1), x(:,2), x(:,3), x(:,4), x(:,5), 'VariableNames',...
    {'zero', 'two', 'five', 'eight', 'ten'});

% The table T contains all the subjects with the mean amplitude per
% distance. 

disp(T);
disp('Mean per column:')
disp(mean(T.Variables));
disp('std per column')
disp(std(T.Variables));
%% ANOVA (as I understood it on two seconds of seeing this)
% The anova (in this way of implementing it) will compare the hypotheses: 
% H0 = all the means from all the colums are the same
% vs.
% H1 = at least one of the means is different from the others. 
%
clc;
disp('ANOVA and Bonferroni');
group = {'zero', 'two', 'five', 'eight', 'ten'};
[p,tbl,stats] = anova1(x, group);
% Tukey's honestly significant difference 
% (visualise which groups cannot be 'rejected')
figure(21);
c = multcompare(stats);
title('Matlabs default comparison: click on the group you want to test')
% Bonferroni (because yolo? it determines which distances (0,2,5,8 or 10)
% makes a difference in the mean amplitude of the signals.
figure(22);
c2 = multcompare(stats, 'CType', 'bonferroni');
title('Bonferroni comparison: click on the group you want to test');

% You could do this analysis and it would be equivalent to the pairwise
% comparison that was reported in the paper. However, it only compares
% whether the means are different; not whether the amplitude is (or looks
% like it's) decreasing.

% doc anova1
% doc multcompare

%% MIXED-EFFECTS model.
% This is another alternative, it is more robust, and I think it would give
% a good result. 
%clc;
disp('Mixed-effects model')
% Rearranging the data:
tbl = table(reshape(x,numel(x),1), ...
    reshape(repmat(t,size(x,1),1), numel(x),1), ...
    repmat((1:size(x,1))',size(x,2),1), ...
    'VariableNames', {'amplitude', 'dist2tissue','groupidx'});

lme = fitlme(tbl,'amplitude~dist2tissue+(1|groupidx)');
% What this does is fit a line (y=mx + c) that relates the y (amplitude) 
% with the x (dist2tissue). What the model finds is the values of m and c. 
% The intercept c, is not that important, we want to see the value for m,
% i.e the gradient of the line. If m is negative, then that the amplitude 
% decreases when the distance increases. 

% The cool thing is that both c and m have p-values associated to them,
% which tell you whether the value of (for example) m is a 'good one'. 

% So... what you need to report is the value of the coefficient associated
% to the distance, the p-value and the confidence interval where these
% values appear.
disp('ALL THE INFORMATION OF THE COEFFICIENTS:')
disp(lme.Coefficients);

str.varname = lme.Coefficients.Name(2);
str.m = lme.Coefficients.Estimate(2);
str.pval = lme.Coefficients.pValue(2);
str.interval = sprintf('m=%2.2f lies between: %2.2f and %2.2f %s',...
    lme.Coefficients.Estimate(2), lme.Coefficients.Lower(2),...
    lme.Coefficients.Upper(2), '(at a 95% confidence level)');

disp('RELEVANT INFORMATION')
disp(str);
% doc fitlme
%% 
clc
lme1 = fitlme(tbl,'amplitude~dist2tissue+(1|groupidx)');
% 'CityMPG~Horsepower+(1|EngineType)+(Horsepower-1|EngineType)'
lme2 = fitlme(tbl,'amplitude~dist2tissue+(1|groupidx)+(dist2tissue|groupidx)');
lme3 = fitlme(tbl,'amplitude~(1+dist2tissue|groupidx)');