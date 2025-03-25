% Functie care primeste ca parametru un set de date si categorizeaza liniile 
% in functie de coloana Category
    % data: tabel care contine setul de date
function categoryNumeric = categorizare(data)
    % se verifica daca exista coloana 'Category' in tabel
    if ~ismember('Category', data.Properties.VariableNames)
        error('Nu există coloana Category');
    end

    % se transforma coloana 'Category' intr-un vector numeric
    categoryNumeric = double(categorical(data.Category));
end
