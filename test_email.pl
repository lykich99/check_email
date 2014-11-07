#!/usr/bin/env perl 
  
    use strict;
    use warnings;
    use utf8;  
    use lib::CheckEmail;
    use 5.010;
     
    my ( $file )  = @ARGV;   
       if ( not defined $file ){ die "I wait ./test_email.pl YOUFILENAME.txt \n"; }

    my $app = CheckEmail->new( file => $file );     

    $app->validate_mx_domain_name;
    $app->show_result;
 
    #warn $app->dump;






