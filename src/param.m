function output = param(datatyp)
% ****************************************************************
% ----------------------  Parameter einstellen ------------------------------
% ***************************************************************************

%% ------------------------ Tool einstellen
output.switchMode               = 0;             % 0: PID Regler, 1: Pool Berechnung, 2: Genetische Algorithmus
if nargin == 0
    output.dataTyp              = 1;             % 1 :CLSM  0:CT   2:Generierte Struktur manipuliert (manuell einstellen)

else
    output.dataTyp              = datatyp;
end

%% ------------------------ PID Regeler (output.switchMode == 0)
output.Zyklen                   = 1;             % Anzahl von Wiederholung der for-Schleife
output.Kth                      = 1;           % multi. coeff. to threshhold adjustment
output.Kp                       = 1;           % Propotionscoeffizient der Regelung
output.Ki                       = 0.1 ;          % I Glied der Regler
output.ab                       = 0.005;         % Abbruch Schwellwert
output.ShowDetails              = 0;             % Anzeigen des aktuellen Zustand (Porositaet)

%% ------------------------ Parameterpool (output.switchMode == 1)
% Wenn der Parameterpool verwendet wird, werden alle Kombinationen des
% parameterpools durchgerechnet.
output.pool.Kth                 = 0.1:0.1:3;
output.pool.Elementsize         = 1:1:5;
output.pool.MinVolume           = 10:30:800;

%% ------------------------ Genetic Algorithm (output.switchMode == 2)
output.genetic.pop_size         = 4;            % Bevoelkerung
output.genetic.generation_size  = 3;            % Generation
output.genetic.cross_rate       = 0.85;          % Cross-over Wahrscheinlichkeit
output.genetic.mutate_rate      = 0.01;         % Mutation Wahrscheinlichkeit
output.genetic.elitism          = 1;            % 1 fuer Elitismus
output.genetic.ShowDetails      = 1;
%% ------------------------ Sollwert (optimal)
output.soll.porositaet          = 80;           % [%]
output.soll.nodesEnd            = 20;           % [%]
output.soll.lLink               = 15;
output.soll.nObjects            = 30;
output.soll.sizePoren           = 10;

output.factors.porositaet       = 1;
output.factors.nodesEnd         = 0.05;
output.factors.lLink            = 0.5;
output.factors.nObjects         = 0.05;
output.factors.sizePoren        = 0.5;
%% ------------------------ Parameter von Umgebung
output.switchResolution         = 1;             % Aufloesung anpassen
output.sigma_gauss              = 5;
output.SwitchVolume             = 1;             % Volumen Filter
output.SwitchPorenV             = 0;             % Porenverteilung berechnen
output.switchDOG                = 0; 
output.Elementsize              = 5;             % Groesse der Strukturelement, Einheit [voxel]
output.scaling                  = 0.075;             % Massstab x,y
output.spacing                  = 0.075;             % Massstab z  
output.MinVolume                = 0;           % Min. Volumen von Volumenfilter
output.skip                     = 1;             % Bild neu aufbauen
output.skip_thresh              = 10;

% ------------------------ Bilddrehung und Bildbeschneidung
output.switchRotCut             = 1;
output.rot                      = 0;             % Rotation
output.x1                       = 501;
output.x2                       = 700;           % default: end
output.y1                       = 501;
output.y2                       = 700;           % default: end
output.z1                       = 1;
output.z2                       = 200;

%% Bildstapel laden:
if output.dataTyp == 1
    output.datapath = 'C:\Users\fuxia\Documents\Thesis\code\prototyp\Data\img_stack.mat';
    output.resolution               = 240;            % die Aufloesung des Bildes, [nm]
    fprintf(['Datetype: ','CLSM ','Aufloesung: ', num2str(output.resolution) ' nm\n']);
    
elseif output.dataTyp == 2
    output.datapath = 'D:\Projekte\Poroese_Materialien\Data\Vorverarbeitet\GenerierteStrukturen\GenerierteStrukturen_DOG1.mat';
    fprintf(['Datetype: ','Generierte Struktur 1 manipuliert\n']);    
else
    output.datapath = 'C:\Users\fuxia\Documents\Thesis\code\prototyp\Data\img_stack_CT660.mat';
    output.resolution               = 75;            % die Aufloesung des Bildes, [nm]     
    fprintf(['Datetype: ','CT ','Aufloesung: ', num2str(output.resolution) ' nm\n']);
end

%% Parameterpool generieren:
if output.switchMode == 1
    poolCell = struct2cell(output.pool);
    output.combinations = poolCell{1};
    for i = 1:size(poolCell,1)-1
        y = repmat(output.combinations',size(poolCell{i+1},2),1)';
        z = reshape(repmat(poolCell{i+1},size(output.combinations,2),1),1,[]);
        output.combinations = [y; z];
    end
end