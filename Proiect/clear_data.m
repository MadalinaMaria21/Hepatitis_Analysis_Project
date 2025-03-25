% Functie care primeste ca parametru un set de date pentru care face
% operatia de cutatare a valorile NaN
    % data: tabelul cu setul de date
function dataCleaned = clear_data(data)
    % se verifica daca inputul este un tabel
    if ~istable(data)
        error('Inputul trebuie sa fie un tabel!');
    end
    
    % se cauta liniile care contin NaN
    rowsWithNaN = any(ismissing(data), 2);
    
    % se elimina liniile care contin NaN
    dataCleaned = data(~rowsWithNaN, :);
    
    % se salveaza un tabel curatat intr-un fisier CSV
    outputFileName = 'HepatitisC-Cleared.csv'; 
    writetable(dataCleaned, outputFileName);
    disp(['Fisierul curatat a fost salvat ca: ', outputFileName]);
end
