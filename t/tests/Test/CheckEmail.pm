#********************************************************#
#                                                        #
# Start test   prove -lv t/run.t :: --tvar=FILENAME_THIS #
#                                                        #
#********************************************************#
    package Test::CheckEmail;
    use Test::Most tests => 8;
    use base 'Test::Class';
    use Getopt::Long;
    
    sub class { 'CheckEmail' };
    
    my $input;
    
    sub args: Tests(1) {  
         GetOptions( "tvar=s" => \$input );
             
         ok  $input, "$input - File exist";
     };

    sub startup : Tests(startup => 1) {
         my $test = shift;
      
         use_ok $test->class;
     };

    sub constructor : Tests(3) {
         my $test  = shift;
         my $class = $test->class;
      
         can_ok $class, 'new';
         ok my $ch_email = $class->new( file => $input ),
             "... and the constructor should succeed";
         isa_ok $ch_email, $class, '... and the object it returns';
    };


    sub validate_mx_domain_name : Test(3) {
          my $test  = shift;

          ok my $class = $test->class->new( file => $input ),
            ".......create object";
          ok $class->validate_mx_domain_name,'...... check method validate_mx_domain_name'; 
          explain '---------------------------------------------';
          throws_ok { $class->show_result } qr/\.*/, '...... check method show_result return validation result';
          explain '---------------------------------------------';
    };
     

    
    1;
