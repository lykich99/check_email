check_email
=====================================================

   Example.Validation of emails existing in file. One email one string. Use Moose and test for Test::Class.

====================================================

   I used next modules.

----------------------------------------------------
    use Moose; 
    use MooseX::Types::Path::Class qw( File );
    use MooseX::Privacy;
    use Net::DNS;
    use URI::UTF8::Punycode  qw( puny_enc );
    use Text::Trim qw( trim );
----------------------------------------------------
Example result. 

$ ./test_email.pl email_valid.txt 

xn--d1acpjx3f.xn--p1ai 	 1<br>
rambler.ru 	 2<br>
mail.ru 	 2<br>
INVALID 9<br>


*****************************************************
  Comand Line Arguments
----------------------
   Example: ./test_email.pl email_valid.txt
 
   You can start ./test_email.pl YOUFILENAME
 
 
-------------------------------
  Comand Line Argument for test 
-------------------------------
 
   Example: prove -lv t/run.t :: --tvar=email_valid.txt
 
   You can start test change email_valid.txt for YOUFILENAME
   
   
-------------------------------   
          YOUFILENAME
-------------------------------          
   A. Format file string ( email ), one string one email.


--------------------------------
        About CheckEmail.pm
-------------------------------- 

    A. Create object CheckEmail->new( file => $file );
       $file = YOUFILENAME
       Read data from file and add to hash ( option, invalid_domain ).
   
    B. Methods CheckEmail.pm     
       1. validate_mx_domain_name - validate email and add data for hash( invalid_domain, valid_domain ).
       2. show_result - print validation result for STDOUT.


