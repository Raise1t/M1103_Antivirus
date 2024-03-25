with p_fenbase; use p_fenbase;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with p_vue_graph; use p_vue_graph;
with p_virus; use p_virus;
with Ada.Strings.Fixed;
with p_vuetxt; use p_vuetxt;
use p_virus.p_coul_io;
use p_virus.p_grille_io;
use p_virus.p_piece_io;
--use p_vue_graph.p_score_io;

procedure av_graph is

  package S renames Ada.Strings;
  package SF renames Ada.Strings.Fixed;

  FAccueil, FJeu: TR_Fenetre;

  pseudo : String(1..20);
  buffer : String(1..3);
  boutonAccueil : String(1..7);
  boutonFin : String(1..13);

  nival : integer := 0;
  grille : TV_grille;
  f : p_piece_io.file_type;
  pieces : TV_pieces;
  lig : integer;
  col : t_col;
  coul_temp,couleur:t_coul;
  dir : T_Direction;
  directionok, dejadeplace, bpossible : boolean := false;

  G_demo:tv_grille;
  P_demo:tv_pieces;
  etap:natural:=0;
  etapemax:constant := 10;
  ok:boolean:=true;

  --variable pour stockage
  fichierScore : p_score_io.file_type;
  content : TR_Highscore;
  listeScore : TV_Highscore;
  i : natural := 1;

begin -- av_graph

  begin
    p_score_io.open(fichierScore, p_score_io.in_file, "highscore");
  -- exception
    -- when NAME_ERROR =>
    --   p_score_io.Create(fichierScore, p_score_io.out_file, "highscore");
    --   p_score_io.reset(fichierScore, p_score_io.out_file);
    --   for i in 1..20 loop
    --     p_score_io.write(fichierScore, ("joueur", 9999));
    --   end loop;
    --   p_score_io.reset(fichierScore, p_score_io.in_file);
  end;

  while not p_score_io.end_of_file(fichierScore) loop
    p_score_io.read(fichierScore, content);
    listeScore(i) := content;
    i := i + 1;
  end loop;



  InitGraph(FAccueil);

  loop

    MontrerFenetre(FAccueil);

    loop -- Attends la pression d'un bouton ou d'un champs. On sort si le bouton quitter ou le bouton jouer ont été pressé
      SF.Move (
        Source  => AttendreBouton(FAccueil),
        Target  => boutonAccueil,
        Drop    => S.Right,
        Justify => S.Left,
        Pad     => S.Space
      );
      exit when boutonAccueil = "Jouer  " or boutonAccueil ="Quitter";
    end loop;

    -- Si on a appuyé sur le bouton jouer
    if boutonAccueil = "Jouer  " then

      SF.Move ( -- Traite le pseudo. S'il est plus petit que 20 caractères, on rempli avec des espaces. Sinon, on le tronque
        Source  => ConsulterContenu(FAccueil, "champPseudo"),
        Target  => pseudo,
        Drop    => S.Right,
        Justify => S.Left,
        Pad     => S.Space
      );

      SF.Move ( -- Même chose qu'au dessus, mais pour le niveau et avec 2 caractères
        Source => ConsulterContenu(FAccueil, "champNival"),
        Target  => buffer,
        Drop    => S.Right,
        Justify => S.Left,
        Pad     => S.Space
      );

      nival := checkJeu(buffer); -- On vérifie si le niveau de jeu entré est correcte

      if nival > 0 then

        -- On cache le message d'erreur pour pas qu'il apparaisse quand on revient sur la page d'accueil
        -- On cache aussi la fenêtre d'accueil pour laisser la place à la fenêtre de jeu
        CacherElem(FAccueil, "messageErreurNival");
        cacherfenetre(FAccueil);


        ----------------------------- PARTIE JEU --------------------------------
        InitFenJeu(Grille,FJeu,nival);
        MontrerFenetre(FJeu);


        while not guerison(grille) loop -- Attends la pression d'un bouton ou d'un champs. On sort si le bouton abandonner a ete presse

          declare
            boutonfjeu:string:=AttendreBouton(Fjeu);
          begin

            if boutonfjeu="boutonrecommencer" then
              InitPartie(grille,pieces);
              open(f,in_file,"Defis.bin");
              configurer(f,nival,grille,pieces);
              close(f);
              updateGrille(grille,fjeu);
              dejadeplace:=false;

            elsif boutonfJeu = "boutonabandonner"then
              ecrire_ligne("Abandon");
              CacherFenetre(FJeu);
              MontrerFenetre(FAccueil);
              exit;

            elsif boutonfjeu="boutonannuler" then

              if dejadeplace then
                annuler_deplacement(grille,dir,coul_temp);
                updateGrille(grille,fjeu);
              else
                ecrire("fdp t'a r dépla_c");
              end if;

            elsif boutonfJeu="boutonregle" then
              regles;

	          elsif boutonfjeu = "demo" then --na marche que avec le niveau 1 lol

	            InitPartie(G_demo,P_demo);
              open(f,in_file,"Defis.bin");
              configurer(f,1,G_demo,P_demo);
              close(f);
	            updategrille(G_demo,fjeu);

		          CacherElem(fjeu, "boutonrecommencer");
		          CacherElem(fjeu, "boutonabandonner");
		          CacherElem(fjeu, "boutonannuler");
		          CacherElem(fjeu, "boutonregle");
		          MontrerElem(fjeu, "suivant");
		          MontrerElem(fjeu, "stop");

              loop
	              declare
                  bdemo:string:=AttendreBouton(Fjeu);

	              begin
                  ok:=false;

                  if bdemo="stop" or etap=etapemax+1 then
	                  exit;
	                elsif bdemo="suivant" then
	                  etap:=etap+1;

	                  if etap = 2 then
	                    MajGrille(G_demo,violet,hg);
                      updateGrille(G_demo,fjeu);
	                  elsif etap = 3 then
	                    MajGrille(G_demo,rouge,bg);
                      updateGrille(G_demo,fjeu);
	                  elsif etap = 4 then
	                    MajGrille(G_demo,rouge,bg);
                      updateGrille(G_demo,fjeu);
	                  elsif etap = 5 then
	                    MajGrille(G_demo,violet,bd);
                      updateGrille(G_demo,fjeu);
	                  elsif etap = 6 then
	                    MajGrille(G_demo,violet,bd);
                      updateGrille(G_demo,fjeu);
	                  elsif etap = 7 then
	                    MajGrille(G_demo,violet,bd);
                      updateGrille(G_demo,fjeu);
	                  elsif etap = 8 then
	                    MajGrille(G_demo,rouge,hd);
                      updateGrille(G_demo,fjeu);
	                  elsif etap = 9 then
	                    MajGrille(G_demo,rouge,hg);
                      updateGrille(G_demo,fjeu);
	                  elsif etap = 10 then
	                    MajGrille(G_demo,rouge,hd);
                      updateGrille(G_demo,fjeu);
	                  elsif etap = 11 then
	                    MajGrille(G_demo,rouge,hg);
                      updateGrille(G_demo,fjeu);
	                  end if;
  		            end if;
	              end;
	            end loop;

              etap:=0;
		          MontrerElem(fjeu, "boutonrecommencer");
		          MontrerElem(fjeu, "boutonabandonner");
		          MontrerElem(fjeu, "boutonannuler");
		          MontrerElem(fjeu, "boutonregle");
	            CacherElem(fjeu, "suivant");
	            -- CacherElem(fjeu, "demo");
              cacherelem(fjeu,"stop");
              updateGrille(grille,fjeu);
              ok:=true;

            elsif ok then

              lig := character'pos(boutonfjeu(boutonfJeu'first+5))-character'pos('0');
              col := boutonfjeu(boutonfJeu'first+6);
              ecrire(lig);ecrire(col);ecrire(t_coul'pos(grille(lig,col)));
              couleur:=grille(lig,col);
              coul_temp:=couleur;

              if t_coul'pos(couleur) in 0..8 then
                if possible(grille,couleur,hg) then
                  MontrerElem(fjeu,"hg");
                  bpossible:=true;
                end if;

                if possible(grille,couleur,hd) then
                  MontrerElem(fjeu,"hd");
                  bpossible:=true;
                end if;
                if possible(grille,couleur,bg) then
                  MontrerElem(fjeu,"bg");
                  bpossible:=true;
                end if;
                if possible(grille,couleur,bd) then
                  MontrerElem(fjeu,"bd");
                  bpossible:=true;
                end if;


              end if;




              --afficherfleche
              directionok:=false;

              if bpossible then
                bpossible:=false;

                loop
                  declare
                    ZBEUB : string := AttendreBouton(FJeu);
                  begin
                    if ZBEUB="hg" then
                      dir := hg;
                      directionok:=true;
                    elsif ZBEUB="hd" then
                      dir := hd;
                      directionok:=true;
                    elsif ZBEUB="bg" then
                      dir := bg;
                      directionok:=true;
                    elsif ZBEUB="bd" then
                      dir := bd;
                      directionok:=true;
                    end if;
                    exit when directionok;
                  end;
                end loop;

                CacherElem(fjeu, "hg");
                CacherElem(fjeu, "hd");
                CacherElem(fjeu, "bg");
                CacherElem(fjeu, "bd");

                if possible(grille,couleur,dir) then
                  MajGrille(grille,couleur,dir);
                  updateGrille(grille,fjeu);
                  dejadeplace:=true;
                else
                  ecrire("impossible");
                end if;
              end if;
            end if;
          end;
        end loop;

        dejadeplace:=false;
        if guerison(grille) then
          -- On affiche l'écran de victoire
          CacherFenetre(fjeu);
          boutonFin := victoire(pseudo);

          if nbcoup < listeScore(nival).score then
            listeScore(nival) := (pseudo, nbcoup);
          end if;

          if boutonFin = "BoutonQuitter" then
            -- Si on clic sur le bouton Quitter Jeu dans l'écran de victoire
            exit;
          end if;
        end if;

          ---------------------------FIN PARTIE JEU ----------------------------

      else -- si la valeur du nival n'est pas correcte
        MontrerElem(FAccueil, "messageErreurNival");
      end if;

    else -- Si on appuie sur le bouton quitter de la page d'accueil
      exit;
    end if;

  end loop;

  p_score_io.reset(fichierScore, p_score_io.out_file);
  for i in 1..20 loop
    p_score_io.write(fichierScore, listeScore(i));
  end loop;

end av_graph;
