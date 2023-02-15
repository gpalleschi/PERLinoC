#!/usr/bin/perl -w

use bigint;

#
# GPSoft - Giovanni Palleschi - 2020-2022 PERLinoC.pl Simple Utility to conversion Hex to Dec, Dec to Hex, Ascii to Hex, Hex to Ascii, Bin to Hex and Hex to Bin, roman numero to decimal, decimal to roman number
#
# perl PERLinoC.pl [options]
#
# [...] opcional
#
# This script perl return conversion requiered.
#
# Tested on Perl version 5.26
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#Start Declarative 
@RN = ("I","IV","V","IX","X","XL","L","XC","C","CD","D","CM","M");
@VRN = (1,4,5,9,10,40,50,90,100,400,500,900,1000);
$TOTRN = 12;

sub decimalToRoman {
    my ($number) = @_;
    $ind = $TOTRN;
    $retRN = "";

    while ( $number > 0 ) {
      $div = int($number/$VRN[$ind]);
      $number = $number%$VRN[$ind];
      while ( $div ) {
	$retRN = $retRN . $RN[$ind];
	$div = $div - 1;
      }
      $ind = $ind - 1;
    }

    return $retRN;
}


sub romanToDecimal {
    my ($cpRN) = @_;

    $lenRN = length($cpRN);
    $retDEC = 0;

    for ( $ind=0; $ind < $lenRN; $ind++ ) {
#      printf("\n %d : %s \n", $ind, substr($cpRN, $ind, 1));
      if ( substr($cpRN, $ind, 1) eq 'I' ) {
        $retDEC = $retDEC + 1;
      }
      if ( substr($cpRN, $ind, 1) eq 'V' ) { 
        $retDEC = $retDEC + 5;
      }
      if ( substr($cpRN, $ind, 1) eq 'X' ) { 
        $retDEC = $retDEC + 10;
      }
      if ( substr($cpRN, $ind, 1) eq 'L' ) { 
        $retDEC = $retDEC + 50;
      }
      if ( substr($cpRN, $ind, 1) eq 'C' ) { 
        $retDEC = $retDEC + 100;
      }
      if ( substr($cpRN, $ind, 1) eq 'D' ) { 
        $retDEC = $retDEC + 500;
      }
      if ( substr($cpRN, $ind, 1) eq 'M' ) { 
        $retDEC = $retDEC + 1000;
      }

      if ( $ind > 0 ) {

         if ( (( substr($cpRN, $ind, 1) eq 'V') or ( substr($cpRN, $ind, 1) eq 'X')) && ( substr($cpRN, $ind-1, 1) eq 'I') ) {
            $retDEC -= 1 + 1;
         }

         if ( (( substr($cpRN, $ind, 1) eq 'L') or ( substr($cpRN, $ind, 1) eq 'C')) && ( substr($cpRN, $ind-1, 1) eq 'X') ) {
            $retDEC -= 10 + 10;
         }

         if ( (( substr($cpRN, $ind, 1) eq 'D') or ( substr($cpRN, $ind, 1) eq 'M')) && ( substr($cpRN, $ind-1, 1) eq 'C') ) {
            $retDEC -= 100 + 100;
         }
      }

    } 

    return $retDEC;
}

# Start Function to convert values
sub dataConvert {
  my ($hexvalue, $type) = @_;
  $valueConv = $hexvalue;

# Hex to Ascii
  if ( $type eq 'A' ) {
     $valueConv = pack("H*", $hexvalue);
  }
# Hex to Binary
  elsif ( $type eq 'B' ) {
     $valueConv = unpack("B*", pack("H*", $hexvalue));
  }
# Hex to Number
  elsif ( $type eq 'N' ) {
     #Check if number is Negative or Positive
     $valueConv = unpack("B*", pack("H*", $hexvalue));
     $signBit = substr($valueConv, 0, 1);
     #if 0 is positive
     if ( $signBit eq '0' ) {
        $valueConv = hex $hexvalue;
     } else {
     #if 1 is negative
       my $diff = hex($hexvalue) - hex(1);
       $hexvalue = sprintf "%x", $diff;
       $valueConv = unpack("B*", pack("H*", $hexvalue));
       $valueCompl2 = "";
       for($iInd=0;$iInd<length($valueConv);$iInd++) {
         if ( substr($valueConv, $iInd, 1) eq '0' ) {
            $valueCompl2 = $valueCompl2 . "1";
         } else {
            $valueCompl2 = $valueCompl2 . "0";
         }
       }      
       $decimal_number = oct("0b".$valueCompl2);
       $valueConv = "-" . $decimal_number;
     }   
  }
# Hex 
  elsif ( $type eq 'H' ) {
     $valueConv = $hexvalue;
  }
# Binary To Decimal
  elsif ( $type eq 'D' ) {
     $valueDec=0;
     $indExp=0;
     # hexvalue in this case is in binary format
     for($iInd=length($hexvalue)-1;$iInd>=0 ;$iInd--) {
           if ( substr($hexvalue, $iInd, 1) eq '1' ) {
             $valueDec+=2**$indExp; 
           } 
           $indExp++;
     }           
     $valueConv = sprintf "%lu", $valueDec;
  }   
  return $valueConv;
}

# End Function to convert hex value 
sub help {
    print "\n\n";
    print " ____  _____ ____  _     _              ____\n";
    print "|  _  | ____|  _ \\| |   (_)_ __   ___  / ___|\n";
    print "| |_) |  _| | |_) | |   | | '_ \\ / _ \\| |\n";
    print "|  __/| |___|  _ <| |___| | | | | (_) | |___\n";
    print "|_|   |_____|_| \\_\\_____|_|_| |_|\\___/ \\____|\n";
    print "\n\nPERLinoC.pl version $Version\n\n";
    print "Use: PERLinoC.pl <Type Conv> <Value To Conv>\n\n";
    print "[...] are optional parameters\n\n";
    print "<Type Conv>     : Conversion Type to apply, values permitted are : \n\n";
    print "                  -hd : Hex to Decimal\n";
    print "                  -dh : Decimal to Hex\n";
    print "                  -ah : Ascii to Hex\n";
    print "                  -ha : Hex to Ascii\n";
    print "                  -bh : Binary to Hex\n";
    print "                  -hb : Hex to Binary\n";
    print "                  -bd : Binary to Decimal\n";
    print "                  -db : Decimal to Binary\n";
    print "                  -rd : Roman to Decimal\n";
    print "                  -dr : Decimal to Roman\n\n";
    print "<Value To Conv> : Value to Convert\n\n";
    print "Examples : \n\n";
    print "\tPERLinoC.pl -hd a0ef\n\n";
    print "\t\t\tHex 'a0ef' ---> Dec '-24337'\n\n";
    print "\tPERLinoC.pl -dh 250\n\n";
    print "\t\t\tDec '250' ---> Hex 'fa'\n\n\n";
}
# Start Prg

# Variable Convertions
my %hash = ();

$flagHexDec=0;
$flagDecHex=0;
$flagAsciiHex=0;
$flagHexAscii=0;
$flagBinHex=0;
$flagHexBin=0;
$flagDecBin=0;
$flagBinDec=0;
$flagRomDec=0;
$flagDecRom=0;
$flagValue=0;
$value="";
$Version="1.5 15/02/2023";

#End Declarative 

if ($#ARGV ne 1 ) {
	help();
	exit 0;
}

# Hex to Decimal 
if ( substr($ARGV[0],0,3) eq "-hd" ) {
   $flagHexDec=1;
}
 # Decimal to Hex 
elsif ( substr($ARGV[0],0,3) eq "-dh" ) {
   $flagDecHex=1;
}
# Ascii to Hex 
elsif ( substr($ARGV[0],0,3) eq "-ah" ) {
   $flagAsciiHex=1;
}
# Hex to Ascii
elsif ( substr($ARGV[0],0,3) eq "-ha" ) {
   $flagHexAscii=1;
}
# Binary to Hex 
elsif ( substr($ARGV[0],0,3) eq "-bh" ) {
   $flagBinHex=1;
}
# Hex to Binary 
elsif ( substr($ARGV[0],0,3) eq "-hb" ) {
   $flagHexBin=1;
}
# Binary to Decimal
elsif ( substr($ARGV[0],0,3) eq "-bd" ) {
   $flagBinDec=1;
}
# Decimal to Binary 
elsif ( substr($ARGV[0],0,3) eq "-db" ) {
   $flagDecBin=1;
}
elsif ( substr($ARGV[0],0,3) eq "-rd" ) {
   $flagRomDec=1;
}
elsif ( substr($ARGV[0],0,3) eq "-dr" ) {
   $flagDecRom=1;
}
else {
   printf("\n\n ### ERROR ### Specified a convertion parameter '$ARGV[0]' not permitted.\n\n\n");
   exit 1;
}
$value = $ARGV[1];

$total = $flagHexDec + $flagDecHex + $flagAsciiHex + $flagHexAscii + $flagBinHex + $flagHexBin + $flagValue + $flagDecBin + $flagBinDec + $flagDecRom + $flagRomDec;
if ( $total eq 0 ) {
   printf("\n\n ### ERROR ### Not Specified conversation parameters.\n\n\n");
   exit 1;
}

if ( $total > 1 ) {
   printf("\n\n ### ERROR ### Specified Too much conversations.\n\n\n");
   exit 1;
}

if ( ($flagHexAscii eq 1 || $flagHexBin eq 1 || $flagHexDec eq 1) && length($value)%2 != 0 ) {
   printf("\n ### ERROR ### Value specified in hexadecimal format have an odd number of digits.\n\n\n");
   exit 1;
}

#CONTROLS
for($iInd=0;$iInd<length($value);$iInd++) {
  if ( (ord(substr($value, $iInd, 1)) < 48 || ord(substr($value, $iInd, 1)) > 57) ) {
     if ( $flagDecHex eq 1 || $flagDecBin eq 1 || $flagDecRom eq 1 ) {
        if ( (ord(substr($value, $iInd, 1)) != 45 && ord(substr($value, $iInd, 1)) != 43) ) {
           printf("\n ### ERROR ### Value specified to translate not in decimal format.\n\n\n");
           exit 1;
        }
     }
     if ( (ord(substr($value, $iInd, 1)) < 97 || ord(substr($value, $iInd, 1)) > 102) &&
          (ord(substr($value, $iInd, 1)) < 65 || ord(substr($value, $iInd, 1)) > 70) && 
          ($flagHexAscii eq 1 || $flagHexBin eq 1 || $flagHexDec eq 1) ) {
        printf("\n ### ERROR ### Value specified to translate not in hex format.\n\n\n");
        exit 1;
     }
     if ( ord(substr($value, $iInd, 1)) != 73 && ord(substr($value, $iInd, 1)) != 86 &&
          ord(substr($value, $iInd, 1)) != 88 && ord(substr($value, $iInd, 1)) != 76 &&
          ord(substr($value, $iInd, 1)) != 67 && ord(substr($value, $iInd, 1)) != 68 &&
          ord(substr($value, $iInd, 1)) != 77 && $flagRomDec eq 1 ) {
        printf("\n ### ERROR ### Value specified to translate not in roman format values acepted are (I,V,X,L,C,D,M).\n\n\n");
        exit 1;
     }
  }
  if ( (ord(substr($value, $iInd, 1)) < 48 || ord(substr($value, $iInd, 1)) > 49 ) && 
       ( $flagBinHex eq 1 || $flagBinDec eq 1 ) ) {
     printf("\n ### ERROR ### Value specified to translate not in binary format.\n\n\n");
     exit 1;
  }
}   

#Hex to Decimal
if ( $flagHexDec eq 1 ) {
    $datoConvToDisplay = dataConvert($value,'N');
    printf("\n\n Hex '%s' ---> Dec '%s'\n\n\n", $value, $datoConvToDisplay);
    exit 0 ;
}

#Decimal to Hex 
if ( $flagDecHex eq 1 ) {
    printf("\n\n Dec '%s' ---> Hex '%x'\n\n\n", $value, $value);
    exit 0 ;
}

#Hex to Ascii
if ( $flagHexAscii eq 1 ) {
    $datoConvToDisplay = dataConvert($value,'A');
    printf("\n\n Hex '%s' ---> Ascii '%s'\n\n\n", $value, $datoConvToDisplay);
    exit 0 ;
}

#Ascii to Hex
if ( $flagAsciiHex eq 1 ) {
    printf("\n\n Ascii '%s' ---> Hex '%s'\n\n\n", $value,unpack('H*', "$value"));
}

#Hex to Binary
if ( $flagHexBin eq 1 ) {
    $datoConvToDisplay = dataConvert($value,'B');
    printf("\n\n Hex '%s' ---> Binary '%s'\n\n\n", $value, $datoConvToDisplay);
    exit 0 ;
}

#Binary to Hex
if ( $flagBinHex eq 1 ) {
    $datoConvToDisplay = dataConvert($value,'D');
    printf("\n\n Binary '%s' ---> Hex '%x'\n\n\n", $value, $datoConvToDisplay);
    exit 0 ;
}

#Binary to Decimal
if ( $flagBinDec eq 1 ) {
    $datoConvToDisplay = dataConvert($value,'D');
    printf("\n\n Binary '%s' ---> Decimal '%s'\n\n\n", $value, $datoConvToDisplay);
    exit 0 ;
}

#Decimal to Binary
if ( $flagDecBin eq 1 ) {
    $hexvalue = sprintf "%x", $value;
    $size = length $hexvalue;
    if ( $size%2 ) {
      $hexvalue = "0" . $hexvalue;
    }
    $datoConvToDisplay = dataConvert($hexvalue,'B');
    printf("\n\n Decimal '%s' ---> Binary '%s'\n\n\n", $value, $datoConvToDisplay);
    exit 0 ;
}

#Decimal to Roman
if ( $flagDecRom eq 1 ) {
    $datoConvToDisplay = decimalToRoman($value);
    printf("\n\n Decimal '%s' ---> Roman '%s'\n\n\n", $value, $datoConvToDisplay);
    exit 0 ;
}

#Roman to Decimal
if ( $flagRomDec eq 1 ) {
    $datoConvToDisplay = romanToDecimal($value);
    printf("\n\n Roman '%s' ---> Decimal '%d'\n\n\n", $value, $datoConvToDisplay);
    exit 0 ;
}
