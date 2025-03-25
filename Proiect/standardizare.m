% Functie care primeste ca parametru un set de date si care returneaza un
% vector ce contine standardizarea pentru fiecare coloana in parte.
% In cazul in care functia nu are deloc valori numerice, va afisa NaN.
% standardizare = (x - media) / deviatiaStandard
function valoriStandardizare = standardizare(data)
    valoriStandardizare = NaN(size(data)); 

    for col = 1:width(data)
        if isnumeric(data{:, col}) || islogical(data{:, col})
            colData = data{:, col}; 
            colMean = mean(colData, 'omitnan'); 
            colStd = std(colData, 'omitnan'); 
            
            if colStd > 0 
                valoriStandardizare(:, col) = (colData - colMean) / colStd;
            else
                valoriStandardizare(:, col) = 0; 
            end
        else
            valoriStandardizare(:, col) = NaN;
        end
    end
end
