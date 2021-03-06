#!/usr/bin/perl -w

# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

use strict;
use autodie;
use JSON;
use DBI;

# make nutrient keys friendlier so that in a Mustache template we can refer to
# them using using normal object.property syntax
sub sanitiseNutrientKey($) {
    my ($key) = @_;
    $key =~ s/\s/_/g;
    $key =~ s/[\(\)\%]//g;
    return $key;
}

sub foodGroupCode($) {
    my ($food_group) = @_;

    my $food_group_code = lc($food_group);
    $food_group_code =~ s/\&/and/g;
    $food_group_code =~ s/\ /-/g;
    $food_group_code =~ s/,//g;

    return $food_group_code;
}


# connect to sqlite db
my $dbh = DBI->connect("dbi:SQLite:dbname=dist/nuttab_2010.db", '', '' , {'RaiseError' => 1});

# for tables with a single primary key we can get these into perl hashes
my $food_db = $dbh->selectall_hashref("SELECT  * FROM food;", 'food_id');
my $nutrient = $dbh->selectall_hashref("SELECT  * FROM nutrient;", 'nutrient_id');

my @food_ac;
for my $food_id (keys %{$food_db}) {
    my $food_group_code = foodGroupCode($food_db->{$food_id}->{'food_group'});

    my $food_ac_item = {
        'name' => $food_db->{$food_id}->{'name'},
        'description' => $food_db->{$food_id}->{'description'},
        'food_group' => $food_group_code,
        'id' => $food_id
    };

    $food_db->{$food_id}->{'food_group_code'} = $food_group_code;

    delete $food_db->{$food_id}->{'sort_order'};
    delete $food_db->{$food_id}->{'food_id'};

    push @food_ac, $food_ac_item;
}

for my $nutrient_id (keys %{$nutrient}) {
    delete $nutrient->{$nutrient_id}->{'nutrient_id'};

    #rename key
    $nutrient->{sanitiseNutrientKey($nutrient_id)} = delete $nutrient->{$nutrient_id};
}

# for the other tables we need to loop through results
my $sth = $dbh->prepare("SELECT * FROM recipe;");
$sth->execute();
my %recipe;
my %ingredient;
while ( my $row = $sth->fetchrow_hashref ) {
    my $food_id = $row->{'food_id'};
    delete $row->{'food_id'};
    delete $row->{'food_name'};
    $ingredient{$row->{'ingredient_id'}} = $row->{'ingredient_name'};
    delete $row->{'ingredient_name'};
    push @{$recipe{$food_id}}, $row;
}

$sth = $dbh->prepare("SELECT * FROM food_nutrient_per_volume;");
$sth->execute();
my %food_nutrient_per_volume;
while ( my $row = $sth->fetchrow_hashref ) {
    my $nutrient_id = sanitiseNutrientKey($row->{'nutrient_id'});
    $food_nutrient_per_volume{$row->{'food_id'}}{$row->{'nutrient_id'}} = $row->{'value'};
}
$sth = $dbh->prepare("SELECT * FROM food_nutrient_per_weight;");
$sth->execute();
my %food_nutrient_per_weight;
while ( my $row = $sth->fetchrow_hashref ) {
    my $nutrient_id = sanitiseNutrientKey($row->{'nutrient_id'});
    $food_nutrient_per_weight{$row->{'food_id'}}{$row->{'nutrient_id'}} = $row->{'value'};
}

# now we just write these objects out as JSON files
open (my $food_json, '>', "dist/food.json");
print $food_json encode_json($food_db);
close $food_json;

open (my $food_ac_json, '>', "dist/food_ac.json");
print $food_ac_json encode_json(\@food_ac);
close $food_ac_json;

open (my $recipe_json, '>', "dist/recipe.json");
print $recipe_json encode_json(\%recipe);
close $recipe_json;

open (my $ingredient_json, '>', "dist/ingredient.json");
print $ingredient_json encode_json(\%ingredient);
close $ingredient_json;

open (my $nutrient_json, '>', "dist/nutrient.json");
print $nutrient_json encode_json($nutrient);
close $nutrient_json;

open (my $food_nutrient_per_volume_json, '>', "dist/food_nutrient_per_volume.json");
print $food_nutrient_per_volume_json encode_json(\%food_nutrient_per_volume);
close $food_nutrient_per_volume_json;

open (my $food_nutrient_per_weight_json, '>', "dist/food_nutrient_per_weight.json");
print $food_nutrient_per_weight_json encode_json(\%food_nutrient_per_weight);
close $food_nutrient_per_weight_json;

$dbh->disconnect or warn $!;

