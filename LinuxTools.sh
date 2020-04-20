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
    echo "Option: $OPTION"
else
    echo "Vous avez annulé"
fi
