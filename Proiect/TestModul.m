classdef TestModul < matlab.unittest.TestCase
   methods (Test)
       function testNumericData(testCase)
           % Test pentru un set de date numeric
           data = table([1; 2; 2], [4; 4; 6], [7; 8; 9]);
           expected = [2, 4, 7]; % Modulul pentru fiecare coloană
           actual = modul(data);
           testCase.verifyEqual(actual, expected, 'AbsTol', 1e-10);
       end
       function testWithNaN(testCase)
           % Test pentru un set de date cu valori NaN
           data = table([NaN; 2; 2], [4; NaN; 4], [7; 8; NaN]);
           expected = [2, 4, 7];
           actual = modul(data);
           testCase.verifyEqual(actual, expected, 'AbsTol', 1e-10);
       end
       function testNonNumericData(testCase)
           % Test pentru un set de date cu valori non-numerice
           data = table([1; 2; 2], {'a'; 'b'; 'b'}, [true; false; true]);
           expected = [2, NaN, 1]; % Modulul numeric și NaN pentru non-numeric
           actual = modul(data);
           testCase.verifyEqual(actual, expected, 'AbsTol', 1e-10);
       end
       function testCompletelyNonNumeric(testCase)
           % Test pentru un set de date complet non-numeric
           data = table({'a'; 'b'; 'c'}, {'x'; 'y'; 'z'}, {'q'; 'w'; 'e'});
           expected = [NaN, NaN, NaN];
           actual = modul(data);
           testCase.verifyEqual(actual, expected);
       end
       function testUniformData(testCase)
           % Test pentru o coloană cu date uniforme
           data = table([1; 1; 1], [4; 4; 4], [NaN; NaN; NaN]);
           expected = [1, 4, NaN];
           actual = modul(data);
           testCase.verifyEqual(actual, expected, 'AbsTol', 1e-10);
       end
   end
end