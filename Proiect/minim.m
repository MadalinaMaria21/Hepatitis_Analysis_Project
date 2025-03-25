% Functie care primeste ca parametru un set de date si care returneaza un
% vector ce contine minimul pentru fiecare coloana in parte.
% In cazul in care functia nu are deloc valori numerice, va afisa NaN.
function valoriMinim = minim(data)
    minimColoane = NaN(1, width(data)); 
    
    for col = 1:width(data)
        if isnumeric(data{:, col}) || islogical(data{:, col})
            minimColoane(col) = min(data{:, col}, [], 'omitnan');
        else
            minimColoane(col) = NaN;
        end
    end
    valoriMinim = minimColoane; 
end
