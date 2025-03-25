% Functie care primeste ca parametri doua seturi de etichete si categoriile
% setului de date si returneaza o matrice de confuzie
    % yTrue: etichetele reale
    % yPred: etichetele prezise
    % num_categ: numarul de clase (unic in yTrue si yPred)
function confMatrix = matrice_confuzie(yTrue, yPred, num_categ)
    % se initializeaza matricea de confuzie
    confMatrix = zeros(num_categ, num_categ);

    % se populeaza matricea de confuzie
    for i = 1:num_categ
        for j = 1:num_categ
            confMatrix(i, j) = sum((yTrue == i) & (yPred == j));
        end
    end
end
