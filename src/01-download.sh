#!/bin/sh

# This file was originally authored by Andrew Harvey <andrew.harvey4@gmail.com>

# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

# The main index page for these file is:
#  http://www.foodstandards.gov.au/consumerinformation/nuttab2010/nuttab2010electronic5119.cfm

mkdir -p "source-data/NUTTAB_2010"

wget --no-clobber --output-document=source-data/NUTTAB_2010/FoodFile.tab "http://www.foodstandards.gov.au/_srcfiles/NUTTAB2010FoodFile.tab"
test -e source-data/NUTTAB_2010/NutrientFile_per_g.tab || wget --no-clobber --output-document=source-data/NUTTAB_2010/NutrientFile_per_g.zip "http://www.foodstandards.gov.au/_srcfiles/NUTTAB2010_%20Nutrient%20File_all%20foods%20per%20100%20g.zip"
test -e source-data/NUTTAB_2010/NutrientFile_per_g_per_ml.tab || wget --no-clobber --output-document=source-data/NUTTAB_2010/NutrientFile_per_g_per_ml.zip "http://www.foodstandards.gov.au/_srcfiles/NUTTAB%202010_%20Nutrient%20File_combination%20solids%20per%20100%20g%20and%20liquids%20per%20100%20mL.zip"
wget --no-clobber --output-document=source-data/NUTTAB_2010/NutrientFile_per_ml.tab "http://www.foodstandards.gov.au/_srcfiles/NUTTAB_2010_NutrientFile_liquidsonlyper100%20mL.txt"
wget --no-clobber --output-document=source-data/NUTTAB_2010/RecipeFile.tab "http://www.foodstandards.gov.au/_srcfiles/NUTTABRecipeFile.tab"
wget --no-clobber --output-document=source-data/NUTTAB_2010/RetentionFactorFile.xls "http://www.foodstandards.gov.au/_srcfiles/NUTTAB%202010%20-%20Retention%20Factor%20File.xls"

test -e source-data/NUTTAB_2010/NutrientFile_per_g.tab || unzip source-data/NUTTAB_2010/NutrientFile_per_g.zip -d source-data/NUTTAB_2010/
test -e source-data/NUTTAB_2010/NutrientFile_per_g.tab || mv "source-data/NUTTAB_2010/2a. NUTTAB 2010 - Nutrient File - all foods per 100 g.txt" "source-data/NUTTAB_2010/NutrientFile_per_g.tab"
test -e source-data/NUTTAB_2010/NutrientFile_per_g_per_ml.tab || unzip source-data/NUTTAB_2010/NutrientFile_per_g_per_ml.zip -d source-data/NUTTAB_2010/
test -e source-data/NUTTAB_2010/NutrientFile_per_g_per_ml.tab || mv "source-data/NUTTAB_2010/2c. NUTTAB 2010 - Nutrient File - combination solids per 100 g and liquids per 100 mL.txt" "source-data/NUTTAB_2010/NutrientFile_per_g_per_ml.tab"

rm -f source-data/NUTTAB_2010/NutrientFile_per_g.zip source-data/NUTTAB_2010/NutrientFile_per_g_per_ml.zip
