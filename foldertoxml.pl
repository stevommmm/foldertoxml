#!C:\Perl64\bin\perl.exe
# Folder to XML
# Usage: perl foldertoxml.pl
# Prints a list of all files in the current directory and all subdirectories to a .xml file
# Checks for a style.css to apply styling to the xml file (can be overwritten)
# Links files to the xml output.
# 
# Stephen McGregor [stevommmm]
open (XML, '> files.xml');
print XML "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n";
print XML "<?xml-stylesheet type=\"text/css\" href=\"style.css\"?>\n";
print XML "<DIRECTORY xmlns:xhtml=\"http://www.w3.org/1999/xhtml\">\n";
print XML "<HEAD>DIRECTORY LISTING</HEAD>\n";
process_files (".");
print XML "</DIRECTORY>\n";
close (XML); 

if (!-e "style.css") {
open (CSS, '> style.css');
 print CSS "DIRECTORY { background-color: #ffffff; margin:0 auto;	width:700px; padding-top:20px; }
HEAD { color: gray; font-size: 16pt; text-align:center; padding:250px; }
FILE { display: block; margin-bottom: 3pt; margin-left: 0; border-bottom:thin lightgray dashed; }
FILENAME { color: gray; font-size: 16pt; }
FILENAME a { color: gray; font-size: 16pt; text-decoration:none; }
FILESIZE { color: dimgray; font-size: 12pt; float:right; }
FILESIZE:after { content:\" bytes\"; color:lightgray; }";
close (CSS); 
 } 

sub process_files {
    my $path = shift;
    opendir (DIR, $path)
        or die "Unable to open $path: $!";
    my @files = grep { !/^\.{1,2}$/ } readdir (DIR);
    closedir (DIR);
    @files = map { $path . '/' . $_ } @files;
    for (@files) {
        if (-d $_) {
            process_files ($_);
        } else { 
			if ((!/\/files.xml/) && (!/\/style.css/) && (!/\/foldertoxml.pl/)){
				print XML "<FILE>\n";
				print XML "<FILENAME><xhtml:a href=\"$_\">$_</xhtml:a></FILENAME>\n";
				my $filesize = -s $_;
				print XML "<FILESIZE>$filesize</FILESIZE>\n";
				print XML "</FILE>\n";
			}
        }
    }
}

