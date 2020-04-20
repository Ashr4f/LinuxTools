#!/bin/bash

OPTION=$(whiptail --title "LinuxTools" --menu "Veuillez choisir une option : " 15 60 6 \
    "1" "Archivage d’un répertoire" \
    "2" "Compression d’une archive" \
    "3" "Désarchivage d’une archive" \
    "4" "Décompression d’une archive compressée" \
    "5" "Comparaison de 2 fichiers" \
    "6" "Mise en forme d'un fichier .csv" \
    "7" "Affiche votre configuration IP"  \
    "8" "Redémarre votre carte réseau"  \
"9" "Quitter"  3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    
    foldersCount=0
    folders=()
    s=65
    for fol in *
    do
        if [ -d "$fol" ]; then
            folders[foldersCount]=$(echo -en "\0$(( $s / 64 * 100 + $s % 64 / 8 * 10 + $s % 8 ))"\))
            folders[foldersCount+1]="$fol"
            ((foldersCount+=2))
            ((s++))
        fi
    done
    
    function getFiles(){
        filesCount=0
        files=()
        ss=65
        for fil in $1
        do
            if [ -f "$fil" ]; then
                files[filesCount]=$(echo -en "\0$(( $ss / 64 * 100 + $ss % 64 / 8 * 10 + $ss % 8 ))"\))
                files[filesCount+1]="$fil"
                ((filesCount+=2))
                ((ss++))
            fi
        done
    }
    
    getFiles "*"
else
    echo "Vous avez annulé"
fi
