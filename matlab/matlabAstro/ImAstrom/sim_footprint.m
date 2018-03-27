function [Out,Sim]=sim_footprint(Sim,varargin)
%--------------------------------------------------------------------------
% sim_footprint function                                          ImAstrom
% Description: Return the footprint (verteces of images footprint) and
%              center for a list of images.
% Input  : - SIM image, fits images and more. See images2sim.m for
%            options.
%          * Arbitrary number of pairs of arguments: ...,keyword,value,...
%            where keyword are one of the followings:
%            'CCDSEC' - The CCD section. This can be an header keyword
%                       string from which to obtain the CCDSEC,
%                       or a CCDSEC vector [xmin xmax ymin ymax].
%                       Alternativelly, if empty will use the actual image
%                       size to estimate CCDSEC.
%                       Default is empty.
%            'OutUnits' - Output coordinates units {'rad'|'deg'}.
%                       Default is 'rad'.
%            --- Additional parameters
%            Any additional key,val, that are recognized by one of the
%            following programs:
%            images2sim.m, image2sim.m
% Output : - Structure containing the footprints long/lat.
%            The following fields are available:
%            .FootLong - Vector of footprints longitude.
%            .FootLat  - Vector of footprints latitude.
%            .CenLong  - Center longitude.
%            .CenLat   - Center latitude.
%            .GcenLong - Geometric center longitude.
%            .GcenLat  - Geometric center latitude.
%            .Radius   - Distance between geometric center and furtest
%                        corner.
%          - SIM images.
% Tested : Matlab R2014a
%     By : Eran O. Ofek                    Feb 2015
%    URL : http://weizmann.ac.il/home/eofek/matlab/
% Example: [Out,Sim]=sim_footprint('*.fits');
% Reliable: 2
%--------------------------------------------------------------------------
RAD = 180./pi;

ImageField     = 'Im';
HeaderField    = 'Header';
%FileField      = 'ImageFileName';
%MaskField      = 'Mask';
%BackImField    = 'BackIm';
%ErrImField     = 'ErrIm';
%WeightImField  = 'WeightIm';


DefV.CCDSEC           = [];   % [], or [xmin xmax ymin ymax] or string
DefV.OutUnits         = 'rad';
InPar = set_varargin_keyval(DefV,'n','use',varargin{:});

switch lower(InPar.OutUnits)
    case 'rad'
        ConvUnits = 1;
    case 'deg'
        ConvUnits = RAD;
    otherwise
        error('Unknown OutUnits option');
end


% read images
Sim = images2sim(Sim,varargin{:});
Nim = numel(Sim);

Out = struct('FootLong',cell(Nim,1),'FootLat',cell(Nim,1),...
             'CenLong',cell(Nim,1),'CenLat',cell(Nim,1),...
             'GcenLong',cell(Nim,1),'GcenLat',cell(Nim,1));
for Iim=1:1:Nim,
    % get CCDSEC
    if (isempty(InPar.CCDSEC)),
        % use image footprints
        Size = size(Sim(Iim).(ImageField));
        CCDSEC = [1 Size(2) 1 Size(1)];
    else
        if (isnumeric(InPar.CCDSEC)),
            CCDSEC = InPar.CCDSEC;
        elseif (ischar(InPar.CCDSEC)),
            % get CCDSEC from header
            CCDSEC = get_ccdsec_head(Sim(Iim).(HeaderField),InPar.CCDSEC);
        else
            error('Illegal CCDSEC input type');
        end
    end
    
    % calculate footprints
    X  = CCDSEC([1 2 2 1]);
    Y  = CCDSEC([3 3 4 4]);
    CX = 0.5.*(CCDSEC(1)+CCDSEC(2));
    CY = 0.5.*(CCDSEC(3)+CCDSEC(4));
    [Long,Lat] = xy2sky(Sim(Iim),[X CX].',[Y CY].');
    [CD1,CD2,CD3] = coo2cosined(Long,Lat);
    MeanCD1 = mean(CD1(1:4));
    MeanCD2 = mean(CD2(1:4));
    MeanCD3 = mean(CD3(1:4));
    
    [MeanLong,MeanLat] = cosined2coo(MeanCD1,MeanCD2,MeanCD3);
    
    Out(Iim).FootLong = Long(1:4).*ConvUnits;
    Out(Iim).FootLat  = Lat(1:4).*ConvUnits;
    Out(Iim).CenLong  = Long(5).*ConvUnits;
    Out(Iim).CenLat   = Lat(5).*ConvUnits;
    Out(Iim).GcenLong = MeanLong.*ConvUnits;
    Out(Iim).GcenLat  = MeanLat.*ConvUnits;
    % radius of circle (center to corner)
    Out(Iim).Radius   = max(sphere_dist_fast(MeanLong,MeanLat,Long(1:4),Lat(1:4))).*ConvUnits;
end

            
