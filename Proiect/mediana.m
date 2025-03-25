% Functie care primeste ca parametru un set de date si care returneaza un
% vector ce contine mediana pentru fiecare coloana in parte.
% In cazul in care functia nu are deloc valori numerice, va afisa NaN.
function valoriMediana = mediana(data)
    medianaColoana = NaN(1, width(data)); 

    for col = 1:width(data)
        if isnumeric(data{:, col}) || islogical(data{:, col})
            medianaColoana(col) = median(data{:, col}, 'omitnan');
        else
            medianaColoana(col) = NaN;
        end
    end
    valoriMediana = medianaColoana; 
end
