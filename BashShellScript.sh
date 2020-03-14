#!/bin/bash

#scriptul va fi rulat in shell-ul bash

cd /home/soare/mybin

if [[ ! -f produse.txt ]]; then 
	
	touch produse.txt
	touch aux.txt
fi
#verifica existenta fisierului text si il creeaza

while [[ $REPLY != 0 ]]; do

    clear

    cat <<_EOF_

        Optiuni:

        1. Afisare lista produse(ordonate alfabetic)

        2. Afisare lista produse(ordonate crescator dupa pret)

        3. Afisare lista produse(ordonate descrescator dupa pret)

        4. Cautare produs

	5. Adaugare produs
	
	6. Stergere produs
        
	7. Modificare pret

	8. Cautati produsele ce se afla intr-un anumit interval de pret
        
	0. Iesire


_EOF_

    read -p "Introduceti optiunea dorita [0-8] > " #read prompt

    if [[ $REPLY =~ ^[0-8]$ ]]; then

        if [[ $REPLY == 1 ]]; then

	clear

        column -t produse.txt 
#afiseaza continutul fisierului pe coloane


        fi
    if [[ $REPLY == 0 ]]; then 
     exit
    fi

    if [[ $REPLY == 2 ]]; then

	clear        

	sort -k 2n produse.txt | column -t

        fi

#sorteaza crescator continutul de pe a 2-a coloana (pret) si afiseaza
	
    if [[ $REPLY == 3 ]]; then

        
	clear	

	sort -k 2n produse.txt | column -t | tac
#sorteaza crescator continutul de pe a 2-a coloana (pret) si afiseaza invers ( tac este inversul lui cat)

        fi

    if [[ $REPLY == 4 ]]; then

        read -p "Introduceti numele produsului: " produs
#citeste numele produsului
	
	if [[ $(grep -c $produs produse.txt) -eq 1 ]]; then

		clear
		grep $produs produse.txt
	else
	
		clear
		echo "Produs inexistent"
	fi
#verifica daca produsul introdus exista in fisier(verifica de cate ori apare si compara cu 1); daca nu, afiseaza eroare


        fi

     if [[ $REPLY == 5 ]]; then

        read -p "Introduceti numele produsului: " produs
#citeste numele produsului

	if [[ $(grep -c $produs produse.txt) -eq 1 ]]; then
		clear
		echo "Produs deja existent"

	else
	
#verifica daca valoarea introdusa este de forma numar.numar; daca nu, afiseaza eroare
#daca pretul e un numar real, il adauga in fisier;
#daca pretul e un numar intreg, il adauga in fisier in forma ceruta(xx.00)

		read -p "Introduceti pretul produsului: " pret
		re='^[0-9]+([.][0-9]+)?$'
		if ! [[ $pret =~ $re ]] ; then
		clear
   		echo "Eroare: Pretul trebuie sa fie de forma xx.yy!"
		else
		if [[ $(grep -c "." $pret) -eq 1 ]]; then
			
			echo "$produs  $pret" >> produse.txt
		else
			
			printf $produs >> produse.txt 
			printf " " >> produse.txt
			printf "%.2f\n" $pret >> produse.txt
		
		fi

		sort produse.txt > aux.txt
		cat aux.txt > produse.txt
		clear
		echo "Produsul a fost adaugat"
		fi
		
	fi
	

      fi

#verifica daca produsul introdus exista in fisier(verifica de cate ori apare si compara cu 1); daca da, afiseaza eroare; daca nu, citeste pretul produsului si introduce informatiile pe 2 coloane in fisier
#sorteaza alfabetic fisierul folosind fisierul aux.txt


    if [[ $REPLY == 7 ]]; then

        read -p "Introduceti numele produsului: " produs

	if [[ $(grep -c $produs produse.txt) -eq 0 ]]; then
		clear
		echo "Produs inexistent"

	else
	
                sed "/$produs/d" produse.txt | cat > aux.txt
		cat aux.txt > produse.txt

		read -p "Introduceti noul pret al produsului: " pret
		re='^[0-9]+([.][0-9]+)?$'
		if ! [[ $pret =~ $re ]] ; then
		clear
		echo "Eroare: Pretul trebuie sa fie de forma xx.yy!"
		else
		if [[ $(grep -c "." $pret) -eq 1 ]]; then
			
			echo "$produs  $pret" >> produse.txt
		else
			
			printf $produs >> produse.txt 
			printf " " >> produse.txt
			printf "%.2f\n" $pret >> produse.txt
		
		fi

		sort produse.txt > aux.txt
		cat aux.txt > produse.txt
		clear
		echo "Pretul a fost modificat"
		fi
		
	fi
	
#verifica daca produsul exista in fisier; daca nu, afiseaza eroare; daca da, sterge produsul vechi si il adauga pe cel nou cu pretul modificat

        fi

    if [[ $REPLY == 6 ]]; then

        read -p "Introduceti numele produsului: " produs
	
	if [[ $(grep -c $produs produse.txt) -ne 1 ]]; then
		
		clear
		echo "Produs inexistent"
	else
	
		sed "/$produs/d" produse.txt | cat > aux.txt

		cat aux.txt > produse.txt
		
		if [[ $(grep -c $produs produse.txt) -ne 1 ]]; then
		
			clear
			echo "Produsul a fost sters cu succes"

		fi
	fi
	
        
    fi
#verifica daca produsul introdus exista in fisier(verifica de cate ori apare si compara cu 1); daca nu, afiseaza eroare; daca da, sterge linia pe care se afla produsul;

    if [[ $REPLY == 8 ]]; then
	
	read -p "Introduceti valoarea inferioara: " pret1
	read -p "Introduceti valoarea superioara: " pret2
	if [[ $pret1 -lt $pret2 ]]; then

		clear
		for i in $(seq $pret1 0.01 $pret2)
		do
			grep $i produse.txt
		done
	
	else
		clear
		echo "Valorile introduse sunt invalide"
	fi

    fi
#citeste capetele intervalului
#daca val inf < val sup, genereaza toate numerele de la pret1 la pret2 cu pasul 0.01 si le cauta in fisier; daca exista, sunt afisate
    
 else

        clear
	echo "Optiune invalida"
#afiseaza eroare daca se introduce alt caracter inafara de cifrele 0-6 


fi

echo ""
echo "Apasati enter pentru a continua sau 0 pentru a iesi: "
read

done







