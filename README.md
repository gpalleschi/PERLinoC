# PERLinoC
A simple PERL utility to convert value in differents formats.  


Use: PERLinoC.pl \<Type Conv\> \<Value To Conv\>  

\<Type Conv\>     : Conversion Type to apply, values permitted are :  

    -hd : Hex to Decimal 
    -dh : Decimal to Hex
    -ah : Ascii to Hex
    -ha : Hex to Ascii
    -bh : Binary to Hex
    -hb : Hex to Binary
    -bd : Binary to Decimal
    -db : Decimal to Binary  
    -rd : Roman to Decimal
    -dr : Decimal to Roman  
  
\<Value To Conv\> : Value to Convert
  
Examples :  

    1) PERLinoC.pl -hd a0ef  

                Hex 'a0ef' ---> Dec '-24337'  

    2) PERLinoC.pl -dh 250   

                Dec '250' ---> Hex 'fa'  
