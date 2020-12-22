use v5.32;
use strict;

my (%ingredients, %allergens, %ia);

open(FH, '<', 'input.txt') or die $!;
while (<FH> =~ /^(.*) \(contains (.*)\)$/) {
    my @ingredients = split(/ /, $1);
    my @allergens = split(/, /, $2);

    for my $a (@allergens) {
        $allergens{$a}++;
        for my $i (@ingredients) { 
            $ia{$i}{$a}++;
        }
    }

    for (@ingredients) {
         $ingredients{$_}++;
    }
}
close(FH);

# Part 1:
my $na_count = 0;
OUTER: for my $i (keys %ia) {
    for my $a (keys $ia{$i}->%*) {
        if ($ia{$i}{$a} >= $allergens{$a}) {
            next OUTER;
        }
    }

    $na_count += $ingredients{$i};
}
say $na_count;

# Part 2:
my %dangerous_ing = ();
while (%allergens) {
    for my $i (keys %ia) {
        my @matches = ();

        for my $a (keys $ia{$i}->%*) {
            if (defined($allergens{$a}) && $ia{$i}{$a} == $allergens{$a}) {
                push(@matches, $a);
            }
        }

        if (@matches == 1) {
            my $a = shift(@matches);
            $dangerous_ing{$i} = $a;
            delete($allergens{$a});
        }
    }
}

my @canonical_di = sort { $dangerous_ing{$a} cmp $dangerous_ing{$b} } keys %dangerous_ing;
say join(",", @canonical_di);

