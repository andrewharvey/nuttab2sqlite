# This file was originally authored by Andrew Harvey <andrew.harvey4@gmail.com>

# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

all : clean download load

clean-download :
	rm -rf source-data/NUTTAB_2010

clean :
	rm -rf dist import-stage

download :
	./src/01-download.sh

dbload :
	mkdir -p dist
	# create the schema
	sqlite3 dist/nuttab_2010.db < src/02-create-schema.sql
	# prepare the import files (same as source but without the header line
	mkdir -p "import-stage"
	tail -n +2 < "source-data/NUTTAB_2010/FoodFile.tab" > "import-stage/FoodFile.tab"
	cat "source-data/NUTTAB_2010/NutrientFile_per_g.tab" | cut -d'	' -f2-4,6 | sort | uniq | grep -v '^"Nutrient ID"' > "import-stage/Nutrients.tab"
	tail -n +2 < "source-data/NUTTAB_2010/NutrientFile_per_g.tab" | cut -d'	' -f1,2,5 > "import-stage/NutrientFile_per_g.tab"
	tail -n +2 < "source-data/NUTTAB_2010/NutrientFile_per_ml.tab" | cut -d'	' -f1,2,5 > "import-stage/NutrientFile_per_ml.tab"
	tail -n +2 < "source-data/NUTTAB_2010/RecipeFile.tab" > "import-stage/RecipeFile.tab"
	# do the .import
	sqlite3 dist/nuttab_2010.db < src/03-load-data.load
	# clean up
	rm -rf "import-stage"
