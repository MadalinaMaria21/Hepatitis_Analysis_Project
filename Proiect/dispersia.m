% Functie care primeste ca parametru un set de date si care returneaza un
% vector ce contine dispersia / variatia pentru fiecare coloana in parte
% In cazul in care functia nu are deloc valori numerice, va afisa NaN.
function valoriDispersie = dispersia(data)
    dispersieColoana = NaN(1, width(data));

    for col = 1:width(data)
        if isnumeric(data{:, col}) || islogical(data{:, col})
            dispersieColoana(col) = var(data{:, col}, 'omitnan');
        else
            dispersieColoana(col) = NaN;
        end
    end
    valoriDispersie = dispersieColoana;
end