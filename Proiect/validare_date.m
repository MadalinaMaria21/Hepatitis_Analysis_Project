function dateValidate = validare_date(data)
    % Verifică dacă inputul este un tabel
    if ~istable(data)
        error('Inputul trebuie să fie un tabel.');
    end
    
    % Conversie la celule pentru prelucrare
    data_out = table2cell(data); 
    
    % Iterare prin fiecare element și înlocuire a valorilor goale cu NaN
    for i = 1:size(data_out, 1)
        for j = 1:size(data_out, 2)
            if isempty(data_out{i, j}) || (ischar(data_out{i, j}) && isempty(strtrim(data_out{i, j})))
                data_out{i, j} = NaN;
            end
        end
    end
    
    % Conversie înapoi la tabel cu aceleași nume de coloane
    dateValidate = cell2table(data_out, 'VariableNames', data.Properties.VariableNames);
    
    % Salvare în fișier CSV
    outputFileName = 'HepatitisC-Checked.csv'; 
    writetable(dateValidate, outputFileName);
    disp(['Fișierul validat a fost salvat ca: ', outputFileName]);
end
