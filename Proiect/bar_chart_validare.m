% Functie care primeste drept parametru matricea de date
% pe care le valideaza in functie de coloana din care fac
% parte (valoare corecta sau NaN) si afiseaza rezultatul
% sub forma unui bar chart orizontal
    % data_table: tabelul de intrare
function bar_chart_validare(data_table)
    % se verifica daca parametrul este valid
    if ~istable(data_table)
        error('Inputul trebuie să fie un tabel.');
    end
    
    % se cauta info despre tipurile de coloane
    var_types = varfun(@class, data_table, 'OutputFormat', 'cell');
    column_names = data_table.Properties.VariableNames;

    bar_data = {};       % structura pentru stocarea datelor
    bar_labels = {};     % etichete pentru categorii
    bar_numbers = {};    % numatul de elemente de fiecare tip
    
    % se parcurge pe coloane
    for j = 1:width(data_table)
        col_data = data_table{:, j}; 
        
        % se verifica tipului de coloana inainte de a valida datele
        % acestora
        if isnumeric(col_data) || islogical(col_data) 
            is_valid = ~isnan(col_data);
            num_valid = sum(is_valid);
            num_nan = sum(~is_valid);
            
        elseif iscellstr(col_data) || isstring(col_data) 
            is_valid = ~(strcmp(col_data, '') | strcmpi(col_data, 'NaN'));
            num_valid = sum(is_valid);
            num_nan = sum(~is_valid);
        else
            warning('Tipul de date din coloana %s nu este suportat.', column_names{j});
            continue;
        end
        
        % se adauga datele in structurile aferente
        bar_data{end+1} = [num_valid, num_nan]; 
        bar_labels{end+1} = {[column_names{j} '- Valid - '], [column_names{j} '- NaN - ']};
        bar_numbers{end+1} = [num_valid, num_nan];
    end

    % se genereaza graficul
    figure;
    hold on;
    color_map = lines;
    y_pos_offset = 0; 
    max_value = 0;  

    for i = 1:length(bar_data)
        data = bar_data{i};
        labels = bar_labels{i};
        numbers = bar_numbers{i};
        
        y_pos = (1:length(data)) + y_pos_offset;
        
        b = barh(y_pos, data, 'FaceColor', color_map(mod(i-1, size(color_map, 1))+1, :), 'EdgeColor', 'none');
        
        max_value = max(max_value, max(data));
        
        for k = 1:length(data)
            text(max_value + 10, y_pos(k), sprintf('%s (%d)', labels{k}, numbers(k)), ...
                'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left');
        end
        
        y_pos_offset = y_pos_offset + length(data) + 1;
    end
    
    xlabel('Numarul de valori');
    ylabel('Numele coloanelor');
    title('Validarea datelor in functie de coloane');
    grid on;

    xlim([0, max_value + 50]);
    hold off;

end
