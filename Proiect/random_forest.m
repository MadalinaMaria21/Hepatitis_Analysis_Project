% Functie pentru antrenarea unui model Random Forest si evaluarea acestuia
    % Intrari:
    %   data - setul de date curatate 
    %   options - structura cu hiperparametrii (numTrees, maxSplits)
    % Iesiri:
    %   accuracy - acuratetea modelului pe setul de testare
    %   feature_importance - importanta caracteristicilor
    %   model - modelul antrenat

    function [accuracyTrain, accuracyTest, feature_importance, YPredTest, YTest, model, trainTime, predictTime] = random_forest(data, options, trainPercent)
    
    % se selecteaza doar coloanele de tip numeric (datele pentru caracteristici)
    numericData = data(:, varfun(@isnumeric, data, 'OutputFormat', 'uniform'));

    % se converteste coloana tinta in numerica (0, 1, 2, 3)
    category = categorizare(data);  % Presupunem ca este colona 'category'
    category = double(categorical(category));  % convertim in numeric (0, 1, 2, 3)
    
    % se adauga coloana de categorie la setul de date
    numericData.Category = category;

    % se impart datele in seturi de antrenament si testare 
    [trainData, testData] = split_data(numericData, category, trainPercent);
    
    % se extrag datele de antrenament si de testare
    XTrain = trainData(:, 1:end-1);
    YTrain = trainData.Category;
    
    XTest = testData(:, 1:end-1);
    YTest = testData.Category;

    % se creaza si antreneaza modelul Random Forest
    numTrees = options.numTrees;
    maxSplits = options.maxSplits;
    tic;
    model = TreeBagger(numTrees, XTrain, YTrain, 'Method', 'classification', ...
                       'MaxNumSplits', maxSplits, 'OOBPrediction', 'on', ...
                       'OOBPredictorImportance', 'on');
    trainTime = toc;

    tic;
    % predictiile pe setul de testare
    YPredTest = str2double(predict(model, XTest));
    predictTime = toc;

    YPredTrain = str2double(predict(model, XTrain));

    accuracyTrain = mean(YPredTrain == YTrain);
    accuracyTest = mean(YPredTest == YTest);

    % importanta caracteristicilor
    feature_importance = model.OOBPermutedPredictorDeltaError;
end
