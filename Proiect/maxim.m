% Functie care primeste ca parametru un set de date si care returneaza un
% vector ce contine maximul pentru fiecare coloana in parte.
% In cazul in care functia nu are deloc valori numerice, va afisa NaN.
function valoriMaxim = maxim(data)
    maximColoane = NaN(1, width(data)); 
   
    for col = 1:width(data)
        if isnumeric(data{:, col}) || islogical(data{:, col})
            maximColoane(col) = max(data{:, col}, [], 'omitnan');
        else
            maximColoane(col) = NaN;
        end
    end
    valoriMaxim = maximColoane;
end
