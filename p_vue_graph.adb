with p_fenbase, forms, p_virus;
use p_fenbase, forms, p_virus;
with p_virus; use p_virus;


package body p_vue_graph is
  prefix : constant string := "case";
  fen : TR_Fenetre;
  f : p_piece_io.file_type;
  pieces : TV_pieces;

  procedure InitGraph(FAccueil : in out TR_Fenetre) is

  begin -- InitGraph

    InitialiserFenetres;

    FAccueil := DebutFenetre("Accueil", 400, 240);
      ChangerCouleurFond(FAccueil, "fond", FL_WHITE);
      AjouterTexte(FAccueil, "MessageBienvenue0", "Bonjour !", 168,10, 65,25);
      AjouterTexte(FAccueil, "MessageBienvenue1", "Bienvenue dans Anti-Virus !", 110,35, 180,25);
      ChangerCouleurFond(FAccueil, "MessageBienvenue0", FL_White);
      ChangerCouleurFond(FAccueil, "MessageBienvenue1", FL_White);
      AjouterChamp(FAccueil,"champPseudo","Pseudo : ","Joueur", 125,80, 200,30);
      AjouterChamp(FAccueil,"champNival","Difficulte : ","1", 127,115, 200,30);
      AjouterTexte(FAccueil, "messageErreurNival", "La difficultee entree est incorrecte", 90,150, 220,25);
      ChangerCouleurFond(FAccueil, "messageErreurNival", FL_White);
      ChangerCouleurTexte(FAccueil, "messageErreurNival", FL_RED);
      CacherElem(FAccueil, "messageErreurNival");
      AjouterBouton(FAccueil,"Jouer  ","Jouer", 145,190, 50,30);
      AjouterBouton(FAccueil,"Quitter","Quitter", 205,190, 50,30);
    FinFenetre(FAccueil);

  end InitGraph;

  function checkJeu(diff : in String) return integer is

    nival, nival1, nival2 : integer := 0;

  begin -- checkJeu

    nival1 := character'pos(diff(1))-character'pos('0');
    nival2 := character'pos(diff(2))-character'pos('0');

    if nival1 in 0..9 then
      nival := nival1;
      if nival2 in 0..9 then
        nival := nival1 * 10 + nival2;
      end if;
    else
      return 0;
    end if;

    if nival in 1..20 and diff(3)= ' 'then
      return nival;
    else
      return 0;
    end if;

  end checkJeu;

  function InitCaseName(l: in T_Lig;c: in T_Col) return string is
  begin
    return prefix & T_Lig'image(l) & c;
  end InitCaseName;


  procedure InitFenJeu (Grille : in out TV_Grille; fen : out TR_Fenetre;nival : in natural) is
  begin
    InitPartie(grille,pieces);
    open(f, in_file, "Defis.bin");
    configurer(f,nival,grille,pieces);

    Fen := DebutFenetre("Antivirus du grp4 les best :)", 450, 700);
      changercouleurfond(fen,"fond",FL_RIGHT_BCOL);
      AffichageGrille(Grille,fen,nival);
      AjouterImage(fen,"fond.xpm","fond.xpm","",45,45,5,360);
      AjouterImage(fen,"fond2.xpm","fond2.xpm","",45,45,358,5);
      AjouterImage(fen,"fond3.xpm","fond3.xpm","",45,400,358,5);
      AjouterImage(fen,"fond4.xpm","fond4.xpm","",399,45,5,360);

      AjouterBouton(fen,"boutonregle","?",0,0,50,50);
      AjouterBouton(fen,"boutonrecommencer","recommencer",0,650,100,50);
      changercouleurfond(fen,"boutonrecommencer",FL_palegreen);
      AjouterBouton(fen,"boutonabandonner","abandonner",350,650,100,50);
      changercouleurfond(fen,"boutonabandonner",FL_INDIANRED);
      AjouterBouton(fen,"boutonannuler","annuler 1 coup",150,600,150,50);
      changercouleurfond(fen,"boutonannuler",FL_darkgold);
      AjouterBouton(fen,"demo","demo",300,0,100,40);

      AjouterBouton(fen,"suivant","suivant",150,450,200,100);
      cacherelem(fen,"suivant");
      AjouterBouton(fen,"stop","x",400,0,50,50);
      cacherelem(fen,"stop");
      changercouleurfond(fen,"stop",FL_darktomato);

      AjouterBoutonImage(fen,"hg","","fleche_hg.xpm",150,450,50,50);
      changercouleurfond(fen,"hg",FL_white);
      AjouterBoutonImage(fen,"hd","","fleche_hd.xpm",250,450,50,50);
      changercouleurfond(fen,"hd",FL_white);
      AjouterBoutonImage(fen,"bd","","fleche_bd.xpm",250,500,50,50);
      changercouleurfond(fen,"bd",FL_white);
      AjouterBoutonImage(fen,"bg","","fleche_bg.xpm",150,500,50,50);
      changercouleurfond(fen,"bg",FL_white);
      CacherElem(fen, "hg");
      CacherElem(fen, "hd");
      CacherElem(fen, "bg");
      CacherElem(fen, "bd");

    FinFenetre(fen);
  end InitFenJeu;



  procedure AffichageGrille(Grille : in out TV_Grille; fen : out TR_Fenetre;nival : in natural) is
    x,y : integer;
    compteur : integer:=1;
  begin
    x:=0;
    y:=50;

    for l in T_Lig'range loop
      x:=x+50;
      for c in T_Col'range loop
        if character'pos(c) mod 2 = l mod 2 then
          AjouterBouton(fen,InitCaseName(l,c),"",x,y,55,55);
        end if;
        x:=x+50;
      end loop;
      x:=0;
      y:=y+50;
    end loop;

    close(f);
    updateGrille(grille,fen);


  end AffichageGrille;

  procedure updateGrille(grille : in TV_Grille; fen : out TR_Fenetre) is

  begin -- updateGrille
    for l in T_Lig'range loop
      for c in T_Col'range loop
        if character'pos(c) mod 2 = l mod 2 then
          if Grille(l,c) = vide then
            changercouleurfond(fen,InitCaseName(l,c),FL_Bottom_Bcol);
          elsif Grille(l,c) = blanc then
            changercouleurfond(fen,InitCaseName(l,c),FL_White);
          elsif Grille(l,c) = jaune then
            changercouleurfond(fen,InitCaseName(l,c),FL_Yellow);
          elsif Grille(l,c) = vert then
            changercouleurfond(fen,InitCaseName(l,c),FL_SpringGreen);
          elsif Grille(l,c) = violet then
            changercouleurfond(fen,InitCaseName(l,c),FL_DarkViolet);
          elsif Grille(l,c) = bleu then
            changercouleurfond(fen,InitCaseName(l,c),FL_DodgerBlue);
          elsif Grille(l,c) = marron then
            changercouleurfond(fen,InitCaseName(l,c),FL_Darktomato);
          elsif Grille(l,c) = rose then
            changercouleurfond(fen,InitCaseName(l,c),FL_DEEPPINK);
          elsif Grille(l,c) = turquoise then
            changercouleurfond(fen,InitCaseName(l,c),FL_DARKCYAN);
          elsif Grille(l,c) = rouge then
            changercouleurfond(fen,InitCaseName(l,c),FL_RED);
          elsif Grille(l,c) = orange then
            changercouleurfond(fen,InitCaseName(l,c),FL_DARKORANGE);
          end if;
        end if;
      end loop;
    end loop;
  end updateGrille;

  function victoire(pseudo : in string) return string is

    -- procedure pour la fenetre Victoire---
    FVictoire: TR_fenetre;

  begin
    ---creation de la fenetre Victoire---

    FVictoire := DebutFenetre("Victoire",600,600);
      AjouterBouton(FVictoire, "BoutonQuitter", "Quitter le jeu",310,550, 100,30);
      AjouterBouton(FVictoire, "BoutonReJouer", "Rejouer",190,550, 100,30);
      AjouterImage(FVictoire,"bebe.xpm","bebe.xpm","",0,0,600,600);
      AjouterTexte(FVictoire, "victoire1","FELICITATIONS " & pseudo & " !!!", 100, 20, 400, 25);
      AjouterTexte(FVictoire, "Victoire2","Vous avez termine le niveau !", 212, 45, 200, 25);
      changertailletexte(FVictoire,"victoire1",FL_Large_Size);
      changerstyletexte(FVictoire,"victoire1",FL_Bold_Style);
    FinFenetre(FVictoire);

    --- Affichage fenetre---
    MontrerFenetre(FVictoire);
    declare
      zbeubito:string:=Attendrebouton(FVictoire);
    begin
      loop
        exit when zbeubito = "BoutonQuitter" or zbeubito = "BoutonReJouer";
      end loop;

      cacherfenetre(FVictoire);
      return zbeubito;

    end;
  end victoire;

  procedure regles is

  ---- procedure pour la fenetre de règle---

  	FRegle: TR_fenetre;

  begin
  	---creation de la fenetre aide---
  	FRegle := DebutFenetre("Regles",350,350);
  	  AjouterBouton(FRegle, "BoutonFermer", "Fermer",140,300, 70,30);
  	  AjouterTexte(FRegle, "regles","     Regles du jeu :", 20, 20, 310, 25);
  	  AjouterTexte(FRegle, "regles2","Il faut deplacer la piece rouge dans le coin", 20, 45, 310, 25);
  	  AjouterTexte(FRegle, "regles3","en haut gauche.", 20, 65, 310, 25);
  	  AjouterTexte(FRegle, "regles4","En un minimum de coups !", 20, 95, 310, 25);
  	  AjouterTexte(FRegle, "regles5","Pour cela, deplacer les autres pieces qui genes", 20, 120, 310, 25);
  	  AjouterTexte(FRegle, "regles6","la piece rouge.", 20, 140, 310, 25);
  	  AjouterTexte(FRegle, "regles7","Mais la/les piece(s) blanche(s) ne bougent pas...", 20, 170, 310, 25);
  	  AjouterTexte(FRegle, "regles8","               Bonne chance a vous !", 20, 270, 310, 25);
  	FinFenetre(FRegle);


  	--- Affichage fenetre---
  	MontrerFenetre(FRegle);

  	loop
  		exit when Attendrebouton(FRegle) = "BoutonFermer";
  	end loop;
    cacherfenetre(FRegle);
  end regles;

end p_vue_graph;
