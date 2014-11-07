#!/usr/bin/env perl 

    package CheckEmail;
    use Moose; 
    use MooseX::Types::Path::Class qw( File );
    use MooseX::Privacy;
    use Net::DNS;
    use URI::UTF8::Punycode  qw( puny_enc );
    use Text::Trim qw( trim );
    use feature qw(say);
   
    #**** Create object *************# 
    
    has 'file' => (
             is       => 'rw',
             isa      => 'Path::Class::File',
             required => 1, 
             coerce   => 1,
    );

    # Easy validation string from file will be add to hash #
    
    has 'option' => (
            traits    => ['Hash'],
            is        => 'ro',
            isa       => 'HashRef[Str]',
            default   => sub { {} },
    );

    #---- Domain names from file will be add to hash --#
    
    has 'domain' => (
            traits    => ['Hash'],
            is        => 'ro',
            isa       => 'HashRef[Str]',
            default   => sub { {} },
    );

    #------------- Hash for INVALID doamins -----------#
      
    has 'invalid_domain' => (
            traits    => ['Hash'],
            is        => 'rw',
            isa       => 'HashRef[Str]',
            default   => sub { {} },
    );
   
    #------------ Hash for VALID domains --------------#
   
    has 'valid_domain' => (
            traits    => ['Hash'],
            is        => 'rw',
            isa       => 'HashRef[Str]',
            default   => sub { {} },
    );  
   
    #--------- Count domains --------------------------#
   
    has 'count_domain' => (
            traits    => ['Hash'],
            is        => 'rw',
            isa       => 'HashRef[Str]',
            default   => sub { {} },
    ); 
    

    
    #**** Validation file exist and add data to hash ***********#
    
    sub BUILD {
        my $self = shift;
        my $f = $self->file; 
        
         unless( -e $f ) { 
             die "File $f not exist. I wait ./test_email.pl YOUFILENAME.txt \n";
         } 
         else {
                 #****** Read file to hash and easy validation ***********#
                 # 
                 my $fh = $f->openr;
                 my $i = 1; 
                     while ( my $line = <$fh> ){
                              # Add all data for hash
                              $self->option->{ "$i" } = "$line";
                                 if( !( $line =~ m/@/ ) ) {
                                         #** String which does not have ( @ ) is INVALID **#
                                         $self->invalid_domain->{ "$i" } = "$line";
                                 }    
                                 else {                          
                                         my $s_index =   index( $line, '@' );  
                                         my $s_rindex = rindex( $line, '@' );
  
                                         if ( $s_index == $s_rindex ) {  
                                                my @b_domains = split( /@/,$line );
                                                $self->domain->{ "$i" } = "$b_domains[1]";            
                                         }
                                         else {
                                                $self->invalid_domain->{ "$i" } = "$line";
                                         }  
                                }                        
                          $i++;
                   }                         
       }        
    };    
      
    # Validate email. In this code I will assume what if doman name have mx this name is valid #         
   
    sub validate_mx_domain_name {
            my $self = shift;
       
            my $size = keys( $self->domain );
            if ( $size > 0 ) {
                   
                   foreach my $key ( keys $self->domain ) {         
                            my $k = $key; my $v = $self->domain->{ $key }; 
                            $self->validate( $k, $v );
                   }
                   return 1;    
             } else {
				   return 0; 
		     }		 
    };


    # Validate string and return values to invalid_domain #
    private_method validate => sub {
          my ( $self, $k, $v ) = @_; 
          trim($v); my $mx;    

           if( $v =~ m/[а-яА-ЯёЁ]/ ) {                         
                  my $r = URI::UTF8::Punycode::puny_enc($v);       
                  $mx = mx_check($r);
                  if ( $mx == 1 ) {
					      $self->valid_domain->{ "$k" }   =  $v; 
				   } else {	
					      $self->invalid_domain->{ "$k" } =  $v;
				   } 		  
           } else {    
                  $mx = mx_check($v);
                  if ( $mx == 1 ) {
					      $self->valid_domain->{ "$k" }   =  $v; 
				   } else {	
					      $self->invalid_domain->{ "$k" } =  $v;
				   } 
           }
    };
    
    #**** check mx for domain ***********#
    
    private_method mx_check => sub {
		  my ( $v ) = @_;
		  
		  my $res = Net::DNS::Resolver->new; 
		  my @mx = mx($res, "$v");
             if (@mx) {
                         return 1;
               } else {
                         return 0;
               }
		
    };		
		
    # Counst domains
    sub show_result {
            my $self = shift;
            my $i;
    
            foreach my $key ( keys $self->valid_domain ) {
			    
			       my $val = $self->valid_domain->{ $key };	
				      if( exists $self->count_domain->{ $val } ) {
						   $i = $self->count_domain->{ $val };
						   my $count = ++$i;
						   $self->count_domain->{ $val } = $count; 
				       } else {
				           $self->count_domain->{ $val } = 1; 
				       }
            }
    };
   		
    # Show result #		
	after 'show_result' => sub {	
	       my $self = shift;
	       say '';
	       foreach my $key ( keys $self->count_domain ) {  
	      
	            my $val = $self->count_domain->{ $key };
	            say "$key \t $val";
	       
	       }
	       my $size = keys( $self->invalid_domain );
	       say "INVALID $size"; 
	       say '';
    };
	
	
    __PACKAGE__->meta->make_immutable;   
    
    no Moose; 
    
