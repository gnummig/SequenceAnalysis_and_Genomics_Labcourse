#!/usr/bin/perl

=head
# USAGE:
#        perl change_fasta_headers.pl > MY_NEW_FASTA_FILE.fasta

=cut


use strict;
use warnings;


open FASTA, $ARGV[0] or die "CANNOt open the FASTA file\n";
my @fasta = ();
@fasta = <FASTA>;
close FASTA;

# my_taxa_blast_info.txt
# my_taxa_blast_info.table_final.txt
open HEADERS, $ARGV[1] or die "CANNOT open my NEW FASTA HEADERS file\n";
my @headers = ();
@headers = <HEADERS>;
close HEADERS;


my %get_new_header_names = ();
my %fasta_join_lines     = ();


foreach my $header (@headers) {
    chomp $header;
    if ($header!~/^ACCESSION.+/) {
        my @array = split /\t/, $header;
        #my @last_array = split /\t/, $header;

        my $domain    = $array[4];
        my $ACCESSION = $array[0];
        my $GI        = $array[1];
        
        #$get_new_header_names{$ID} = $label;
        #print "$domain\t$ACCESSION\t$GI\n";
        $get_new_header_names{$ACCESSION} = $GI;
    }
}




my $original_header = "";
foreach my $fasta_line (@fasta) {
    chomp $fasta_line;
    #get headers:
    if ($fasta_line=~/^>(.+)/)    {	   $original_header =$1;         }
    # get sequence:
    else {	my $seq = $fasta_line;	   $fasta_join_lines{$original_header} .= $seq;     }
}



for my $header2match (keys %fasta_join_lines) {
    my $new_header = "";
    
    if ( $get_new_header_names{$header2match} ) {
        $new_header = $get_new_header_names{$header2match};
        print ">$new_header\n$fasta_join_lines{$header2match}\n";
    }
    else {
        #print "$header2match\tNO_MATCH\tNO_MATCH\n";
    }
}

