with sequential_io; with p_esiut; use p_esiut;

package body p_virus is


	  procedure InitPartie(Grille : in out TV_Grille; Pieces : in out TV_Pieces) is
	    -- {} => {Tous les éléments de Grille ont été initialisés avec la couleur VIDE, y compris les cases inutilisables
	    --	Tous les élements de Pieces ont été initialisés à false}
	  begin
	    for c in t_col'range loop
	      for l in t_lig'range loop
	        grille(l,c):=VIDE;
	      end loop;
	    end loop;
	    Pieces := (others => false);
	  end InitPartie;
	
	  procedure Configurer(f : in out p_piece_io.file_type; num : in integer; Grille : in out TV_Grille; Pieces : in out TV_Pieces) is
	
	    -- {f ouvert, non vide, num est un numéro de défi
	    --    dans f, un défi est représenté par une suite d'éléments :
	    --    * les éléments d'une même pièce (même couleur) sont stockés consécutivement
	    --    * les deux éléments constituant le virus (couleur rouge) terminent le défi}
	    --             => {Grille a été mis à jour par lecture dans f de la configuration de numéro num
	    --                    Pieces a été mis à jour en fonction des pièces de cette configuration}
	
	    content : TR_ElemP;
	    compteurFinDefi : integer := 0;
	    numDefi : integer := 1;
	    i : natural := 0;
	
	  begin -- Configurer
	
	    reset(f, in_file);
	
	    while not end_of_file(f) and then numDefi /= num loop
	      read(f, content);
	      if content.couleur = rouge and compteurFinDefi = 0 then
	        compteurFinDefi := 1;
	        elsif content.couleur = rouge and compteurFinDefi = 1 then
	          numDefi := numDefi + 1;
	          compteurfindefi:=0;
	        end if;
	      end loop;
	
	      compteurFinDefi := 0;
	
	      while compteurFinDefi < 2 loop
	        read(f, content);
	        Grille(content.ligne, content.colonne) := content.couleur;
	        Pieces(content.couleur) := true;
	
	        if content.couleur = rouge then
	          compteurFinDefi := compteurFinDefi + 1;
	        end if;
	      end loop;
	
	    end Configurer;
	
	    procedure PosPiece(Grille : in TV_Grille; coul : in T_coulP) is
	      -- {} => {la position de la pièce de couleur coul a été affichée, si coul appartient à Grille:
	      --                exemple : ROUGE : F4 - G5}
	      affiche : boolean := false;
	    begin
	      for c in t_col'range loop
	        for l in t_lig'range loop
	          if grille(l,c)=coul then
	            if not affiche then
	              ecrire(coul);
	              ecrire(" : ");
	              affiche := true;
	            end if;
	            ecrire(c);
	            ecrire(l);
	            ecrire(" - ");
	          end if;
	        end loop;
	      end loop;
	      a_la_ligne;
	    end PosPiece;
	
	    function Guerison(grille: in TV_Grille) return boolean is
	      -- {} => {rÃ©sultat = le virus (piÃ¨ce rouge) est prÃªt Ã  sortir (position coin haut gauche)}
	    begin
	      if grille(1,'A')=rouge and grille(2,'B')=rouge then
	        return true;
	      else
	        return false;
	      end if;
	    end Guerison;
	
	    function Possible(Grille : in TV_Grille; coul : in T_CoulP; Dir : in T_Direction) return boolean is
	      -- {coul /= blanc}
	      --    => {resultat = vrai si la pièce de couleur coul peut être déplacée dans la direction Dir}
	      l_dep:integer;
	      c_dep:character;
	      test:boolean:=true;
	    begin
	    for c in t_col'range loop
	      for l in t_lig'range loop
	        if grille(l,c)=coul then
	          if dir = bg then
	          l_dep := l + 1;
	          c_dep := T_Col'pred(c);
	          elsif dir = hg then
	          l_dep := l - 1;
	          c_dep := T_Col'pred(c);
	          elsif dir = bd then
	          l_dep := l + 1;
	          c_dep := T_Col'succ(c);
	          elsif dir = hd then
	          l_dep := l - 1;
	          c_dep := T_Col'succ(c);
	        end if;
	      if grille(l_dep,c_dep) /= vide and grille(l_dep,c_dep) /= coul then test:=false; end if;
	    end if;
	  end loop;
	end loop;
	return test;
	exception
	  when CONSTRAINT_ERROR => return false;
	end Possible;
	
	procedure MajGrille(Grille : in out TV_Grille; coul : in T_CoulP; Dir : in T_Direction) is
	  -- {la pièce de couleur coul peut être déplacée dans la direction Dir}
	  --    => {Grille a été mis à jour suite au deplacement}
	
	begin
	  if dir=bg then
	    for c in t_col'range loop
	      for l in t_lig'range loop
	        if grille(l,c)=coul then
	          grille(l+1,t_col'pred(c)) := grille(l,c);
	          grille(l,c) := vide;
	        end if;
	      end loop;
	    end loop;
	  end if;
	
	  if dir=hg then
	    for c in t_col'range loop
	      for l in t_lig'range loop
	        if grille(l,c)=coul then
	          grille(l-1,t_col'pred(c)) := grille(l,c);
	          grille(l,c) := vide;
	        end if;
	      end loop;
	    end loop;
	  end if;
	
	  if dir=bd then
	    for c in reverse t_col'range loop
	      for l in reverse t_lig'range loop
	        if grille(l,c)=coul then
	          grille(l+1,t_col'succ(c)) := grille(l,c);
	          grille(l,c) := vide;
	        end if;
	      end loop;
	    end loop;
	  end if;
	
	  if dir=hd then
	    for c in reverse t_col'range loop
	      for l in reverse t_lig'range loop
	        if grille(l,c)=coul then
	          grille(l-1,t_col'succ(c)) := grille(l,c);
	          grille(l,c) := vide;
	        end if;
	      end loop;
	    end loop;
	  end if;
	end MajGrille;
	
end p_virus;
