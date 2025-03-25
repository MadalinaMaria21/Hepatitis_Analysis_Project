% Functie care primeste ca parametru un set de date si care returneaza un 
% vector ce contine devierea standard pentru fiecare coloana in parte.
% In cazul in care functia nu are deloc valori numerice, va afisa NaN.

function valoriDeviereStandard = deviatia_standard(data)
    deviereStandardColoana = NaN(1, width(data));

    for col = 1:width(data)
        if isnumeric(data{:, col}) || islogical(data{:, col})
            deviereStandardColoana(col) = std(data{:, col}, 'omitnan');
        else
            deviereStandardColoana(col) = NaN;
        end
    end
    valoriDeviereStandard = deviereStandardColoana;
end
