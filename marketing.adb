with p_fenbase; use p_fenbase;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with ada.calendar; use ada.calendar;

procedure marketing is
  FSaisieNom,  FJeu,  FResultat  : TR_Fenetre;   -- l'application comporte 3 fenetres
  Compteur   : Natural;
  Touche     : Character;
  I,  J      : Natural;
  Nombouton	 : String(1..2);
  HeureDeb,HeureFin : Time;
  NewLine    : constant Character  := Character'Val (10);   -- retour chariot
begin
   ----------------------------------------------------------------------------
   -- on initialise l'interface graphique (a ne faire qu'une fois en debut de programme)
   InitialiserFenetres;
   ----------------------------------------------------------------------------
   -- on dessine la fenetre pour saisir le nom du "gogo"
   FSaisieNom:=DebutFenetre("Nom du Joueur",400,90);
      AjouterChamp(FSaisieNom,"ChampNom","Votre Nom","quidam",100,10,280,30);
      AjouterBouton(FSaisieNom,"BoutonValider","valider",100,50,70,30);
      AjouterBouton(FSaisieNom,"BoutonAnnuler","annuler",180,50,70,30);
   FinFenetre(FSaisieNom);
   ----------------------------------------------------------------------------
   -- on dessine la fenetre pour "jouer"
   FJeu:=DebutFenetre("CHANCE",300,450);
     	AjouterTexte(FJeu,"message1","TAPER SUR 3 TOUCHES ...",10,10,250,30);
		 	AjouterTexte(FJeu, "message2","Tente ta chance !",10,50,280,30);
       -- on ajoute une grille de 3x3 boutons affichant les valeurs de 1 à 9
      -- on donne à chaque bouton un nom d'élément qui représente sa position dans la grille
      -- le bouton de la ligne 2 colonne 2 s'appellera donc "23"
      for I in 1..3 loop
         for J in 1..3 loop
						nombouton := Integer'Image(I)(2..2) & Integer'Image(J)(2..2);
				    -- le bouton en i,j s'appelle "ij" et affiche la valeur (i-1)*3+J
						AjouterBouton(FJeu,nombouton,integer'image((i-1)*3+J),(J-1)*60+40,(I-1)*60+90,60,60);
						ChangerCouleurFond(FJeu,nombouton,FL_DARKGOLD);
						ChangerTailleTexte(Fjeu,nombouton,FL_Large_Size);
						ChangerStyleTexte(Fjeu,nombouton,FL_Bold_Style);
          end loop;
      end loop;
      AjouterTexte(FJeu,"BarreDEtat","Aucune touche pressee",10,300,250,30);
			AjouterBouton(FJeu,"Fin","FIN",55,390,70,30);
			ChangerStyleTexte(FJeu, "Fin", FL_BOLD_Style);
			ChangerTailleTexte(Fjeu,"Fin",FL_medium_size);
			AjouterHorlogeDigi(Fjeu,"Clock","",150,350,100,70);
			ChangerStyleTexte(FJeu,"Clock", FL_BOLD_STYLE);
			ChangerTailleTexte(Fjeu,"Clock", FL_medium_size);
			ChangerCouleurFond(FJeu,"Clock", FL_WHITE);
      AjouterBouton(FJeu,"BoutonAbandonner","abandon",55,350,70,30);
   FinFenetre(FJeu);
   ----------------------------------------------------------------------------
   -- on dessine la fenetre pour afficher le "gain"
   Fresultat:=Debutfenetre("Votre gain ! ",300,200);
      AjouterTexteAscenseur(FResultat,"message","","",10,10,280,100);
      AjouterBouton(FResultat,"BoutonFin","The End",115,140,70,30);
   FinFenetre(FResultat);

   ----------------------------------------------------------------------------
   -- debut du jeu, on montre la premiere fenetre et on attend un bouton
   MontrerFenetre(FSaisieNom);
   if AttendreBouton(FSaisieNom)/="BoutonAnnuler" then
      CacherFenetre(FSaisieNom);
      Compteur:=0; -- nombre de touches pressées
      ChangerTexte(Fjeu,"message2", ConsulterContenu(FSaisieNom,"ChampNom")& " tente ta chance !");
      MontrerFenetre(FJeu);
			HeureDeb:=clock;
			-- interdiction de cliquer sur Fin tant qu'on n'a pas joué ou abandonné
			ChangerEtatbouton(FJeu,"Fin",Arret);
      loop -- BOUCLE jusqu'a la fin du jeu ou l'abandon
         declare
            Bouton : String := (Attendrebouton(Fjeu));
         begin
            if Bouton /= "BoutonAbandonner" and Bouton /= "Fin" then
               if compteur < 3 then
								Compteur:=Compteur+1; -- une nouvelle touche a été pressée
								ChangerEtatBouton(FJeu, Bouton, Arret); -- bouton rendu inactif
               	ChangerCouleurFond(Fjeu, Bouton, FL_DEEPPINK); -- et mis en rose
								ChangerTailleTexte(Fjeu,Bouton,FL_SMALL_SIZE); -- pour que le texte rentre dans la case
               	ChangerTexte(Fjeu, Bouton, "GAGNE"); -- et c'est l'arnaque !!!
               	-- on calcule les coordonnees (i,j) dans la grille du bouton pressé grace au nom du bouton...
               	I:=Character'Pos(Bouton(Bouton'First)) - Character'Pos('0');
               	J:=Character'Pos(Bouton(Bouton'Last))  - Character'Pos('0');
               	-- on calcule la "valeur" du bouton pressé et on la convertit en char
               	Touche:=Character'Val(((I-1)*3+J)+Character'Pos('0'));
               	-- on changer l'objet texte "BarreDetat" en fonction de la touche pressée
               	ChangerTexte(Fjeu,"BarreDEtat","La touche " & Touche & " a ete pressee");
						if compteur = 3 then -- C'est gagné !!!
      					for I in 1..3 loop -- on désactive toutes les cases du jeu (sans faire de détail !...)
         					for J in 1..3 loop
									nombouton := Integer'Image(I)(2..2) & Integer'Image(J)(2..2);
            			ChangerEtatBouton(FJeu,nombouton,Arret);
								end loop;
							end loop;
							HeureFin:= clock;
							ChangerTexte(Fjeu,"message2","BRAVO !!! tu as gagne en"
                  	& natural'image(natural(Heurefin-HeureDeb))& "''");
							ChangerStyleTexte(FJeu, "message2", FL_BOLD_Style);
							ChangerTailleTexte(Fjeu,"message2",FL_medium_Size);
							ChangerEtatBouton(FJeu,"Fin",Marche);
						end if;
					end if;
				elsif Bouton = "Fin" then
					exit;
				else
					compteur := 0;
					exit;
				end if;
			end;
		end loop;

		CacherFenetre(FJeu);
		if Compteur=0 then -- le joueur a abandonné
			ChangerCouleurFond(FResultat,"fond",FL_BLACK);-- fond noir pour accabler
			ChangerContenu(FResultat,"message","Joueur " & ConsulterContenu(FSaisieNom,"ChampNom") & NewLine &
               "qui ne tente rien n'a rien !!!");
		else -- le joueur a tenté sa chance
			ChangerCouleurFond(FResultat,"fond",FL_RED); -- fond rouge pour encenser
      ChangerContenu(FResultat,"message","Joueur " & ConsulterContenu(FSaisieNom,"ChampNom") &
              ", NOUS T'ATTENDONS ! "  & NewLine & "RDV au magasin, " & NewLine & "TU GAGNERAS ENCORE !!!");
		end if;
    Montrerfenetre(Fresultat); -- on affiche la fenetre des gains
		loop
			exit when Attendrebouton(Fresultat) = "BoutonFin";
		end loop;
	end if;
end marketing;
