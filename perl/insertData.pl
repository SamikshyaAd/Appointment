#!"C:\Strawberry\perl\bin\perl.exe"

use strict;
use warnings;
use CGI;
use DBI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

my $header = { type => 'text/plain' };
print CGI::header( $header );

my $c = new CGI;

# retrives data from form
my $date = $c->param('date');
my $time = $c->param('time');
my $descField = $c->param('descField');

# establishes database connection
my $myConnection = DBI->connect("DBI:mysql:database=appointmentdb;host=localhost;port=3306","root", "");

createTable();
insertData();
$myConnection->disconnect();

# creates table if not exists
sub createTable{
	my $sql = <<'END_SQL';
CREATE TABLE IF NOT EXISTS appointments (
			id INTEGER AUTO_INCREMENT PRIMARY KEY,
 			date DATE,  
			time VARCHAR(255), 
			description VARCHAR(255)
			)
END_SQL
$myConnection->do($sql);

}

# inserts data into table
sub insertData{
	$myConnection->do('INSERT INTO appointments (date, time, description) VALUES (?, ?, ?)',
  undef,
  $date, $time, $descField);

}



 










