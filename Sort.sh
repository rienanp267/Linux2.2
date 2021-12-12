#!/bin/bash

#user input vragen voor de folder locatie en of het in weken of maanden moet worden opgeslagen
printf "Geef het pad op waar de foto's staan: "
read folder
printf "Geef aan of het op maand of week moet worden verdeeld: "
read monthorweek

#Fotolocatie parameter
location="$PWD/$folder"
echo "de locatie van de foto's is $folder"

#monthorweek has been given
echo "${monthorweek,,}"

if [ -d $folder ]
then
    echo "De folder bestaat"
else
    echo "De folder bestaat niet"
fi

if [ ${monthorweek,,} == "month" ]
then
    numberofdays=30
elif [ ${monthorweek,,} == "week" ]
then
    numberofdays=7
elif [ ${monthorweek,,} == "test" ]
then
    numberofdays=0
else
    echo "maand of week niet goed meegegeven"
fi

#De juiste bestanden per maand of week bekijken
echo $numberofdays
cd $folder
plaatjes=$(find * -type f -mtime +$numberofdays)
echo $plaatjes

for plaatje in $plaatjes
do
    #modificatie datum ophalen
    modtime=$(stat --format="%y" $plaatje)
    echo $modtime
    #alleen het datumdeel
    datum="${modtime:0:10}"
    echo $datum

    #foldernaam baseren op week of maand
    if [ "${monthorweek,,}" == "week" ]
    then
        destdir=$(date --date=$datum "+%U")
    else
        destdir=$(date --date=$datum "+%m")
    fi

    #nieuwe directory maken als deze nog niet bestaat
    if [ ! -d $destdir ]
    then
        mkdir $destdir
    fi

    #maak md5sum en kopieer het plaatje naar de nieuwe bestemming
    md5sum $plaatje > "$location/sum.md5"
    cp $plaatje "$destdir"

    #plaatje en md5sum verwijderen als de md5sum overeenkomt met de nieuwe locatie
    if [ ! $(md5sum -c "$location/sum.md5" | grep -c "Failed") == "" ]
    then
        echo "Oude plaatjes worden verwijdert"
        rm -f "$location/sum.md5"
        rm -f "$location/$plaatje"
    fi
done