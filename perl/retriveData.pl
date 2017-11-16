#!"C:\Strawberry\perl\bin\perl.exe"

use strict;
use warnings;
use CGI;
use DBI;
use JSON;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

my $header = { type => 'text/plain' };
print CGI::header( $header );

my $c = new CGI;

# retrives search string
my $search_content = $c->param('search_content');

# establishes database connection
my $myConnection = DBI->connect("DBI:mysql:database=appointmentdb;host=localhost;port=3306","root", "");

retriveData();
$myConnection->disconnect();


sub retriveData{
	my @result;
	my $fetchQuery;

	# query for retriving all data if empty string
	if(length($search_content)==0){
		$fetchQuery = ("SELECT * FROM appointments");
	}
	else {
		# query for retriving search string data only
		$fetchQuery = ("SELECT * FROM appointments WHERE description LIKE '%$search_content%';"); 
	}
	my $fetchStatement = $myConnection->prepare($fetchQuery);
	$fetchStatement->execute();
	
	my %myHash;

    # fetch data from database
	while(my @row = $fetchStatement->fetchrow_array){
		my $key = @row[0];
		my @vals = (@row[1],@row[2],@row[3]);	
		 foreach my $v (@vals){ 
		 	chomp($v);
		 	$myHash{$key} = "$myHash{$key}"."$v ";
		 }
	}

	# data as json object
	my $json_str = encode_json \%myHash;

	print "$json_str\n";
}



