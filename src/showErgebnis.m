function erg = showErgebnis(para,merkmal)
% ****************************************************************
% ---------------------------- Endergebnisse --------------------------------
% ***************************************************************************

%------------------------ Daten anschauen
if para.ShowDetails
    fprintf(['Final result ---------\n1.  Porositaet = ', num2str(merkmal.porenraum.porositaet), ' %%\n']);
    fprintf(['2.  Spezifische Oberflaeche = ' num2str(merkmal.SpezOberf) ' [m2/m3]\n']);
    fprintf(['3.  Anzahl der Objekte = ' num2str(merkmal.ObjektAnzahl) '\n']);
    fprintf(['4.  Knotenanzahl (Ausschnitt) = ' num2str(merkmal.steg.anzahlKnoten) ', davon ' num2str(merkmal.steg.endKnoten) '%% Endpunkte, ' num2str(merkmal.steg.dreiKnoten) '%% Knoten mit 3 Stegen, ' num2str(merkmal.steg.vierKnoten)  '%% mit 4 Stegen, ' num2str(merkmal.steg.fuenfKnoten)  '%% mit 5 Stegen\n']);
    fprintf(['5.  Durchschnittliche Knotenlaenge (Ausschnitt) = ' num2str(merkmal.steg.lengthKnoten) '\n']);
    fprintf(['6.  Porengroesse = ' num2str(merkmal.porenraum.porengroesse),' mit ', num2str(merkmal.porenraum.porengroesse) ' %%\n']);
    fprintf(['7.  Stegorientierung: ' num2str(merkmal.steg.orientation(1)),'%% in x-Richtung, ', num2str(merkmal.steg.orientation(2)) '%% in y-Richtung,' num2str(merkmal.steg.orientation(3))  '%% in z-Richtung \n']);

end
% ------------------------ 3D-Darstellung

% ------------------------ Werte zurueckgeben:
if para.switchMode == 1
    erg = {merkmal.porenraum.porositaet, merkmal.SpezOberf, merkmal.ObjektAnzahl, merkmal.steg.anzahlKnoten, merkmal.steg.endKnoten, merkmal.steg.dreiKnoten, merkmal.steg.vierKnoten, merkmal.steg.fuenfKnoten, merkmal.steg.lengthKnoten, merkmal.porenraum.porengroesse, merkmal.porenraum.porengroesse_prozent,merkmal.steg.orientation(1),merkmal.steg.orientation(2),merkmal.steg.orientation(3)};
else 
    erg = [merkmal.porenraum.porositaet, merkmal.SpezOberf, merkmal.ObjektAnzahl, merkmal.steg.anzahlKnoten, merkmal.steg.endKnoten, merkmal.steg.dreiKnoten, merkmal.steg.vierKnoten, merkmal.steg.fuenfKnoten, merkmal.steg.lengthKnoten, merkmal.porenraum.porengroesse, merkmal.porenraum.porengroesse_prozent,merkmal.steg.orientation(1),merkmal.steg.orientation(2),merkmal.steg.orientation(3)];
end

end