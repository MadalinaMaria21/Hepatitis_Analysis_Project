
classdef TestDeviatiaStandard < matlab.unittest.TestCase
   methods (Test)
      
       % Test pentru un set de date standard cu valori numerice
       function testStandardDeviation(testCase)
           % Set de date simplificat
           data = table([1, 2, 3]', [4, 5, 6]', [7, 8, 9]');
           expectedDeviation = [1.0000, 1.0000, 1.0000]; % Deviatia standard pentru fiecare coloana
          
           % Calcularea devierii standard folosind functia deviatia_standard
           result = deviatia_standard(data);
          
           % Verificam daca rezultatul calculat este cel asteptat
           testCase.verifyEqual(result, expectedDeviation, 'AbsTol', 1e-4);
       end
      
       % Test pentru un set de date in care toate valorile sunt egale
       function testZeroDeviation(testCase)
           % Set de date cu valori egale
           data = table([2, 2, 2]', [2, 2, 2]', [2, 2, 2]');
           expectedDeviation = [0, 0, 0]; % Deviatia standard este 0 pentru fiecare coloana
          
           % Calcularea devierii standard folosind functia deviatia_standard
           result = deviatia_standard(data);
          
           % Verificam daca rezultatul calculat este cel asteptat
           testCase.verifyEqual(result, expectedDeviation, 'AbsTol', 1e-4);
       end
      
       % Test pentru un set de date cu valori non-numerice
       function testNonNumericData(testCase)
           % Set de date cu coloane non-numerice
           data = table({'a', 'b', 'c'}', {'x', 'y', 'z'}', {'cat', 'dog', 'mouse'}');
           expectedDeviation = [NaN, NaN, NaN]; % Nu se poate calcula deviatie standard pentru datele non-numerice
          
           % Calcularea devierii standard folosind functia deviatia_standard
           result = deviatia_standard(data);
          
           % Verificam daca rezultatul este NaN pentru toate coloanele
           testCase.verifyEqual(result, expectedDeviation, 'AbsTol', 1e-4);
       end
   end
end