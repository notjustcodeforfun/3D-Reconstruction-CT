function output = param
% ****************************************************************
% ----------------------  Parameter einstellen ------------------------------
% ***************************************************************************


% ------------------------ Parameter von Umgebung
output.dataTyp         = 1;        % 1 :CLSM  0:CT    
output.Zyklen          = 1;       % Anzahl von Wiederholung der for-Schleife
output.SwitchBaSiC     = true;     % BaSic filter (Bildvorverarbeitung)
output.SwitchVolume    = true;     % Volumen Filter
output.SwitchPorenV    = false;    % Porenverteilung
output.ShowDetails     = true;     % Anzeigen des aktuellen Zustand 
output.Elementsize     = 3;        % Groe?e der Strukturelement, Einheit [voxel]
output.scaling         = 1;        % Massstab x,y
output.spacing         = 1;        % Massstab z  
output.MinVolume       = 100;       % Min. Volumen von Volumenfilter
output.skip            = 1;        % Bild neu aufbauen
output.skip_thresh     = 10;
output.Kth             = 1.2;      % multi. coeff. to threshhold adjustment
output.Kp              = 1.3;      % Propotionscoeffizient der Regelung
output.Ki              = 0.1 ;       % I Glied der Regler
output.ab              = 0.005;    % Abbruch Schwellwert
% ------------------------ Bilddrehung und Bildbeschneidung
output.rot             = 0;        % Rotation
output.x1              = 1;
output.x2              = 1024;     % default: end
output.y1              = 1;
output.y2              = 1024;     % default: end
% ------------------------ Sollwert
output.porositaet_soll = 0.8;
% ------------------------ Initialization
output.diff_sum        = 0;        % Integral von Porositaetsabweichung   

if output.dataTyp
    output.datapath = 'img_stack.mat';
    fprintf(['Datetype: ','CLSM\n']);
else
    output.datapath = 'img_stack_CT.mat';
    fprintf(['Datetype: ','CT\n']);

end