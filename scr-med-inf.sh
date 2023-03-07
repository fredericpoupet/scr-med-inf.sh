#!/bin/bash

# Fihiers temporaires : _ tmp-scr-med-info-gen.txt
#                       _ tmp-scr-med-info-lsblk-l.txt
#                       _ tmp-scr-med-info-lsblk-lo-fstype.txt
#                       _ tmp-scr-med-info-lsblk-lo-fsver.txt
#                       _ tmp-scr-med-info-lsblk-lo-label.txt
#                       _ tmp-scr-med-info-lsblk-lo-uuid.txt
#                       _ tmp-scr-med-info-lsblk-lo-fsavail.txt
#                       _ tmp-scr-med-info-lsblk-lo-fsuse.txt
#                       _ tmp-scr-med-info-lsblk-lo-mountpoints.txt
#                       _ tmp-scr-med-info-fdisk-l.txt

# Variables : _ $REPLY
#             _ dco_delta
#             _ fdisk_sec_size
#             _ fdisk_sectors
#             _ fdisk_start
#             _ fdisk_util_linux
#             _ fdisk_version
#             _ hdparm_lbasect
#             _ hdparm_version
#             _ lsblk_util_linux
#             _ lsblk_version
#             _ part_name
#             _ part_nb
#             _ part_num
#             _ part_size
#             _ part_start
#             _ smartctl_power_on_hours
#             _ smartctl_version
#             _ system_name
#             _ system_version
#             _ testdisk_version
#             _ tz

clear

echo ""

echo "------------------------------------------------"
echo "-                                              -"
echo "-            SCRIPT : scr-med-inf.sh           -"
echo "-              DATE : 19/02/2023               -"
echo "-            AUTEUR : Frédéric POUPET          -"
echo "-         REFERENCE : XXX                      -"
echo "-                                              -"
echo "------------------------------------------------"

echo ""

echo "------------------------------------------------------"
echo "Saisie du mot de passe de l'utilisateur, si nécessaire"
echo "------------------------------------------------------"

echo ""

sudo echo "prout" > /dev/null

echo ""

echo "----------------------------------------------"
echo "Informations relatives à l'exécution du script"
echo "----------------------------------------------"

echo ""

tz=$(timedatectl | grep 'Time zone' | cut -d ":" -f 2)

date_tz=$(date)
date_utc=$(date -u)

system_name=$(cat /etc/*release | grep 'PRETTY_NAME=' | cut -d "\"" -f 2)
system_version=$(cat /etc/*release | grep 'VERSION=' | cut -d "\"" -f 2)

fdisk_util_linux=$(fdisk -v | cut -d " " -f 3)
fdisk_version=$(fdisk -v | cut -d " " -f 4)
hdparm_version=$(hdparm -V | cut -d "v" -f 2)
lsblk_util_linux=$(lsblk -V | cut -d " " -f 3)
lsblk_version=$(lsblk -V | cut -d " " -f 4)
smartctl_version=$(smartctl -V | grep -m 1 'smartctl' | cut -d " " -f 2)
testdisk_version=$(testdisk -v | grep 'Version:' | cut -d " " -f 2)
udevadm_version=$(udevadm --version)

echo "                  DATE :      LOC : $date_tz -$tz"
echo "                              UTC : $date_utc"

echo ""

echo -n "           UTILISATEUR :      NOM : " ; whoami

echo ""

echo -n "SYSTEME D'EXPLOITATION :      NOM : " ; echo $system_name
echo -n "                          VERSION : " ; echo $system_version
echo -n "                         HOSTNAME : " ; hostname

echo ""

echo -n "             LOGICIELS :    FDISK : "


sudo fdisk -v > /dev/null 2>&1

	if [ $? == 0 ]
		then
			echo "$fdisk_version ($fdisk_util_linux)"
		else
			echo "NOK"
	fi
	
echo -n "                           HDPARM : "

hdparm -V > /dev/null 2>&1

	if [ $? == 0 ]
		then
			echo "$hdparm_version"
		else
			echo "NOK"
	fi

echo -n "                            LSBLK : "

lsblk -V > /dev/null 2>&1

	if [ $? == 0 ]
		then
			echo "$lsblk_version ($lsblk_util_linux)"
		else
			echo "NOK"
	fi

echo -n "                             LSHW : "

lshw > /dev/null 2>&1

	if [ $? == 0 ]
		then
			echo "Version indéterminée"
		else
			echo "NOK"
	fi
	
echo -n "                         SMARTCTL : "

smartctl -V > /dev/null 2>&1

	if [ $? == 0 ]
		then
			echo "$smartctl_version"
		else
			echo "NOK"
	fi

echo -n "                         TESTDISK : "

testdisk -v > /dev/null 2>&1

	if [ $? == 0 ]
		then
			echo "$testdisk_version"
		else
			echo "NOK"
	fi
	
echo -n "                          UDEVADM : "

udevadm --version > /dev/null 2>&1

	if [ $? == 0 ]
		then
			echo "$udevadm_version"
		else
			echo "NOK"
	fi

echo ""

echo "-------------"
echo "Avertissement"
echo "-------------"

echo ""

echo "L'enregistrement des résultats affichés à l'écran est à réaliser via la commande [./scr-med-inf.sh | tee <FICHIER>.txt]"

echo ""

echo "-------------------------------------------"
echo "Liste des périphériques de bloc disponibles"
echo "-------------------------------------------"

echo ""

echo "[lsblk]"

echo ""

lsblk | tee tmp-scr-med-info-gen.txt

echo ""

echo "----------------------------------------"
echo "Saisie du nom du périphérique à analyser"
echo "----------------------------------------"

while true;

	do

		unset REPLY

		echo $REPLY

		read -p "<DEV> : "
		
		echo ""
		
		cat tmp-scr-med-info-gen.txt | grep 'disk' | awk '{print $1}' | grep -w $REPLY > /dev/null 2>&1
		 
		if [ $? == 0 ]
		
			then
			
				break
				
			else
			
				echo "\"$REPLY\" n'est pas reconnu en tant que périphérique de bloc valide, veuillez recommencer..."
				
		fi
		
	done	

echo "--------------------------------------------------"
echo "Informations relatives au périphérique sélectionné"
echo "--------------------------------------------------"

echo ""

lsblk /dev/$REPLY | grep 'disk' > tmp-scr-med-info-gen.txt

echo -n "                                            [lsblk <DEV>]                 NAME : " ; cat tmp-scr-med-info-gen.txt | awk '{print $1}'
echo -n "                                                                          SIZE : " ; cat tmp-scr-med-info-gen.txt | awk '{print $4}'
echo -n "                                                                            RO : " ; cat tmp-scr-med-info-gen.txt | awk '{print $5}'

echo ""

sudo fdisk -l /dev/$REPLY > tmp-scr-med-info-gen.txt 2>&1

fdisk_sec_size=$(cat tmp-scr-med-info-gen.txt | grep "Sector size (logical/physical):" | awk '{print $4}')

fdisk_sectors=$(cat tmp-scr-med-info-gen.txt | grep "Disk /dev/$REPLY:" | awk '{print $7}')

echo -n "                                    [sudo fdisk -l <DEV>]                BYTES : " ; cat tmp-scr-med-info-gen.txt | grep "Disk /dev/$REPLY:" | awk '{print $5}'
echo "                                                                       SECTORS : $fdisk_sectors"
echo -n "                                                             SECTOR SIZE (LOG) : " ; cat tmp-scr-med-info-gen.txt | grep "Sector size (logical/physical):" | awk '{print $4}'
echo -n "                                                             SECTOR SIZE (PHY) : " ; cat tmp-scr-med-info-gen.txt | grep "Sector size (logical/physical):" | awk '{print $7}'

# Gestion de l'erreur occasionée par l'absence de l'attribut *DISKLABEL TYPE* : Début

cat tmp-scr-med-info-gen.txt | grep 'Disklabel type:' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                DISKLABEL TYPE : " ; cat tmp-scr-med-info-gen.txt | grep "Disklabel type:" | cut -d ' ' -f 3-999
		else
			echo "                                                                DISKLABEL TYPE :"
	fi

# Gestion de l'erreur occasionée par l'absence de l'attribut *DISKLABEL TYPE* : Fin

# Gestion de l'erreur occasionée par l'absence de l'attribut *DISK IDENTIFIER* : Début

cat tmp-scr-med-info-gen.txt | grep 'Disk identifier:' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                               DISK IDENTIFIER : " ; cat tmp-scr-med-info-gen.txt | grep "Disk identifier:" | cut -d ' ' -f 3-999
		else
			echo "                                                               DISK IDENTIFIER :"
	fi

# Gestion de l'erreur occasionée par l'absence de l'attribut *DISK IDENTIFIER* : Fin

echo ""

sudo lshw -c disk | grep $REPLY -m 1 -B 5 -A 6 > tmp-scr-med-info-gen.txt

# Gestion de l'erreur occasionée par l'absence de l'attribut *DESCRIPTION* : Début

cat tmp-scr-med-info-gen.txt | grep 'description' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                      [sudo lshw -c disk]          DESCRIPTION :" ; cat tmp-scr-med-info-gen.txt | grep 'description' | cut -d ":" -f2
		else
			echo "                                      [sudo lshw -c disk]          DESCRIPTION :"
	fi

# Gestion de l'erreur occasionée par l'absence de l'attribut *DESCRIPTION* : Fin

# Gestion de l'erreur occasionée par l'absence de l'attribut *PRODUCT* : Début

cat tmp-scr-med-info-gen.txt | grep 'product' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                       PRODUCT :" ; cat tmp-scr-med-info-gen.txt | grep 'product' | cut -d ":" -f2
		else
			echo "                                                                       PRODUCT :"
	fi

# Gestion de l'erreur occasionée par l'absence de l'attribut *PRODUCT* : Fin

# Gestion de l'erreur occasionée par l'absence de l'attribut *VENDOR* : Début

cat tmp-scr-med-info-gen.txt | grep 'vendor' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                        VENDOR :" ; cat tmp-scr-med-info-gen.txt | grep 'vendor' | cut -d ":" -f2
		else
			echo "                                                                        VENDOR :"
	fi

# Gestion de l'erreur occasionée par l'absence de l'attribut *VENDOR* : Fin

# Gestion de l'erreur occasionée par l'absence de l'attribut *DATE* : Début

cat tmp-scr-med-info-gen.txt | grep 'date' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                          DATE :" ; cat tmp-scr-med-info-gen.txt | grep 'date' | cut -d ":" -f2
		else
			echo "                                                                          DATE :"
	fi

# Gestion de l'erreur occasionée par l'absence de l'attribut *DATE* : Fin

# Gestion de l'erreur occasionée par l'absence de l'attribut *SERIAL* : Début

cat tmp-scr-med-info-gen.txt | grep 'serial' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                        SERIAL :" ; cat tmp-scr-med-info-gen.txt | grep 'serial' | cut -d ":" -f2
		else
			echo "                                                                        SERIAL :"
	fi

# Gestion de l'erreur occasionée par l'absence de l'attribut *SERIAL* : Fin

echo ""

sudo sudo hdparm -N /dev/$REPLY > tmp-scr-med-info-gen.txt 2>&1

# Gestion de l'erreur occasionée par l'absence de l'attribut *HPA* : Début

cat tmp-scr-med-info-gen.txt | grep 'HPA' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                   [sudo hdparm -N <DEV>]                  HPA :" ; cat tmp-scr-med-info-gen.txt | grep 'HPA' | cut -d "," -f2
		else
			echo "                                   [sudo hdparm -N <DEV>]                  HPA :"
	fi

echo ""

# Gestion de l'erreur occasionée par l'absence de l'attribut *HPA* : Fin

sudo sudo hdparm -i /dev/$REPLY > tmp-scr-med-info-gen.txt 2>&1

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *DCO* : Début

cat tmp-scr-med-info-gen.txt | grep 'LBAsects' > /dev/null

	if [ $? == 0 ]
		then
			hdparm_lbasect=$(cat tmp-scr-med-info-gen.txt | grep 'LBAsects' | cut -d "," -f4 | cut -d "=" -f2)
			dco_delta=$(echo "$fdisk_sectors - $hdparm_lbasect" | bc -l)
			echo "                                   [sudo hdparm -i <DEV>]             LBASECTS : $hdparm_lbasect"
			echo -n "                                                                       * DELTA : $fdisk_sectors - $hdparm_lbasect = " ; echo "$dco_delta"
				if [ $dco_delta == 0 ]
					then
						echo "                                                                         * DCO : Désactivé"
					else
						echo "                                                                         * DCO : Activé"
				fi
		else
			echo "                                   [sudo hdparm -i <DEV>]             LBASECTS :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *DCO* : Fin

echo ""

sudo smartctl -s on /dev/$REPLY > tmp-scr-med-info-gen.txt
sudo smartctl -a /dev/$REPLY >> tmp-scr-med-info-gen.txt

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *MODEL FAMILY* : Début

cat tmp-scr-med-info-gen.txt | grep 'Model Family' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "[sudo bash -c \"smartctl -s on <DEV> ; smartctl -a <DEV>\"]         MODEL FAMILY :" ; cat tmp-scr-med-info-gen.txt | grep 'Model Family' | cut -d " " -f6-99
		else
			echo "[sudo bash -c \"smartctl -s on <DEV> ; smartctl -a <DEV>\"]         MODEL FAMILY :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *MODEL FAMILY* : Fin

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *DEVICE MODEL* : Début

cat tmp-scr-med-info-gen.txt | grep 'Device Model' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                  DEVICE MODEL : " ; cat tmp-scr-med-info-gen.txt | grep 'Device Model' | cut -d " " -f7-99
		else
			echo "                                                                  DEVICE MODEL :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *DEVICE MODEL* : Fin

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *SERIAL NUMBER* : Début

cat tmp-scr-med-info-gen.txt | grep 'Serial Number' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                 SERIAL NUMBER : " ; cat tmp-scr-med-info-gen.txt | grep 'Serial Number' | cut -d " " -f6-99
		else
			echo "                                                                 SERIAL NUMBER :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *SERIAL NUMBER* : Fin

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *WWN* : Début

cat tmp-scr-med-info-gen.txt | grep 'LU WWN Device Id' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                           WWN : " ; cat tmp-scr-med-info-gen.txt | grep 'LU WWN Device Id' | cut -d " " -f5-99
		else
			echo "                                                                           WWN :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *WWW* : Fin

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *FIRMWARE VERSION* : Début

cat tmp-scr-med-info-gen.txt | grep 'Firmware Version' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                              FIRMWARE VERSION : " ; cat tmp-scr-med-info-gen.txt | grep 'Firmware Version' | cut -d " " -f3-99
		else
			echo "                                                              FIRMWARE VERSION :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *FIRMWARE VERSION* : Fin

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *ROTATION RATE* : Début

cat tmp-scr-med-info-gen.txt | grep 'Rotation Rate' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                 ROTATION RATE : " ; cat tmp-scr-med-info-gen.txt | grep 'Rotation Rate' | cut -d " " -f6-999 | sed 's/ rpm//'
		else
			echo "                                                                 ROTATION RATE :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *ROTATION RATE* : Fin

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *FORM FACTOR* : Début

cat tmp-scr-med-info-gen.txt | grep 'Form Factor' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                   FORM FACTOR : " ; cat tmp-scr-med-info-gen.txt | grep 'Form Factor' | cut -d " " -f8
		else
			echo "                                                                   FORM FACTOR :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *FORM FACTOR* : Fin

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *TRIM* : Début

cat tmp-scr-med-info-gen.txt | grep 'TRIM Command' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                          TRIM : " ; cat tmp-scr-med-info-gen.txt | grep 'TRIM Command' | cut -d " " -f7-999
		else
			echo "                                                                          TRIM :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *TRIM* : Fin

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *ATA VERSION* : Début

cat tmp-scr-med-info-gen.txt | grep 'ATA Version is' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                   ATA VERSION : " ; cat tmp-scr-med-info-gen.txt | grep -v 'SATA Version is' | grep 'ATA Version is' | cut -d " " -f6-999
		else
			echo "                                                                   ATA VERSION :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *ATA VERSION* : Fin

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *SATA VERSION* : Début

cat tmp-scr-med-info-gen.txt | grep 'SATA Version is' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                  SATA VERSION : " ; cat tmp-scr-med-info-gen.txt | grep 'SATA Version is' | cut -d " " -f5-999
		else
			echo "                                                                  SATA VERSION :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *SATA VERSION* : Fin

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *POWER_ON_HOURS* : Début

smartctl_power_on_hours=$(cat tmp-scr-med-info-gen.txt | grep 'Power_On_Hours' | awk '{print $10}')

cat tmp-scr-med-info-gen.txt | grep 'Power_On_Hours' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                            POWER ON HOURS (H) : " ; cat tmp-scr-med-info-gen.txt | echo $smartctl_power_on_hours
			echo -n "                                                          * POWER ON HOURS (D) : " ; cat tmp-scr-med-info-gen.txt | echo "scale=2;$smartctl_power_on_hours / 24" | bc -l
			echo -n "                                                          * POWER ON HOURS (W) : " ; cat tmp-scr-med-info-gen.txt | echo "scale=2;$smartctl_power_on_hours / 24 / 7" | bc -l
			echo -n "                                                          * POWER ON HOURS (M) : " ; cat tmp-scr-med-info-gen.txt | echo "scale=2;$smartctl_power_on_hours / 24 / 30" | bc -l
			echo -n "                                                          * POWER ON HOURS (Y) : " ; cat tmp-scr-med-info-gen.txt | echo "scale=2;$smartctl_power_on_hours / 24 / 365" | bc -l
		else
			echo "                                                            POWER ON HOURS (H) :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *POWER_ON_HOURS* : Fin

echo ""

sudo udevadm info -a -n /dev/$REPLY  > tmp-scr-med-info-gen.txt

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *TYPE* : Début

cat tmp-scr-med-info-gen.txt | grep 'ATTRS{type}' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                          [sudo udevadm info -a -n <DEV>]                 TYPE : " ; cat tmp-scr-med-info-gen.txt | grep 'ATTRS{type}' | cut -d "\"" -f2
		else
			echo "                          [sudo udevadm info -a -n <DEV>]                 TYPE :"
	fi

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *TYPE* : Fin

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribut *CID* : Début

cat tmp-scr-med-info-gen.txt | grep 'ATTRS{cid}' > /dev/null

	if [ $? == 0 ]
		then
			echo -n "                                                                           CID : " ; cat tmp-scr-med-info-gen.txt | grep 'ATTRS{cid}' | cut -d "\"" -f2
		else
			echo "                                                                           CID :"
	fi

echo ""

# Gestion de l'erreur occasionée par des données inexploitables concernant l'attribur *CID* : Fin

echo "-------------"
echo "Avertissement"
echo "-------------"

echo ""

echo "Les volumes de type LVM ne sont pas pris en charge par le script !"

echo ""

echo "--------------------------------"
echo "Liste des partitions disponibles"
echo "--------------------------------"

echo ""

echo "[lsblk <DEV>]"

echo ""

lsblk /dev/$REPLY 2> /dev/null

echo ""

lsblk -l /dev/$REPLY > tmp-scr-med-info-lsblk-l.txt 2> /dev/null

lsblk -l -o NAME,FSTYPE /dev/$REPLY > tmp-scr-med-info-lsblk-lo-fstype.txt 2> /dev/null
lsblk -l -o NAME,FSVER /dev/$REPLY > tmp-scr-med-info-lsblk-lo-fsver.txt 2> /dev/null
lsblk -l -o NAME,LABEL /dev/$REPLY > tmp-scr-med-info-lsblk-lo-label.txt 2> /dev/null
lsblk -l -o NAME,UUID /dev/$REPLY > tmp-scr-med-info-lsblk-lo-uuid.txt 2> /dev/null
lsblk -l -o NAME,FSAVAIL /dev/$REPLY > tmp-scr-med-info-lsblk-lo-fsavail.txt 2> /dev/null
lsblk -l -o NAME,FSUSE% /dev/$REPLY > tmp-scr-med-info-lsblk-lo-fsuse.txt 2> /dev/null

sudo fdisk -l /dev/$REPLY > tmp-scr-med-info-fdisk-l.txt 2> /dev/null

part_nb=$(cat tmp-scr-med-info-lsblk-l.txt | grep 'part' | awk '{print $1}' | wc -l)

if [ $part_nb == 0 ]

	then
	
		echo "-------------"
		echo "Avertissement"
		echo "-------------"
		
		echo ""
		
		echo "Aucune partition trouvée !"
		
		echo ""
				
	else

		part_num=1

			while [ $part_num -le $part_nb ]

			do

			cat tmp-scr-med-info-fdisk-l.txt | grep $REPLY$part_num > /dev/null 2>&1

				if [ $? == 0 ]
					then
						part_name=$REPLY$part_num
					else
						part_name=$REPLY\p$part_num
				fi

				if [ $part_num -le 9 ]
					then
						echo "---------------------------------------"
						echo "Informations relatives à la partition $part_num"
						echo "---------------------------------------"
					else
						echo "----------------------------------------"
						echo "Informations relatives à la partition $part_num"
						echo "----------------------------------------"
				fi

			part_start=$(cat /sys/block/$REPLY/$part_name/start)
			part_size=$(cat /sys/block/$REPLY/$part_name/size)

			echo ""

			echo -n "                                 * OFFSET : $fdisk_sec_size x $part_start = " ; echo "$fdisk_sec_size*$part_start" | bc -l

			echo ""

			echo -n "[lsblk -l <DEV>]                     NAME : " ; cat tmp-scr-med-info-lsblk-l.txt | grep $part_name | awk '{print $1}'
			echo -n "                                     SIZE : " ; cat tmp-scr-med-info-lsblk-l.txt | grep $part_name | awk '{print $4}'
			echo -n "                              MOUNTPOINTS : " ; cat tmp-scr-med-info-lsblk-l.txt | grep $part_name | awk '{print $7}'

			echo ""

			echo -n "[lsblk -lo ... <DEV>]              FSTYPE : " ; cat tmp-scr-med-info-lsblk-lo-fstype.txt | grep $part_name | awk '{print $2}'
			echo -n "                                    FSVER : " ; cat tmp-scr-med-info-lsblk-lo-fsver.txt | grep $part_name | awk '{print $2 $3}'
			echo -n "                                    LABEL : " ; cat tmp-scr-med-info-lsblk-lo-label.txt | grep $part_name | cut -d " " -f 2-999
			echo -n "                                     UUID : " ; cat tmp-scr-med-info-lsblk-lo-uuid.txt | grep $part_name | awk '{print $2}'
			echo -n "                                  FSAVAIL : " ; cat tmp-scr-med-info-lsblk-lo-fsavail.txt | grep $part_name | awk '{print $2}'
			echo -n "                                   FSUSE% : " ; cat tmp-scr-med-info-lsblk-lo-fsuse.txt | grep $part_name | awk '{print $2}'

			echo ""

			echo "[cat /sys/block/<DEV>/<PART>]       START : $part_start"
			echo -n "                                    * END : " ; echo "$part_start+$part_size-1" | bc -l
			echo "                                     SIZE : $part_size"

			echo ""

			part_num=$((part_num+1))

			done


			echo "-------------------------------------------------------"
			echo "Récapitulatif des informations relatives aux partitions"
			echo "-------------------------------------------------------"

			echo ""

			echo "[sudo fdisk -l <DEV>]"

			echo ""

			sudo fdisk -l /dev/$REPLY 2> /dev/null | grep -E "Device|/dev/$REPLY" | grep -v 'bytes'

			echo ""
fi

echo "----------------------------------------------------------------------"
echo "Suppression des fichiers temporaires générés par l'exécution du script"
echo "----------------------------------------------------------------------"

rm tmp-scr-med-info-gen.txt
rm tmp-scr-med-info-lsblk-l.txt
rm tmp-scr-med-info-lsblk-lo-fstype.txt
rm tmp-scr-med-info-lsblk-lo-fsver.txt
rm tmp-scr-med-info-lsblk-lo-label.txt
rm tmp-scr-med-info-lsblk-lo-uuid.txt
rm tmp-scr-med-info-lsblk-lo-fsavail.txt
rm tmp-scr-med-info-lsblk-lo-fsuse.txt
rm tmp-scr-med-info-fdisk-l.txt

echo ""

echo "OK !"

echo ""

echo "---------------------------------------------------------------------"
echo "Export des résultats des commandes générales dans des fichiers dédiés"
echo "---------------------------------------------------------------------"

echo ""

sudo fdisk -l > cmd-$REPLY-fdisk-l.txt 2>&1

echo "                                               [fdisk -l]         cmd-$REPLY-fdsik-l.txt : OK"

echo ""

sudo hdparm -i /dev/$REPLY > cmd-$REPLY-hdparm-i.txt 2>&1

echo "                                        [hdparm -i <DEV>]        cmd-$REPLY-hdparm-i.txt : OK"

echo ""

sudo hdparm -N /dev/$REPLY > cmd-$REPLY-hdparm-N.txt 2>&1

echo "                                        [hdparm -N <DEV>]        cmd-$REPLY-hdparm-N.txt : OK"

echo ""

sudo lsblk > cmd-$REPLY-lsblk.txt 2>&1

echo "                                                  [lsblk]           cmd-$REPLY-lsblk.txt : OK"

echo ""

sudo lshw -c disk > cmd-$REPLY-lshw-c-disk.txt 2>&1

echo "                                           [lshw -c disk]     cmd-$REPLY-lshw-c-disk.txt : OK"

echo ""

sudo smartctl -s on /dev/$REPLY > cmd-$REPLY-smartctl-s-on-a.txt && sudo smartctl -a /dev/$REPLY >> cmd-$REPLY-smartctl-s-on-a.txt

echo "[sudo bash -c \"smartctl -s on <DEV> ; smartctl -a <DEV>\"] cmd-$REPLY-smartctl-s-on-a.txt : OK"


echo ""

sudo testdisk -lu > cmd-$REPLY-testdisk-lu.txt 2>&1

echo "                                           [testdisk -lu]     cmd-$REPLY-testdisk-lu.txt : OK"

echo ""

sudo udevadm info -a -n /dev/$REPLY > cmd-$REPLY-udevadm-a-n.txt 2>&1

echo "                                    [udevadm -a -n <DEV>]     cmd-$REPLY-udevadm-a-n.txt : OK"

echo ""

echo "----------------------------"
echo "Fin de l'exécution du script"
echo "----------------------------"
