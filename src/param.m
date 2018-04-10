function output = param
% ****************************************************************
% ----------------------  Parameter einstellen ------------------------------
% ***************************************************************************

% ------------------------ Parameterpool
% Wenn der Parameterpool verwendet wird, werden alle Kombinationen des
% parameterpools durchgerechnet.
output.switchParampool    = 0;
output.pool.Kth        = 0.8:0.1:1.0;
output.pool.Elementsize= 2:1:3;
output.pool.MinVolume  = 1:10:20;

% ------------------------ Parameter von Umgebung
output.dataTyp         = 0;        % 1 :CLSM  0:CT   2:Generierte Struktur manipuliert 
output.Zyklen          = 1;       % Anzahl von Wiederholung der for-Schleife
output.SwitchBaSiC     = 0;     % BaSic filter (Bildvorverarbeitung)
output.SwitchVolume    = 1;     % Volumen Filter
output.SwitchPorenV    = 0;    % Porenverteilung
output.switchDOG       = 1; 
output.ShowDetails     = 1;     % Anzeigen des aktuellen Zustand 
output.Elementsize     = 3;        % Groe?e der Strukturelement, Einheit [voxel]
output.scaling         = 1;        % Massstab x,y
output.spacing         = 1;        % Massstab z  
output.MinVolume       = 100;       % Min. Volumen von Volumenfilter
output.skip            = 1;        % Bild neu aufbauen
output.skip_thresh     = 10;
output.Kth             = 0.8;      % multi. coeff. to threshhold adjustment
output.Kp              = 1.3;      % Propotionscoeffizient der Regelung
output.Ki              = 0.1 ;       % I Glied der Regler
output.ab              = 0.005;    % Abbruch Schwellwert
% ------------------------ Bilddrehung und Bildbeschneidung
output.switchRotCut    = 1;
output.rot             = 0;        % Rotation
output.x1              = 501;
output.x2              = 700;     % default: end
output.y1              = 501;
output.y2              = 700;     % default: end
output.z1              = 11;
output.z2              = 210;
% ------------------------ Sollwert
output.porositaet_soll = 0.8;
% ------------------------ Initialization
output.diff_sum        = 0;        % Integral von Porositaetsabweichung   

%% Bildstapel laden:
if output.dataTyp == 1
    output.datapath = 'C:\Users\fuxia\Documents\Thesis\code\prototyp\Data\img_stack.mat';
    fprintf(['Datetype: ','CLSM\n']);
elseif output.dataTyp == 2
    output.datapath = 'D:\Projekte\Poroese_Materialien\Data\Vorverarbeitet\GenerierteStrukturen\GenerierteStrukturen_DOG1.mat';
    fprintf(['Datetype: ','Generierte Struktur 1 manipuliert\n']);    
else
    output.datapath = 'C:\Users\fuxia\Documents\Thesis\code\prototyp\Data\img_stack_CT.mat';
    fprintf(['Datetype: ','CT\n']);

end

%% Parameterpool generieren:
if output.switchParampool == 1
    poolCell = struct2cell(output.pool);
    output.combinations = poolCell{1};
    for i = 1:size(poolCell,1)-1
        y = repmat(output.combinations',size(poolCell{i+1},2),1)';
        z = reshape(repmat(poolCell{i+1},size(output.combinations,2),1),1,[]);
        output.combinations = [y; z];
    end
    clear i y z poolCell;
end