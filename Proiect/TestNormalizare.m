classdef TestNormalizare < matlab.unittest.TestCase
   methods (Test)
       function testNumericData(testCase)
           % Test pentru un set de date numeric
           data = table([1; 2; 3], [10; 20; 30], [100; 200; 300]);
           expected = [
               0.0, 0.0, 0.0;  % Prima linie normalizată
               0.5, 0.5, 0.5;  % A doua linie normalizată
               1.0, 1.0, 1.0   % A treia linie normalizată
           ];
           actual = normalizare(data);
           testCase.verifyEqual(actual, expected, 'AbsTol', 1e-10);
       end
       function testNonNumericData(testCase)
           % Test pentru un set de date cu valori non-numerice
           data = table([1; 2; 3], {'a'; 'b'; 'c'}, [true; false; true]);
           expected = [
               0.0, NaN, 1.0;  % Prima linie
               0.5, NaN, 0.0;  % A doua linie
               1.0, NaN, 1.0   % A treia linie
           ];
           actual = normalizare(data);
           testCase.verifyEqual(actual, expected, 'AbsTol', 1e-10);
end
       function testCompletelyNonNumeric(testCase)
           % Test pentru un set de date complet non-numeric
           data = table({'a'; 'b'; 'c'}, {'x'; 'y'; 'z'}, {'q'; 'w'; 'e'});
           expected = NaN(3, 3);
           actual = normalizare(data);
           testCase.verifyEqual(actual, expected);
       end
       function testEmptyTable(testCase)
           % Test pentru o tabelă goală
           data = table();
           expected = [];
           actual = normalizare(data);
           testCase.verifyEqual(actual, expected);
       end
   end
end
