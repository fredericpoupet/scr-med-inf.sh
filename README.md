# scr-med-inf.sh

Script d'acquisition des informations d'un périphérique de stockage dans le cadre d'investigations numériques.

## Détails

L'effet recherché est l'obtention immédiate des informations techniques d'un média physique ainsi que des partitions dont la présence est constatée. Les mécanismes de ce script reposent sur des commandes Linux courantes (détails dans la rubrique "Précisions") nécessitant un minimum d'interventions de la part de l'utilisateur.

## Précisions

- L'essentiel des commandes du script ont la capacité de préserver un affichage cohérent malgré l'absence de résultat ;
- Le caractère "*" préfixant certains résultats précise qu'ils sont obtenus par calcul et non par lecture directe ;
- Le script, à des fins de journalisation et en vue d'analyses ultérieures, enregistre le résultat des commandes relatives à l'ensemble des périphériques de stockage, dans des fichiers texte dédiés ;
- Les commandes exploitées sont les suivantes : **fdisk**, **hdparm**, **lsblk**, **lshw**, **smartctl**, **testdisk** et **udevadm**. La disponibilité de ces commandes au sein du système est validée au démarrage de l'exécution du script et les versions identifiées sont précisées ;
- Les résultats d'intérêt sont mis en forme à l'écran, leur enregistrement simultané dans un fichier s'obtient grâce à l'apposition de la commande **tee** lors de l'appel du script (détails dans la rubrique " Exploitation").

## Périmètre d'exploitation

La validation du fonctionnement du script est acquise sur les types de périphériques suivants :
- [x] Cartes MMC ;
- [x] Cartes SD ;
- [x] Clés USB ;
- [x] Disques durs.

## Révisions attendues

- [ ] Enregistrement des signatures cryptographiques des fichiers générés par l'exécution du script ;
- [ ] Mise en forme globale et uniformisation de l'indentation du script ;
- [ ] Normalisation de la robustesse du script à l'absence de résultat à l'ensemble des commandes exploitées ;
- [ ] Prise en charge des volumes de type LVM ;
- [ ] Validation de l'utilisation du script sur d'autres types de médias, dont les disques durs SSD.

## Révisions réalisées

...

## Exploitation

Activation de l'exécution du script :
```
chmod +x scr-med-inf.sh
```

Exécution du script :
```
.\scr-med-inf.sh
```

Exécution du script, enregistrement simultané dans un fichier :
```
.\scr-med-inf.sh | tee <FICHIER>
```

## Exemple de résultat

```
------------------------------------------------
-                                              -
-            SCRIPT : scr-med-inf.sh           -
-              DATE : 19/02/2023               -
-            AUTEUR : Frédéric POUPET          -
-         REFERENCE : XXX                      -
-                                              -
------------------------------------------------

------------------------------------------------------
Saisie du mot de passe de l'utilisateur, si nécessaire
------------------------------------------------------


----------------------------------------------
Informations relatives à l'exécution du script
----------------------------------------------

                  DATE :      LOC : Sun Mar  5 06:36:49 PM +04 2023 - Asia/Dubai (+04, +0400)
                              UTC : Sun Mar  5 02:36:49 PM UTC 2023

           UTILISATEUR :      NOM : user

SYSTEME D'EXPLOITATION :      NOM : Kali GNU/Linux Rolling
                          VERSION : 2022.4
                         HOSTNAME : inf-ord-pc

             LOGICIELS :    FDISK : 2.38.1 (util-linux)
                           HDPARM : 9.65
                            LSBLK : 2.38.1 (util-linux)
                             LSHW : Version indéterminée
                         SMARTCTL : 7.3
                         TESTDISK : 7.1
                          UDEVADM : 252

-------------
Avertissement
-------------

L'enregistrement des résultats affichés à l'écran est à réaliser via la commande [./scr-med-inf.sh | tee <FICHIER>.txt]

-------------------------------------------
Liste des périphériques de bloc disponibles
-------------------------------------------

[lsblk]

NAME                        MAJ:MIN RM    SIZE RO TYPE MOUNTPOINTS
sda                           8:0    0   58.2G  0 disk 
├─sda1                        8:1    0    512M  0 part /boot/efi
├─sda2                        8:2    0    488M  0 part /boot
└─sda3                        8:3    0   57.3G  0 part 
  ├─inf--ord--pc--vg-root   254:0    0   56.3G  0 lvm  /
  └─inf--ord--pc--vg-swap_1 254:1    0    980M  0 lvm  [SWAP]
sdc                           8:32   0  931.5G  0 disk 
├─sdc1                        8:33   0  203.9M  0 part 
├─sdc2                        8:34   0 1019.8M  0 part 
├─sdc3                        8:35   0  156.9M  0 part 
└─sdc4                        8:36   0  930.2G  0 part 

----------------------------------------
Saisie du nom du périphérique à analyser
----------------------------------------


--------------------------------------------------
Informations relatives au périphérique sélectionné
--------------------------------------------------

                                            [lsblk <DEV>]                 NAME : sdc
                                                                          SIZE : 931.5G
                                                                            RO : 0

                                    [sudo fdisk -l <DEV>]                BYTES : 1000204886016
                                                                       SECTORS : 1953525168
                                                             SECTOR SIZE (LOG) : 512
                                                             SECTOR SIZE (PHY) : 4096
                                                                DISKLABEL TYPE : dos
                                                               DISK IDENTIFIER : 0x00000000

                                      [sudo lshw -c disk]          DESCRIPTION : SCSI Disk
                                                                       PRODUCT : EADS-11M2B2
                                                                        VENDOR : WDC WD10
                                                                          DATE :
                                                                        SERIAL : 413A2C854321

                                   [sudo hdparm -N <DEV>]                  HPA : HPA is disabled

                                   [sudo hdparm -i <DEV>]             LBASECTS :

[sudo bash -c "smartctl -s on <DEV> ; smartctl -a <DEV>"]         MODEL FAMILY : Western Digital Caviar Green
                                                                  DEVICE MODEL : WDC WD10EADS-11M2B2
                                                                 SERIAL NUMBER : WD-WCAV5C586999
                                                                           WWN : 5 0014ee 2af131079
                                                              FIRMWARE VERSION : 80.00A80
                                                                 ROTATION RATE :
                                                                   FORM FACTOR :
                                                                          TRIM :
                                                                   ATA VERSION : ATA8-ACS (minor revision not indicated)
                                                                  SATA VERSION : SATA 2.6, 3.0 Gb/s
                                                            POWER ON HOURS (H) : 17449
                                                          * POWER ON HOURS (D) : 727.04
                                                          * POWER ON HOURS (W) : 103.86
                                                          * POWER ON HOURS (M) : 24.23
                                                          * POWER ON HOURS (Y) : 1.99

                          [sudo udevadm info -a -n <DEV>]                 TYPE : 0
                                                                           CID :

-------------
Avertissement
-------------

Les volumes de type LVM ne sont pas pris en charge par le script !

--------------------------------
Liste des partitions disponibles
--------------------------------

[lsblk <DEV>]

NAME   MAJ:MIN RM    SIZE RO TYPE MOUNTPOINTS
sdc      8:32   0  931.5G  0 disk 
├─sdc1   8:33   0  203.9M  0 part 
├─sdc2   8:34   0 1019.8M  0 part 
├─sdc3   8:35   0  156.9M  0 part 
└─sdc4   8:36   0  930.2G  0 part 

---------------------------------------
Informations relatives à la partition 1
---------------------------------------

                                 * OFFSET : 512 x 1 = 512

[lsblk -l <DEV>]                     NAME : sdc1
                                     SIZE : 203.9M
                              MOUNTPOINTS : 

[lsblk -lo ... <DEV>]              FSTYPE : linux_raid_member
                                    FSVER : 0.90.0
                                    LABEL : 
                                     UUID : 95050e1c-516f-23cb-5957-83ff2d9f5def
                                  FSAVAIL : 
                                   FSUSE% : 

[cat /sys/block/<DEV>/<PART>]       START : 1
                                    * END : 417689
                                     SIZE : 417689

---------------------------------------
Informations relatives à la partition 2
---------------------------------------

                                 * OFFSET : 512 x 417690 = 213857280

[lsblk -l <DEV>]                     NAME : sdc2
                                     SIZE : 1019.8M
                              MOUNTPOINTS : 

[lsblk -lo ... <DEV>]              FSTYPE : linux_raid_member
                                    FSVER : 0.90.0
                                    LABEL : 
                                     UUID : 3de6df57-1ade-d218-aea1-73601ddfe4e6
                                  FSAVAIL : 
                                   FSUSE% : 

[cat /sys/block/<DEV>/<PART>]       START : 417690
                                    * END : 2506139
                                     SIZE : 2088450

---------------------------------------
Informations relatives à la partition 3
---------------------------------------

                                 * OFFSET : 512 x 2506140 = 1283143680

[lsblk -l <DEV>]                     NAME : sdc3
                                     SIZE : 156.9M
                              MOUNTPOINTS : 

[lsblk -lo ... <DEV>]              FSTYPE : 
                                    FSVER : 
                                    LABEL : 
                                     UUID : 
                                  FSAVAIL : 
                                   FSUSE% : 

[cat /sys/block/<DEV>/<PART>]       START : 2506140
                                    * END : 2827439
                                     SIZE : 321300

---------------------------------------
Informations relatives à la partition 4
---------------------------------------

                                 * OFFSET : 512 x 2827440 = 1447649280

[lsblk -l <DEV>]                     NAME : sdc4
                                     SIZE : 930.2G
                              MOUNTPOINTS : 

[lsblk -lo ... <DEV>]              FSTYPE : linux_raid_member
                                    FSVER : 0.90.0
                                    LABEL : 
                                     UUID : 3a1b1f78-432b-50f6-ba92-08f6d9eee71f
                                  FSAVAIL : 
                                   FSUSE% : 

[cat /sys/block/<DEV>/<PART>]       START : 2827440
                                    * END : 1953520064
                                     SIZE : 1950692625

-------------------------------------------------------
Récapitulatif des informations relatives aux partitions
-------------------------------------------------------

[sudo fdisk -l <DEV>]

Device     Boot   Start        End    Sectors    Size Id Type
/dev/sdc1             1     417689     417689  203.9M fd Linux raid autodetect
/dev/sdc2        417690    2506139    2088450 1019.8M fd Linux raid autodetect
/dev/sdc3       2506140    2827439     321300  156.9M fd Linux raid autodetect
/dev/sdc4       2827440 1953520064 1950692625  930.2G fd Linux raid autodetect

----------------------------------------------------------------------
Suppression des fichiers temporaires générés par l'exécution du script
----------------------------------------------------------------------

OK !

---------------------------------------------------------------------
Export des résultats des commandes générales dans des fichiers dédiés
---------------------------------------------------------------------

                                               [fdisk -l]         cmd-sdc-fdsik-l.txt : OK

                                        [hdparm -i <DEV>]        cmd-sdc-hdparm-i.txt : OK

                                        [hdparm -N <DEV>]        cmd-sdc-hdparm-N.txt : OK

                                                  [lsblk]           cmd-sdc-lsblk.txt : OK

                                           [lshw -c disk]     cmd-sdc-lshw-c-disk.txt : OK

[sudo bash -c "smartctl -s on <DEV> ; smartctl -a <DEV>"] cmd-sdc-smartctl-s-on-a.txt : OK

                                           [testdisk -lu]     cmd-sdc-testdisk-lu.txt : OK

                                    [udevadm -a -n <DEV>]     cmd-sdc-udevadm-a-n.txt : OK

----------------------------
Fin de l'exécution du script
----------------------------
```
