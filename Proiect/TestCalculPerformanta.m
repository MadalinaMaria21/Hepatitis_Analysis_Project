classdef TestCalculPerformanta < matlab.unittest.TestCase
   methods (Test)
       function testEmptyConfMatrix(testCase)
           % Test pentru o matrice de confuzie goală
           confMatrix = zeros(3, 3);
           [precision, recall, f1score] = calcul_performanta(confMatrix);
          
           % Toate valorile trebuie să fie 0, deoarece nu există predicții corecte
           testCase.verifyEqual(precision, [0; 0; 0], 'AbsTol', 1e-4);
           testCase.verifyEqual(recall, [0; 0; 0], 'AbsTol', 1e-4);
           testCase.verifyEqual(f1score, [0; 0; 0], 'AbsTol', 1e-4);
       end
       function testSingleClassConfMatrix(testCase)
           % Test pentru o matrice de confuzie cu o singura clasă
           confMatrix = [50, 0, 0; 0, 0, 0; 0, 0, 0];
           [precision, recall, f1score] = calcul_performanta(confMatrix);
          
           % Precizia și recall-ul vor fi 1 pentru singura clasă prezentă
           testCase.verifyEqual(precision, [1; 0; 0], 'AbsTol', 1e-4);
           testCase.verifyEqual(recall, [1; 0; 0], 'AbsTol', 1e-4);
           testCase.verifyEqual(f1score, [1; 0; 0], 'AbsTol', 1e-4);
       end
   end
end