% Functie care primeste ca parametru un set de date si descrierea acestora
% cu care calculeaza si afiseaza o serie de caracteristici statice
  % data: tabelul de intrare
  % descriere: un string care descrie setul de date 
function afisare_statistici(data, descriere)
    % se calculeaza statisticile
    valMedie = media(data);
    valDispersie = dispersia(data);
    valMinim = minim(data); 
    valMaxim = maxim(data); 
    valDevStd = deviatia_standard(data);
    valModul = modul(data);
    valMediana = mediana(data);
    valNormalizare = normalizare(data);
    valStandardizare = standardizare(data);

    % se afiseaza statisticile
    disp(['Statistici pentru ', descriere, ':']);
    disp('Media:');
    disp(valMedie);
    disp('Dispersia:');
    disp(valDispersie);
    disp('Valorile minime:');
    disp(valMinim);
    disp('Valorile maxime:');
    disp(valMaxim);
    disp('Valorile deviatiei standard:');
    disp(valDevStd);
    disp('Valorile modulului:');
    disp(valModul);
    disp('Valorile medianei:');
    disp(valMediana);
    %disp('Valorile normalizate:');
    %disp(valNormalizare);
    %disp('Valorile standardizate:');
    %disp(valStandardizare);
    
    disp('--------------------------------------------------------');
end
