classdef TestMaxim < matlab.unittest.TestCase
   methods (Test)
       function testNumericData(testCase)
           % Test pentru un set de date numeric
           data = table([1; 2; 3], [4; 5; 6], [7; 8; 9]);
           expected = [3, 6, 9];
           actual = maxim(data);
           testCase.verifyEqual(actual, expected);
       end
       function testWithNaN(testCase)
           % Test pentru un set de date cu valori NaN
           data = table([NaN; 2; 3], [4; NaN; 6], [7; 8; NaN]);
           expected = [3, 6, 8];
           actual = maxim(data);
           testCase.verifyEqual(actual, expected);
       end
       function testNonNumericData(testCase)
           % Test pentru un set de date cu valori non-numerice
           data = table([1; 2; 3], {'a'; 'b'; 'c'}, [true; false; true]);
           expected = [3, NaN, 1];
           actual = maxim(data);
           testCase.verifyEqual(actual, expected);
       end
       function testCompletelyNonNumeric(testCase)
           % Test pentru un set de date complet non-numeric
           data = table({'a'; 'b'; 'c'}, {'x'; 'y'; 'z'}, {'q'; 'w'; 'e'});
           expected = [NaN, NaN, NaN];
           actual = maxim(data);
           testCase.verifyEqual(actual, expected);
       end
   end
end