% Functie care primeste ca parametru un set de date si care returneaza un
% vector ce contine media pentru fiecare coloana in parte.
% In cazul in care functia nu are deloc valori numerice, va afisa NaN.
function valoriMedie = media(data)
    medieColoana = NaN(1, width(data));

    for col = 1:width(data)
        if isnumeric(data{:, col}) || islogical(data{:, col})
            medieColoana(col) = mean(data{:, col}, 'omitnan');
        else
            medieColoana(col) = NaN;
        end
    end
    valoriMedie = medieColoana;

end