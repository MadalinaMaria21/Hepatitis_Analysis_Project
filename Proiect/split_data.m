% Functie care primeste ca parametri setul de date, categoriile acestuia si
% procentul de date alocat pentru antrenament si returneaza doua seturi de
% date distincte, unul pentru antrenare si unul pentru testare
    % data: tabelul cu date
    % categories: vector numeric cu etichetele de clasificare
    % percentTrain: procentajul de date alocat pentru antrenament
function [trainData, testData] = split_data(data, categories, percentTrain)
    % se verifica daca lungimea categoriilor corespunde cu numarul de randuri din date
    if numel(categories) ~= height(data)
        error('Lungimea categoriilor nu corespunde cu numarul de randuri din tabelul de date.');
    end
    
    % se gasesc clasele unice
    uniqueClasses = unique(categories);
    trainIdx = [];
    testIdx = [];
    
    % se impart datele pe clase
    for i = 1:numel(uniqueClasses)
        classIdx = find(categories == uniqueClasses(i));
        numTrain = round(percentTrain / 100 * numel(classIdx));
        shuffleIdx = randperm(numel(classIdx));
        trainIdx = [trainIdx; classIdx(shuffleIdx(1:numTrain))];
        testIdx = [testIdx; classIdx(shuffleIdx(numTrain+1:end))];
    end
    
    % se selecteaza randurile pentru seturile de antrenament si testare
    trainData = data(trainIdx, :);
    testData = data(testIdx, :);
end

