#!/bin/bash

afficher_menu () {
	echo "MENU - GESTION DES SALARIES"
	echo "==========================="
	echo "Saisir les information personnelles d'un salarié, taper 1."
	echo "Mettre à jour les informations personnelles d'un salarié, taper 2."
	echo "Consulter les informations personnelles d'un salarié, taper 3."
	echo "Consulter les informations personnelles de tous les salariés, taper 4."
	echo "Supprimer un salarié, taper 5."
	echo "Quitter, taper 60"

	read -p "Saisissez votre nombre : " nombre;
	if [[ ! ( $nombre =~ ^[0-9][0-9]?$ ) ]];
	then
		exit 1;
	fi
}

ajouter_salarie() {
	while [[ ! ( $patronyme =~ ^[A-Za-z]+\ [A-Za-z]+$ ) ]];
	do
		read -p "Saisissez le nom et le prénom du salarié : " patronyme;
		set $patronyme;
	done
	nom=$1;
	prenom=$2;
	lire_date
	echo "Saisissez la situation familiale du salarié :";
	read situation;
	echo "Saisissez le numéro de sécurité sociale du salarié :";
	read nsoc;
	echo "Saisissez l'adresse du salarié :";
	read adresse;
	echo "Saisissez les numéros de téléphone du salarié :";
	read -p "<portable> [<fixe>] : " numeros;
	set $numeros;
	portable=$1;
	if [ $# -eq 2 ];
	then
		fixe=$2;
	fi
	echo "$nom;$prenom;$date;$situation;$nsoc;$adresse;$portable;$fixe" >> fichier_salaries;
}

lire_date () {
	date_incorrecte=true
	while $date_incorrecte;
	do
		while [[ ! ( $date =~ ^[0123][0-9]/[01][0-9]/[0-9]{4}$ ) ]]
		do
			echo "Saisissez la date de naissance du salarié : ";
			read -p "(JJ/MM/AAAA) : " date;
		done
		IFS=/
		set $date;
		day=$1;
		month=$2;
		year=$3;
		if [ $day -ge 1 ] && [ $day -le 31 ] && [ $month -ge 1 ] && [ $month -le 12 ] && [ $year -ge 1 ];
		then
			date_incorrecte=false;
		fi
	done
}

modifier_salarie() {
	echo "Saisissez le nom et le prénom du salarié à modifier";
	read -p "(Nom Prénom)" nom_complet;
	set $nom_complet;
	nom=$1; 
	prenom=$2;
	nb_doublons=$(grep -i "$nom;$prenom;" fichier_salaries | wc -l);
	echo $nb_doublons;
}

while true;
do
	afficher_menu
	if [ $nombre -eq 1 ];
	then
		ajouter_salarie
	elif [ $nombre -eq 2 ];
		then
		modifier_salarie
	elif [ $nombre -eq 3 ];
		then
		echo "Option 3";
	elif [ $nombre -eq 4 ];
		then
		echo "Option 4";
	elif [ $nombre -eq 60 ];
		then
		echo "Sortie du programme...";
		exit 0;
	else
		echo "Code inconnu";
	fi
done

