function output = param
% ****************************************************************
% ----------------------  Parameter einstellen ------------------------------
% ***************************************************************************


% ------------------------ Parameter von Umgebung
output.dataTyp         = 0;         % 1 :CLSM  0:CT    
output.Zyklen          = 10;        % Anzahl von Wiederholung der for-Schleife
output.SwitchVolume    = true;     % Volumen Filter
output.SwitchPorenV    = false;    % Porenverteilung
output.ShowDetails     = true;     % Anzeigen des aktuellen Zustand 
output.SwitchVTK       = false;
output.Elementsize     = 3;        % Gr??e der Strukturelement, Einheit [voxel]
output.scaling         = 1;        % Massstab x,y
output.spacing         = 1;        % Massstab z  
output.MinVolume       = 10;       % Min. Volumen von Volumenfilter
output.por             = 1;        % Anteil des zu verwendenen Pixel
output.skip            = 1;        % Bild neu aufbauen
output.skip_thresh     = 10;
output.Kth             = 1.0;        % multi. coeff. to threshhold adjustment
output.Kp              = 1.2;      % Propotionscoeffizient der Regelung
output.Ki              = 0.0;      % I Glied der Regler
output.ab              = 0.005;    % Abbruch Schwellwert
% ------------------------ Sollwert
output.porositaet_soll = 0.8;
% ------------------------ Initialization
output.diff_sum        = 0;        % Integral von Porositaetsabweichung   

if output.dataTyp
    output.datapath = 'img_stack.mat';
else
    output.datapath = 'img_stack_CT.mat';
end