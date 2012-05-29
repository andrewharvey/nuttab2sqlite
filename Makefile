# This file was originally authored by Andrew Harvey <andrew.harvey4@gmail.com>

# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

all : clean download load

clean-download :
	rm -rf source-data/NUTTAB_2010

clean :
	rm -rf nuttab_2010.db "data-for-import"

download :
	./src/01-download.sh

load :
	# create the schema
	sqlite3 nuttab_2010.db < src/02-create-schema.sql
	# prepart the import files (same as source but without the header line
	mkdir -p "data-for-import"
	tail -n +2 < "source-data/NUTTAB_2010/FoodFile.tab" > "data-for-import/FoodFile.tab"
	cat "source-data/NUTTAB_2010/NutriantFile_per_g.tab" "source-data/NUTTAB_2010/NutriantFile_per_g_per_ml.tab" | cut -d'	' -f2-4 | sort | uniq | grep -v '^"Nutrient ID"' > "data-for-import/Nutriants.tab"
	tail -n +2 < "source-data/NUTTAB_2010/NutriantFile_per_g.tab" | cut -d'	' -f1,2,5,6 > "data-for-import/NutriantFile_per_g.tab"
	tail -n +2 < "source-data/NUTTAB_2010/NutriantFile_per_g_per_ml.tab" | cut -d'	' -f1,2,5,6 > "data-for-import/NutriantFile_per_g_per_ml.tab"
	tail -n +2 < "source-data/NUTTAB_2010/RecipeFile.tab" > "data-for-import/RecipeFile.tab"
	# do the .import
	sqlite3 nuttab_2010.db < src/03-load-data.load
	# clean up
	rm -rf "data-for-import"
