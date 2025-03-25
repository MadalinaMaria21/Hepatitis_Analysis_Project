classdef TestDispersia < matlab.unittest.TestCase
   methods (Test)
      
       % Test pentru un set de date standard cu valori numerice
       function testDispersia(testCase)
           % Set de date simplificat
           data = table([1, 2, 3]', [4, 5, 6]', [7, 8, 9]');
           expectedDispersie = [1.0000, 1.0000, 1.0000]; % Dispersia pentru fiecare coloana
          
           % Calcularea dispersiei folosind functia dispersia
           result = dispersia(data);
          
           % Verificam daca rezultatul calculat este cel asteptat
           testCase.verifyEqual(result, expectedDispersie, 'AbsTol', 1e-4);
       end
      
       % Test pentru un set de date cu valori egale (dispersia ar trebui sa fie 0)
       function testZeroDispersie(testCase)
           % Set de date cu valori egale
           data = table([2, 2, 2]', [2, 2, 2]', [2, 2, 2]');
           expectedDispersie = [0, 0, 0]; % Dispersia va fi 0 pentru fiecare coloana
          
           % Calcularea dispersiei folosind functia dispersia
           result = dispersia(data);
          
           % Verificam daca rezultatul calculat este cel asteptat
           testCase.verifyEqual(result, expectedDispersie, 'AbsTol', 1e-4);
       end
      
       % Test pentru un set de date cu valori non-numerice
       function testNonNumericData(testCase)
           % Set de date cu coloane non-numerice
           data = table({'a', 'b', 'c'}', {'x', 'y', 'z'}', {'cat', 'dog', 'mouse'}');
           expectedDispersie = [NaN, NaN, NaN]; % Nu se poate calcula dispersia pentru datele non-numerice
          
           % Calcularea dispersiei folosind functia dispersia
           result = dispersia(data);
          
           % Verificam daca rezultatul este NaN pentru toate coloanele
           testCase.verifyEqual(result, expectedDispersie, 'AbsTol', 1e-4);
       end
   end
end