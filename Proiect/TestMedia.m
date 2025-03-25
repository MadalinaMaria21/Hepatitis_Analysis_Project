classdef TestMedia < matlab.unittest.TestCase
   methods (Test)
       function testNumericData(testCase)
           % Test pentru un set de date numeric
           data = table([1; 2; 3], [4; 5; 6], [7; 8; 9]);
           expected = [2, 5, 8];
           actual = media(data);
           testCase.verifyEqual(actual, expected, 'AbsTol', 1e-10);
       end
       function testWithNaN(testCase)
           % Test pentru un set de date cu valori NaN
           data = table([NaN; 2; 3], [4; NaN; 6], [7; 8; NaN]);
           expected = [2.5, 5, 7.5];
           actual = media(data);
           testCase.verifyEqual(actual, expected, 'AbsTol', 1e-10);
       end
       function testCompletelyNonNumeric(testCase)
           % Test pentru un set de date complet non-numeric
           data = table({'a'; 'b'; 'c'}, {'x'; 'y'; 'z'}, {'q'; 'w'; 'e'});
           expected = [NaN, NaN, NaN];
           actual = media(data);
           testCase.verifyEqual(actual, expected);
       end
    end
end
