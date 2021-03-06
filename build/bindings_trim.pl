#!/usr/bin/env perl

# read whole file
while(<>) { push @file, $_; }

# traverse and remove auto-generated PartialEq for chosen types
for (my $i = 0; $i <= $#file; $i++) {
    if (@file[$i] =~ m/struct\s+blst_p[12]/) {
        @file[$i-1] =~ s/,\s*PartialEq//;
    } elsif (@file[$i] =~ m/struct\s+blst_fp12/) {
        @file[$i-1] =~ s/,\s*Default//;
        @file[$i-1] =~ s/,\s*PartialEq//;
    } elsif (@file[$i] =~ m/struct\s+(blst_pairing|blst_uniq)/) {
        @file[$i-1] =~ s/,\s*Copy//;
        @file[$i-1] =~ s/,\s*Clone//;
        @file[$i-1] =~ s/,\s*Eq//;
        @file[$i-1] =~ s/,\s*PartialEq//;
    } elsif (@file[$i] =~ m/struct\s+blst_scalar/) {
        @file[$i-1] =~ s/,\s*Copy//;
        @file[$i-1] =~ s/\)/, Zeroize\)/;
        splice @file, $i, 0, "#[zeroize(drop)]\n"; $i++;
    }
}

# print the file
print @file;

close STDOUT;
