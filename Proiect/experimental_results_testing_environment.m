close all; clear all; clc;

% se citesc date din csv
csvFileNames = {'HepatitisC.csv', 'HepatitisCdata-50sanatosi.csv', 'HepatitisCdata-doarBolnavi.csv', 'HepatitisCdata-putiniSanatosiMultiBolnavi.csv'};
data = readtable(csvFileNames{4}); 
results_folder = {'results-HepatitisC', 'results-HepatitisCdata-50sanatosi', 'results-HepatitisCdata-doarBolnavi', 'results-HepatitisCdata-putiniSanatosiMultiBolnavi'};

% se valideaza datele din tabel
checked_data = validare_date(data); 

% se genereaza graficul validarii datelor
bar_chart_validare(checked_data);

% s-a decis eliminarea datelor nevalide
cleared_data = clear_data(readtable('HepatitisC-Checked.csv'));

% se verifica buna functionalitate a curatarii datelor
bar_chart_validare(cleared_data); 

disp('--------------------------------------------------------');

% se calculeaza caracteristicile statistice pentru intreg setul de date
afisare_statistici(cleared_data, 'Setul complet de date');

% procentele pentru împărțirea datelor
train_percent = [50, 60, 70, 80]; 

% se configureaza hiperparametrii pentru Random Forest
numTrees_list = [50, 200, 500];      
maxSplits_list = [10, 50]; 
minLeafSize_list = [1, 5]; 
tableData = {};
resultsTable = table();

% buclă pentru procentele de antrenare
for t = 1:length(train_percent)
    disp(['Procesăm pentru procentul de antrenare: ', num2str(train_percent(t)), '%']);

    % împărțirea datelor
    category = categorizare(cleared_data); 
    category = double(categorical(category));
    [trainData, testData] = split_data(cleared_data, category, train_percent(t));

    % se generează un PieChart pentru seturile de date
    generate_piechart(trainData, testData);

    % calculul caracteristicilor statistice
    afisare_statistici(trainData, ['Setul de date de antrenare pentru ', num2str(train_percent(t)), '%']);

    % experimentarea cu diferiți hiperparametri
    for i = 1:length(numTrees_list)
        for j = 1:length(maxSplits_list)
            for k = 1:length(minLeafSize_list)
                
                options.numTrees = numTrees_list(i);
                options.maxSplits = maxSplits_list(j);
                options.minLeafSize = minLeafSize_list(k);
                
                disp(['Antrenam modelul cu ', ...
                      'numTrees = ', num2str(options.numTrees), ...
                      ', maxSplits = ', num2str(options.maxSplits), ...
                      ', minLeafSize = ', num2str(options.minLeafSize)]);

                % apelăm modelul
                [accuracyTrain, accuracyTest, feature_importance, YPredTest, YTest, model, trainTime, predictTime] = ...
                    random_forest(cleared_data, options, train_percent(t));

                % matricea de confuzie
                num_categ = numel(unique(YTest));
                confMatrix = matrice_confuzie(YTest, YPredTest, num_categ);

                % indicatori de performanță
                [precision, recall, f1score] = calcul_performanta(confMatrix);

                % analiza overfitting/underfitting
                overfitting = accuracyTrain - accuracyTest;
                underfitting = min(accuracyTrain, accuracyTest);

                % salvăm rezultatele în tabel
                newRow = table(train_percent(t), numTrees_list(i), maxSplits_list(j), minLeafSize_list(k), ...
                               accuracyTrain, accuracyTest, trainTime, predictTime, overfitting, underfitting, ...
                               'VariableNames', {'TrainPercent', 'NumTrees', 'MaxSplits', 'MinLeafSize', ...
                               'AccuracyTrain', 'AccuracyTest', 'TrainTime', 'PredictTime', 'Overfitting', 'Underfitting'});
                resultsTable = [resultsTable; newRow];

                % generăm grafice
                fig = figure('Name', ['Random Forest - numTrees=', num2str(options.numTrees), ...
                    ', maxSplits=', num2str(options.maxSplits), ...
                    ', minLeafSize=', num2str(options.minLeafSize)], ...
                    'Position', [100, 100, 1400, 800]);

                % Creăm un layout cu 3x3 (3 rânduri și 3 coloane) pentru plasarea graficelor
                tLayout = tiledlayout(3, 3, 'TileSpacing', 'Compact', 'Padding', 'Compact');

                % Importantă caracteristici
                nexttile(1); % Poziția 1
                bar(feature_importance);
                title('Importanța variabilelor');
                xlabel('Caracteristica');
                ylabel('Importanța');
                
                % Distribuția YTest
                nexttile(2); % Poziția 2
                histogram(YTest, 'Normalization', 'probability');
                title('Distributia claselor în YTest');
                xlabel('Clase');
                ylabel('Frecventă');
                
                % Distribuția YPred
                nexttile(3); % Poziția 3
                histogram(YPredTest, 'Normalization', 'probability');
                title('Distributia claselor în YPred');
                xlabel('Clase');
                ylabel('Frecventă');
                
                % Matricea de confuzie
                nexttile(4); % Poziția 4
                heatmap(confMatrix, 'Title', 'Matricea de confuzie', ...
                        'XLabel', 'Prezis', 'YLabel', 'Real', ...
                        'ColorbarVisible', 'on');
                
                % Acuratețea modelului
                nexttile(5); % Poziția 5
                text(0.5, 0.5, sprintf('Acuratetea Modelului:\n%.2f%%', accuracyTest * 100), ...
                    'FontSize', 14, 'FontWeight', 'bold', ...
                    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
                axis off;
            end
        end
    end
end

% afișăm tabelul final de rezultate
disp('Tabelul final al rezultatelor:');
disp(resultsTable);

% grafic pentru analiza overfitting
% Agregăm valorile de Overfitting pentru fiecare numTrees
aggregatedResults = groupsummary(resultsTable, 'NumTrees', 'mean', 'Overfitting');

% Creăm graficul pentru Overfitting
figure('Name', 'Overfitting Analysis');
bar(categorical(string(aggregatedResults.NumTrees)), aggregatedResults.mean_Overfitting);
title('Overfitting Analysis');
ylabel('Overfitting');
xlabel('NumTrees');


% grafic pentru metricele numerice
% Agregăm valorile de AccuracyTrain și AccuracyTest pentru fiecare NumTrees
aggregatedResults = groupsummary(resultsTable, 'NumTrees', 'mean', {'AccuracyTrain', 'AccuracyTest'});

% Creăm graficul pentru AccuracyTrain și AccuracyTest
figure('Name', 'Accuracy Train vs Test');
subplot(2, 1, 1);
bar(categorical(string(aggregatedResults.NumTrees)), aggregatedResults.mean_AccuracyTrain);
title('Accuracy Train');
ylabel('Accuracy');
xlabel('NumTrees');

subplot(2, 1, 2);
bar(categorical(string(aggregatedResults.NumTrees)), aggregatedResults.mean_AccuracyTest);
title('Accuracy Test');
ylabel('Accuracy');
xlabel('NumTrees');


subplot(2, 1, 2);
bar(categorical(string(resultsTable.NumTrees)), [resultsTable.TrainTime resultsTable.PredictTime]);
title('Train Time vs Predict Time');
ylabel('Time (s)');
legend('Train Time', 'Predict Time');
