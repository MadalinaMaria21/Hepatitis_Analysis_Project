% Functie care primeste ca parametru matrice de confuzie si calculeaza pe
% baza acesteia o serie de performante ale algorimului
    % confMatrix: matricea de confuzie
function [precision, recall, f1score] = calcul_performanta(confMatrix)
    num_categ = size(confMatrix, 1);
    
    precision = zeros(num_categ, 1);
    recall = zeros(num_categ, 1);
    f1score = zeros(num_categ, 1);

    % se calculeaza TP, TN, FN, FP pentru fiecare categorie
    for i = 1:num_categ
        TP = confMatrix(i, i);
        FP = sum(confMatrix(:, i)) - TP;
        FN = sum(confMatrix(i, :)) - TP;
        TN = sum(confMatrix(:)) - (TP + FP + FN);
        
        precision(i) = TP / (TP + FP + eps); % se adauga eps pentru a evita impartirea la 0
        recall(i) = TP / (TP + FN + eps);
        f1score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i) + eps);
    end
end
