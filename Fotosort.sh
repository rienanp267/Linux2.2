#!/bin/bash

monthorweek=""
picturepath=""
md5old=""
md5new=""
newdir=""
date=""
year=""
month=""
week=""
day=""

function sortondate {
    #loop door de picture folder heen
    for picture in $picturepath/*
    do echo $picture
    #trim IMG-, Pictures/IMG- en Pictures/ into a date yearmonthday
        if [[ "$picture" =~ ^Pictures/IMG-* ]]
        then
            date=${picture:13:8}
            year=${picture:13:4}
            month=${picture:17:2}
            day=${picture:19:2}
            weeknr=$((${picture:19:2} / 7 ))
                if [ $((${picture:19:2} % 7)) != 0 ]
                then
                    week=$(($weeknr + 1))
                else
                    week=$weeknr
                fi
            echo $date $year $month $week $day
        elif [[ "$picture" =~ ^Pictures/* ]]
        then
            date=${picture:9:8}
            year=${picture:9:4}
            month=${picture:13:2}
            day=${picture:15:2}
            weeknr=$((${picture:15:2} / 7 ))
                if [ $((${picture:15:2} % 7)) != 0 ]
                then
                    week=$(($weeknr + 1))
                else
                    week=$weeknr
                fi
            echo $date $year $month $week $day
        elif [[ "$picture" =~ ^IMG-* ]]
        then
            date=${picture:4:8}
            year=${picture:4:4}
            month=${picture:8:2}
            day=${picture:10:2}
            weeknr=$((${picture:10:2} / 7 ))
                if [ $((${picture:10:2} % 7)) != 0 ]
                then
                    week=$(($weeknr + 1))
                else
                    week=$weeknr
                fi
            echo $date $year $month $week $day
        else
            echo "deze oplossing kan niet gevonden worden"
        fi

        #if month (tolower) equals month
        if [[ "${monthorweek,,}" == "month" ]]
        then
            pwd
            newdir="/$month-$year"
            #check of er al een folder met deze maandnaam bestaat
            if [ -d $newdir ]
            then
                #folder bestaat al
                echo "folder bestaat al"
            #else
            else
                #maak een nieuwe folder aan
                mkdir $newdir
            fi
            #maak een md5sum van het plaatje
            md5sum $picture > "$picturepath/sum.md5"
            #kopieer het plaatje naar de nieuwe folder
            cp $picture "$newdir"
            #echo "monthif"
        #elif week:
        elif [[ "${monthorweek,,}" == "week" ]]
        then
            newdir="/$month-$year-week$week"
            #check of er al een folder met deze weeknaam bestaat
            if [ -d $newdir ]
            then
                #folder bestaat al
                echo "folder bestaat al"
            #else
            else
                #maak een nieuwe folder aan
                mkdir $newdir
            fi
            #maakt een md5sum van het plaatje
            md5sum $picture > "$picturepath/sum.md5"
            #kopieer het plaatje naar de nieuwe folder
            cp $picture "$newdir"
            #echo "weekelif"
        else
            echo "Foute datumtype meegegeven, kopieren afgeblazen"
        fi

        #vergelijk beide md5sums met elkaar
            #remove het plaatje van de oude locatie
        if [ !$(md5sum -c "$picturepath/sum.md5" | grep -c "Failed") == "" ]
        then
            echo "bestand wordt verwijdert"
            rm -f "$picturepath/sum.md5"
            #rm -f "$picturepath/$picture"
        fi
    done
}

printf "Geef het pad op waar de plaatjes staan: "
read picturepath
printf "Sorteren op month of week: "
read monthorweek
sortondate "$picturepath" "$monthorweek"