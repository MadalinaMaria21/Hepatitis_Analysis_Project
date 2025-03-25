% Functie care primeste ca parametru un set de date si care returneaza un
% vector ce contine modulul pentru fiecare coloana in parte.
% In cazul in care functia nu are deloc valori numerice, va afisa NaN.
function valoriModul = modul(data)
    modulColoana = NaN(1, width(data));

    for col = 1:width(data)
        if isnumeric(data{:, col}) || islogical(data{:, col})
            modulColoana(col) = mode(data{~isnan(data{:, col}), col});
        else
            modulColoana(col) = NaN;
        end
    end
    valoriModul = modulColoana;
end
