classdef TestStandardizare < matlab.unittest.TestCase
   methods (Test)
       function testNumericData(testCase)
           % Test pentru un set de date numeric
           data = table([1; 2; 3], [10; 20; 30], [100; 200; 300]);
           expected = [
               -1.0, -1.0, -1.0;  % Standardizare prima linie
                0.0,  0.0,  0.0;  % Standardizare a doua linie
                1.0,  1.0,  1.0   % Standardizare a treia linie
           ];
           actual = standardizare(data);
           testCase.verifyEqual(actual, expected, 'AbsTol', 1e-10);
       end
       function testCompletelyNonNumeric(testCase)
           % Test pentru un set de date complet non-numeric
           data = table({'a'; 'b'; 'c'}, {'x'; 'y'; 'z'}, {'q'; 'w'; 'e'});
           expected = NaN(3, 3);
           actual = standardizare(data);
           testCase.verifyEqual(actual, expected);
       end
       function testEmptyTable(testCase)
           % Test pentru o tabelă goală
           data = table();
           expected = [];
           actual = standardizare(data);
           testCase.verifyEqual(actual, expected);
       end
   end
end