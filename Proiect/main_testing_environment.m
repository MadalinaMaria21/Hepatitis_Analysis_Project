close all; clear all; clc;

% se citesc date din csv
data = readtable('HepatitisC.csv'); 

% se valideaza datele din tabel
checked_data = validare_date(data); 

% se genereaza graficul validarii datelor
bar_chart_validare(checked_data);

% s-a decis eliminarea datelor nevalide datorita faptului ca nu erau
% intr-un numar considerabil
cleared_data = clear_data(readtable('HepatitisC-Checked.csv'));

% se verifica buna functionalitate a curatarii datelor
bar_chart_validare(cleared_data); 

disp('--------------------------------------------------------');

% se calculeaza caracteristicile statistice pentru intreg setul de date
afisare_statistici(cleared_data, 'Setul complet de date');

% procentul datelor de antrenare
train_percent = 20; 

% se cauta categoriile de date din setul de date
%category = categorizare(cleared_data);
category = categorizare(cleared_data);  % Presupunem ca este colona 'category'
category = double(categorical(category));
% se impart datele in doua seturi distincte de date
[trainData, testData] = split_data(cleared_data, category, train_percent);

% se genereaza un PieChart pentru cele 2 seturi de date
generate_piechart(trainData, testData);

% se calculeaza caracteristicile statistice pentru setul de date de
% antrenare
afisare_statistici(trainData, 'Setul de date de antrenare');

% se aleg hiperparametrii pentru Random Forest
options.numTrees = 50;  % numar de arbori
options.maxSplits = 10;  % numar maxim de diviziuni

% se apeleaza functia de antrenare si evaluare a modelului
[accuracy, feature_importance, YPred, YTest, model] = random_forest(cleared_data, options, train_percent);
[accuracyTrain, accuracyTest, feature_importance, YPred, YTest, model, trainTime, predictTime] = ...
                        random_forest(cleared_data, options, currentTrainPercent);
% se vizualizeaza importanta caracteristicilor
figure;
bar(feature_importance);
title('Importanta variabilelor');
xlabel('Caracteristica');
ylabel('Importanta');

disp('Distributia claselor în YTest:');
tabulate(YTest);
disp('Distributia claselor în YPred:');
tabulate(YPred);
disp('--------------------------------------------------------');

% se afiseaza performanta modelului
disp(['Acuratețea modelului este: ', num2str(accuracy)]);

% nr de clase de test
num_categ = numel(unique(YTest));

% se construieste matricea de confuzie
confMatrix = matrice_confuzie(YTest, YPred, num_categ);

% se afiseaza matricea de confuzie
disp('Matricea de confuzie:');
disp(confMatrix);
disp('--------------------------------------------------------');

% se calculeaza indicatorii de performanta
[precision, recall, f1score] = calcul_performanta(confMatrix);

% se afiseaza indicatorii pentru fiecare clasa
disp('Indicatori de performanta pentru fiecare categorie:');
for i = 1:num_categ
    disp(['Clasa ', num2str(i)]);
    disp(['   Precizie: ', num2str(precision(i))]);
    disp(['   Recall: ', num2str(recall(i))]);
    disp(['   F1-Score: ', num2str(f1score(i))]);
end
disp('--------------------------------------------------------');


