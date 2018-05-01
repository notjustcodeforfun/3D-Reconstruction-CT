function filename_end = callPool(para,img_stack_after,startzeit)
% Erste Zeile Auswertungstabelle generieren: 
    evaluation = {'Probe:'};
    parameterNames = fieldnames(para.pool); %Namen der Parameter im Modellpool
    filename = split(para.datapath, '.'); %Filename f .xlsx erzeugen.
    for i = 1:numel(parameterNames) 
        evaluation{end+1} = parameterNames{i};
    end
    evaluation = [evaluation, 'Porositaet:', 'Spezifische Oberflaeche:', 'Anzahl Objekte:', 'Knotenanzahl:', 'Endpunkte %:', '3 Stege %:', '4 Stege %:', '5 Stege %:', 'Durchschnittliche Steglaenge:'];
    
    % Berechnen aller Kombinationen
    for i = 1:length(para.combinations)
        % Neue Parameter der Berechnung zuweisen und in Auswertungstabelle
        % speichern
        evaluationDatarow = {para.datapath};
        for j = 1:numel(parameterNames)
            para.(parameterNames{j}) = para.combinations(j,i); 
            evaluationDatarow = [evaluationDatarow, para.combinations(j,i)];
        end
        img_bin = bildverarbeitung(img_stack_after, para);
        merkmal = merkmalExtraktion(img_bin, para);
        % Ergebnisse hinzufuegen
        evaluationDatarow = [evaluationDatarow, showErgebnis(img_bin,para,merkmal)];
        evaluation = [evaluation; evaluationDatarow];

        % Fortschritt dokumentieren!
        if mod(i,10) == 0
            fprintf("%i/%i gerechnet!\n",i,size(para.combinations,2));
            %Als xls speichern
            xlswrite(strcat(filename{1}, '_', startzeit,'.xlsx'), evaluation);
        end
    end
    filename_end = strcat(filename{1}, '_', startzeit,'.xlsx');
    xlswrite(filename_end, evaluation);
    paraCell = fieldnames(para);
    paraCell = [paraCell, struct2cell(para)];
    xlswrite(filename_end, paraCell, 'Parameters');
end