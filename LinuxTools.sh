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
    
    if [ "$OPTION" == "1" ]; then
        if [[ "${#folders[@]}" > 0 ]]; then
            folder=$((whiptail --title "Archivage d’un répertoire" \
            --menu "Veuillez sélectionner le répertoire à archiver" 16 45 6 "${folders[@]}" 3>&1 1>&2 2>&3) | head -c 1)
            ((folderIndex = 2 * ( $( printf "%d" "'$folder" ) - 65 ) + 1 ))
            
            if [ -z "$folder" ]; then
                echo "Vous avez annulé"
            else
                folderInDir=${folders[$folderIndex]}
                
                if [ -d "$folderInDir" ]; then
                    archiveName=$(whiptail --title "Archivage d’un répertoire" --inputbox "Veuillez saisir un nom" 16 45  3>&1 1>&2 2>&3)
                    
                    exitstatus=$?
                    if [ $exitstatus = 0 ]; then
                        tar -czf ${archiveName}.tar ${folderInDir}
                        echo 'Le dossier "'${folderInDir}'" est bien archivé sous le nom "'${archiveName}'.tar"'
                    else
                        echo "Vous avez annulé"
                    fi
                else
                    echo "Le dossier" '"'${folderInDir}'"' "n'existe pas"
                fi
            fi
        else
            whiptail --title "Archivage d’un répertoire" --msgbox "Il n'y a pas de dossiers dans ce répertoire" 8 54
        fi
    fi
    
    if [ "$OPTION" == "2" ]; then
        file=$((whiptail --title "Compression d’une archive" \
        --menu "Veuillez sélectionner l'archive à compresser" 16 45 6 "${files[@]}" 3>&1 1>&2 2>&3) | head -c 1)
        ((fileIndex = 2 * ( $( printf "%d" "'$file" ) - 65 ) + 1 ))
        
        if [ -z "$file" ]; then
            echo "Vous avez annulé"
        else
            fileInDir=${files[$fileIndex]}
            
            if [ -d "$fileInDir" ] || [ -f "$fileInDir" ]; then
                archiveName=$(whiptail --title "Compression d’une archive" --inputbox "Veuillez saisir un nom" 16 45  3>&1 1>&2 2>&3)
                
                exitstatus=$?
                if [ $exitstatus = 0 ]; then
                    tar -czf ${archiveName}.tar.gz ${fileInDir}
                    echo $'L\'archive '\"$fileInDir\"' est bien archivé sous le nom "'${archiveName}'.tar.gz"'
                else
                    echo "Vous avez annulé"
                fi
            else
                echo $'L\'archive '\"$fileInDir\"'' $'n\'existe pas'
            fi
        fi
    fi

    if [ "$OPTION" == "3" ]; then
        getFiles "*.tar"

        if [[ "${#files[@]}" > 0 ]]; then
            file=$((whiptail --title "Désarchivage d’une archive" \
            --menu "Veuillez sélectionner l'archive à désarchiver" 16 45 6 "${files[@]}" 3>&1 1>&2 2>&3) | head -c 1)
            ((fileIndex = 2 * ( $( printf "%d" "'$file" ) - 65 ) + 1 ))

            if [ -z "$file" ]; then
                echo "Vous avez annulé"
            else
                fileInDir=${files[$fileIndex]}

                if [ -f "$fileInDir" ]; then
                    tar -xf ${fileInDir}
                    echo $'L\'archive '\"$fileInDir\"' a été bien désarchivée'
                else
                    echo $'Le fichier '\"$fileInDir\"'' $'n\'existe pas'
                fi
            fi
        else
            whiptail --title "Désarchivage d’une archive" --msgbox "Il n'y a pas de fichiers \"tar\" dans ce répertoire" 8 54
        fi
    fi
    
    if [ "$OPTION" == "4" ]; then
        getFiles "*.gz"
        
        if [[ "${#files[@]}" > 0 ]]; then
            file=$((whiptail --title "Décompression d’une archive compressée" \
            --menu "Veuillez séléctionner l'archive à décompresser" 16 45 6 "${files[@]}" 3>&1 1>&2 2>&3) | head -c 1)
            ((fileIndex = 2 * ( $( printf "%d" "'$file" ) - 65 ) + 1 ))
            
            if [ -z "$file" ]; then
                echo "Vous avez annulé"
            else
                fileInDir=${files[$fileIndex]}
                
                if [ -f "$fileInDir" ]; then
                    echo $fileInDir
                    tar -xzf ${fileInDir}
                    echo $'L\'archive '\"$fileInDir\"' a été bien décompressée'
                else
                    echo $'L\'archive '\"$fileInDir\"'' $'n\'existe pas'
                fi
            fi
        else
            whiptail --title "Décompression d’une archive compressée" --msgbox "Il n'y a pas de fichiers \"gz\" dans ce répertoire" 8 54
        fi
    fi
    
    if [ "$OPTION" == "5" ]; then
        file1=$((whiptail --title "Comparaison de 2 fichiers" \
        --menu "Veuillez choisir le premier fichier" 16 45 6 "${files[@]}" 3>&1 1>&2 2>&3) | head -c 1)
        ((file1Index = 2 * ( $( printf "%d" "'$file1" ) - 65 ) + 1 ))
        
        exitstatus=$?
        if [ $exitstatus = 0 ]; then
            file2=$((whiptail --title "Comparaison de 2 fichiers" \
            --menu "Veuillez choisir le deuxième fichier" 16 45 6 "${files[@]}" 3>&1 1>&2 2>&3) | head -c 1)
            ((file2Index = 2 * ( $( printf "%d" "'$file2" ) - 65 ) + 1 ))
            
            exitstatus=$?
            if [ $exitstatus = 0 ]; then
                file1Hash=`md5sum ./${files[file1Index]} | awk '{print $1}'`
                file2Hash=`md5sum ./${files[file2Index]} | awk '{print $1}'`
                if [ $file1Hash == $file2Hash ]
                then
                    echo '"'${files[file1Index]}'" Et "'${files[$file2Index]}'" Sont identiques.'
                else
                    echo '"'${files[file1Index]}'" Et "'${files[$file2Index]}'" Sont différents.'
                fi
            else
                echo "Vous avez annulé"
            fi
        else
            echo "Vous avez annulé"
        fi
    fi
    
    if [ "$OPTION" == "6" ]; then
        getFiles "*.csv"
        
        if [[ "${#files[@]}" > 0 ]]; then
            file=$((whiptail --title "Mise en forme d'un fichier .csv" \
            --menu "Veuillez sélectionner le fichier .csv à mettre en forme" 16 45 6 "${files[@]}" 3>&1 1>&2 2>&3) | head -c 1)
            ((fileIndex = 2 * ( $( printf "%d" "'$file" ) - 65 ) + 1 ))
            
            if [ -z "$file" ]; then
                echo "Vous avez annulé"
            else
                fileInDir=${files[$fileIndex]}
                
                if [ -f "$fileInDir" ] && [ "${fileInDir: -4}" == ".csv" ]; then
                    cat "$fileInDir" | sed -e 's/,,/, ,/g' | column -s, -t | less -#5 -N -S
                else
                    echo '"'${fileInDir}'"' "n'est pas un fichier .csv"
                fi
            fi
        else
            whiptail --title "Mise en forme d'un fichier .csv" --msgbox "Il n'y a pas de fichiers \"csv\" dans ce répertoire" 8 54
        fi
    fi
    
    if [ "$OPTION" == "7" ]; then
        ip addr show
    fi
    
    if [ "$OPTION" == "8" ]; then
        sudo /etc/init.d/network-manager restart
    fi
    
    if [ "$OPTION" == "9" ]; then
        echo "Vous avez quitté"
    fi
    
else
    echo "Vous avez annulé"
fi
