----------------------
Comand Line Arguments
----------------------
   Example: ./test_email.pl email_valid.txt
 
   You cant start ./test_email.pl YOUFILENAME
 
 
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
       
       
       
