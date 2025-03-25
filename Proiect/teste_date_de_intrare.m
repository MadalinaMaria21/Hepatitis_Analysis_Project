clc; clear;

% Inițializare variabilă pentru stocarea rezultatelor
results = {};

% 1. Verificarea prezenței fișierului
fileName = 'HepatitisC-Cleared.csv';
if exist(fileName, 'file')
    results{end+1, 1} = 'SCENARIU 1: Fișierul există în proiect.';
    results{end, 2} = 'Test trecut';
else
    results{end+1, 1} = 'SCENARIU 1: Fișierul NU există în proiect.';
    results{end, 2} = 'Test eșuat';
    disp('Rezultate testare:');
  resultsTable = cell2table(results, 'VariableNames', {'Scenariu', 'Rezultat'});
    disp(resultsTable);

    % Creare fereastră figure pentru afișare tabel
    figure('Name', 'Rezultatele Testelor', 'NumberTitle', 'off');
    uitable('Data', results, 'ColumnName', {'Scenariu', 'Rezultat'}, ...
        'Position', [50, 400, 700, 200], 'ColumnWidth', {400, 150});
    return;
end

% 2. Verificarea extensiei fișierului
[~, ~, ext] = fileparts(fileName);
if strcmp(ext, '.csv')
    results{end+1, 1} = 'SCENARIU 2: Extensia fișierului este corectă (.csv).';
    results{end, 2} = 'Test trecut';
else
    results{end+1, 1} = 'SCENARIU 2: Extensia fișierului este incorectă.';
    results{end, 2} = 'Test eșuat';
end

% 3. Verificarea dacă fișierul este gol
data = readtable(fileName);
if isempty(data)
    results{end+1, 1} = 'SCENARIU 3: Fișierul este gol.';
    results{end, 2} = 'Test eșuat';
else
    results{end+1, 1} = 'SCENARIU 3: Fișierul conține date.';
    results{end, 2} = 'Test trecut';
end

% 4. Validarea valorilor din coloanele analizelor
analysisIntervals = {
    'ALB', [5, 70];    % Albumin (g/L)
    'ALP', [10, 2000]; % Alkaline phosphatase (U/L)
    'ALT', [0, 5000];  % Alanine aminotransferase (U/L)
    'AST', [0, 5000];  % Aspartate aminotransferase (U/L)
    'BIL', [0, 50];    % Bilirubin total (mg/dL)
    'CHE', [0, 25];    % Cholinesterase (kU/L)
    'CHOL', [0.5, 20]; % Cholesterol (mmol/L)
    'CREA', [5, 5000]; % Creatinine (umol/L)
    'GGT', [0, 5000];  % Gamma-glutamyl transferase (U/L)
    'PROT', [10, 150]  % Total protein (g/L)
};
% Iterăm prin fiecare analiză pentru validare
for i = 1:size(analysisIntervals, 1)
    colName = analysisIntervals{i, 1};
    interval = analysisIntervals{i, 2};
    if ismember(colName, data.Properties.VariableNames)
        invalidValues = sum(data.(colName) < interval(1) | data.(colName) > interval(2), 'omitnan');
        if invalidValues == 0
            results{end+1, 1} = sprintf('SCENARIU 4.%d: Toate valorile pentru %s sunt în intervalul medical posibil (%.1f-%.1f).', ...
                i, colName, interval(1), interval(2));
            results{end, 2} = 'Test trecut';
        else
            results{end+1, 1} = sprintf('SCENARIU 4.%d: %d valori pentru %s sunt în afara intervalului medical posibil (%.1f-%.1f).', ...
                i, invalidValues, colName, interval(1), interval(2));
            results{end, 2} = 'Test eșuat';
        end
    else
        results{end+1, 1} = sprintf('SCENARIU 4.%d: Coloana %s lipsește din date.', i, colName);
        results{end, 2} = 'Test eșuat';
    end
end

% 5. Verificarea valorilor lipsă
missingCounts = sum(ismissing(data), 1);
if any(missingCounts)
    results{end+1, 1} = 'SCENARIU 5: Există valori lipsă în date.';
    results{end, 2} = 'Test eșuat';
else
    results{end+1, 1} = 'SCENARIU 5: Nu există valori lipsă în date.';
    results{end, 2} = 'Test trecut';
end

% Creare fereastră pentru tabel și grafic
f = figure('Name', 'Rezultatele Testelor', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);

numRows = size(results, 1);
rowHeight = 20;
tableHeight = numRows * rowHeight;

uitable('Data', results, 'ColumnName', {'Scenariu', 'Rezultat'}, ...
        'Position', [50, 600 - tableHeight - 50, 700, tableHeight], 'ColumnWidth', {500, 150});

axes('Position', [0.1, 0.1, 0.8, 0.3]);
bar(categorical(data.Properties.VariableNames), missingCounts);
title('Număr de valori lipsă pe coloană');
xlabel('Coloane dataset');
ylabel('Număr de valori lipsă');
grid on;


