with p_fenbase, forms, p_virus, ada.calendar,p_esiut;
use p_fenbase, forms, p_virus, ada.calendar,p_esiut;
with sequential_io; use p_virus.p_piece_io; use p_virus.p_grille_io;

package p_vue_graph is

  -- Pr fichier stockage score
  type TR_Highscore is record
    pseudo : string(1..20);
    Score : natural;
  end record;
  Type TV_Highscore is array(natural) of TR_Highscore;
  package p_score_io is new sequential_io(TR_Highscore); use p_score_io;

  procedure AffichageGrille(Grille : in out TV_Grille;fen: out TR_Fenetre;Nival: in natural);

  function checkJeu(diff : in String) return integer;
    -- Fonction qui permet de check si le niveau entré est correct

  function InitCaseName(l: in T_Lig;c: in T_Col) return string;

  procedure InitGraph(FAccueil : in out TR_Fenetre);
    -- La fonction pour dessiner les fenêtres

  procedure updateGrille(grille : in TV_Grille; fen : out TR_Fenetre);
    --mise a jour de la grille

  procedure InitFenJeu (Grille : in out TV_Grille; fen : out TR_Fenetre;nival : in natural);

  function victoire(pseudo : in string) return string;
    -- Affiche la fenêtre de victoire

  procedure regles;

end p_vue_graph;
