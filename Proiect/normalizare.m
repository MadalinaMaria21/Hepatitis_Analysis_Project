% Functie care primeste ca parametru un set de date si care returneaza un
% vector ce contine normalizarea pentru fiecare coloana in parte.
% In cazul in care functia nu are deloc valori numerice, va afisa NaN.
% normalizare = (x-min(x)) / (max(x)-min(x))
function valoriNormalizare = normalizare(data)
    valoriNormalizare = NaN(size(data)); 

    for col = 1:width(data)
        if isnumeric(data{:, col}) || islogical(data{:, col})
            colData = data{:, col}; 
            colMin = min(colData, [], 'omitnan');
            colMax = max(colData, [], 'omitnan'); 
            
            if colMax > colMin 
                valoriNormalizare(:, col) = (colData - colMin) / (colMax - colMin);
            else
                valoriNormalizare(:, col) = 0; 
            end
        else
            valoriNormalizare(:, col) = NaN;
        end
    end
end
