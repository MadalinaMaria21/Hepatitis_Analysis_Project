% Functie care genereaza cate un PieChart cu repartitia categoriilor pe
% fiecare set de date (antrenare - testare)
    % trainData: setul de date de antrenare
    % testData: setul de date de testare
function generate_piechart(trainData, testData)
    % se valideaza datele inainte de prelucrare
    if ~ismember('Category', trainData.Properties.VariableNames) || ...
            ~ismember('Category', testData.Properties.VariableNames)
        error('Nu s-a găsit coloana Category');
    end

    % se prelucreaza categoriile unice din ambele seturi de date
    categories = unique([trainData.Category; testData.Category]);

    % se calculeaza procentajul pentru datele de antrenare
    trainCounts = arrayfun(@(cat) sum(strcmp(trainData.Category, cat)), categories);
    trainPercentages = (trainCounts / sum(trainCounts)) * 100;

    % se calculeaza procentajul pentru datele de testare
    testCounts = arrayfun(@(cat) sum(strcmp(testData.Category, cat)), categories);
    testPercentages = (testCounts / sum(testCounts)) * 100;

    % se genereaza un PieChart pentru datele de antrenare
    figure;
    subplot(1, 2, 1);
    pie(trainPercentages, cellstr(categories));
    title('Distribuția datelor de antrenare');
    legend(cellstr(categories), 'Location', 'southoutside', 'Orientation', 'horizontal');

    % se genereaza un PieChart pentru datele de testare
    subplot(1, 2, 2);
    pie(testPercentages, cellstr(categories));
    title('Distribuția datelor de testare');
    legend(cellstr(categories), 'Location', 'southoutside', 'Orientation', 'horizontal');
end
