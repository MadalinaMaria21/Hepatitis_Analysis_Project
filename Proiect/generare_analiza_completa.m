close all; clear all; clc;

csvFileNames = {'HepatitisC.csv', 'HepatitisCdata-50sanatosi.csv', 'HepatitisCdata-doarBolnavi.csv', 'HepatitisCdata-putiniSanatosiMultiBolnavi.csv'};
results_folder = {'results-HepatitisC', 'results-HepatitisCdata-50sanatosi', 'results-HepatitisCdata-doarBolnavi', 'results-HepatitisCdata-putiniSanatosiMultiBolnavi'};

train_percent = [50, 60, 70, 80];

numTrees_list = [50, 200, 500];      
maxSplits_list = [10, 50]; 
minLeafSize_list = [1, 5]; 

tableData = {};
for csvIdx = 1:length(csvFileNames)
    data = readtable(csvFileNames{csvIdx}); 
    checked_data = validare_date(data);
    bar_chart_validare(checked_data); 
    cleared_data = clear_data(readtable('HepatitisC-Checked.csv'));
    bar_chart_validare(cleared_data);
    afisare_statistici(cleared_data, 'Setul complet de date'); 
    category = categorizare(cleared_data);  
    category = double(categorical(category));
    
    for trainIdx = 1:length(train_percent)
        currentTrainPercent = train_percent(trainIdx);

        [trainData, testData] = split_data(cleared_data, category, currentTrainPercent);
        generate_piechart(trainData, testData);
        
        afisare_statistici(trainData, 'Setul de date de antrenare');

        for i = 1:length(numTrees_list)
            for j = 1:length(maxSplits_list)
                for k = 1:length(minLeafSize_list)

                    options.numTrees = numTrees_list(i);
                    options.maxSplits = maxSplits_list(j);
                    options.minLeafSize = minLeafSize_list(k);

                    disp(['Antrenam model cu ', ...
                          'numTrees = ', num2str(options.numTrees), ...
                          ', maxSplits = ', num2str(options.maxSplits), ...
                          ', minLeafSize = ', num2str(options.minLeafSize)]);

                    [accuracyTrain, accuracyTest, feature_importance, YPred, YTest, model, trainTime, predictTime] = ...
                        random_forest(cleared_data, options, currentTrainPercent);
                    overfitting = accuracyTrain - accuracyTest;
                    underfitting = min(accuracyTrain, accuracyTest);

                    num_categ = numel(unique(YTest));
                    confMatrix = matrice_confuzie(YTest, YPred, num_categ);
                    [precision, recall, f1score] = calcul_performanta(confMatrix);

                    fig = figure('Name', ['Random Forest - numTrees=', num2str(options.numTrees), ...
                                    ', maxSplits=', num2str(options.maxSplits), ...
                                    ', minLeafSize=', num2str(options.minLeafSize)], ...
                           'Position', [100, 100, 1400, 800]);

                    t = tiledlayout(3, 3, 'TileSpacing', 'Compact', 'Padding', 'Compact');
                    
                    nexttile(t, [1, 1]);
                    bar(feature_importance);
                    title('Feature Importance');
                    xlabel('Feature');
                    ylabel('Importance');
                    
                    nexttile(t, [1, 1]);
                    histogram(YTest, 'Normalization', 'probability');
                    title('Class Distribution in YTest');
                    xlabel('Classes');
                    ylabel('Frequency');
                    
                    nexttile(t, [1, 1]);
                    histogram(YPred, 'Normalization', 'probability');
                    title('Class Distribution in YPred');
                    xlabel('Classes');
                    ylabel('Frequency');

                    nexttile(t, [1, 1]);
                    heatmap(confMatrix, 'Title', 'Confusion Matrix', ...
                            'XLabel', 'Predicted', 'YLabel', 'Actual', ...
                            'ColorbarVisible', 'on');
                    
                    nexttile(t, [1, 1]);
                    text(0.5, 0.5, sprintf('Model Accuracy Train: %.2f%% \n Model Accuracy Test: %.2f%% \n\n Train Time: %fs \n Predict Time: %fs \n Overfitting: %f \n Overfitting: %f', accuracyTrain * 100, accuracyTest * 100, trainTime, predictTime, overfitting, underfitting), ...
                        'FontSize', 14, 'FontWeight', 'bold', ...
                        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
                    axis off;
                    
                    colNames = {'Class', 'Precision', 'Recall', 'F1-Score'};
                    rowData = [(1:num_categ)', precision, recall, f1score];
                    uitable('Data', rowData, 'ColumnName', colNames, ...
                            'RowName', [], 'Units', 'Normalized', ...
                            'FontSize', 10, 'ColumnWidth', {50, 100, 100, 100}, ...
                            'Position', [0.72, 0.42, 0.26, 0.19]);


                    filename = sprintf('RandomForest_%s_TrainPct_%d_numTrees_%d_maxSplits_%d_minLeafSize_%d.png', ...
                                       erase(csvFileNames{csvIdx}, '.csv'), currentTrainPercent, ...
                                       options.numTrees, options.maxSplits, options.minLeafSize);
                    saveas(fig, fullfile(results_folder{csvIdx}, filename));
                    disp('Press Enter to continue to the next iteration.');
                    pause;  
                    close(fig);

                    predictorNames = model.PredictorNames; 
                    row = {num2str(numTrees_list(i)), num2str(maxSplits_list(j)), num2str(minLeafSize_list(k)), num2str(accuracyTrain), num2str(accuracyTest), num2str(trainTime), num2str(predictTime), num2str(overfitting), num2str(underfitting)};
                    for idx = 1:length(predictorNames)
                        row{end+1} = num2str(feature_importance(idx)); 
                    end
                    tableData = [tableData; row];


                end
            end
        end
    end
end

predictorNames = model.PredictorNames; 
colNames = {'NumTrees', 'MaxSplits', 'MinLeafSize', 'Accuracy Train', 'Accuracy Test', 'Train Time', 'Predict Time', 'Overfitting', 'Underfitting' predictorNames{:}};
uitableData = cell2table(tableData, 'VariableNames', colNames);
fig = figure('Position', [100, 100, 1600, 1000]);
uitable('Data', uitableData{:,:}, 'ColumnName', uitableData.Properties.VariableNames, ...
        'Position', [20, 20, 1400, 800]);
