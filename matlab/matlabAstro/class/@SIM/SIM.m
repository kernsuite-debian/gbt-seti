%--------------------------------------------------------------------------
% SIM class                                                          class
% Description: A class of structure array of images (SIM)
% Input  : null
% Output : null
% Tested : Matlab R2014a
%     By : Eran O. Ofek                    Nov 2014
%    URL : http://weizmann.ac.il/home/eofek/matlab/
% Reliable: 2
%--------------------------------------------------------------------------

classdef SIM
    properties (SetAccess = public)
        Im            
        Header        
        ImageFileName = '';
        Mask          
        BackIm        
        ErrIm
        WeightIm
        Cat
        Col
        ColCell
        UserData
        %CatPSF
    end
    %properties (Hidden = true)
    %    mean1
    %end
    methods

        function obj=issim(Sim)
            obj = true;
        end


        % See list of functions
        % http://www.mathworks.com/help/matlab/matlab_oop/implementing-operators-for-your-class.html

        %--- Unary functions ---
        function obj=plus(Sim1,Sim2)
            % +
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','+');
        end

        function obj=minus(Sim1,Sim2)
            % -
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','-');            
        end

        function obj=uminus(Sim)
            % unary -1
            obj = sim_imarith('In1',Sim,'In2',-1,'Op','.*');            
        end

        function obj=uplus(Sim)
            % unary +1
  	    obj = Sim;
        end

        function obj=times(Sim1,Sim2)
            % .*
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','.*');
        end

        function obj=mtimes(Sim1,Sim2)
            % *
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','*');
        end

        function obj=rdivide(Sim1,Sim2)
            % ./
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','./');
        end

        function obj=power(Sim1,Sim2)
            % .^
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','.^');
        end

        function obj=mpower(Sim1,Sim2)
            % ^
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','^');
        end

        function obj=lt(Sim1,Sim2)
            % <
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','<');
        end

        function obj=gt(Sim1,Sim2)
            % >
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','>');
        end

        function obj=le(Sim1,Sim2)
            % <=
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','<=');
        end

        function obj=ge(Sim1,Sim2)
            % >=
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','>=');
        end

        function obj=ne(Sim1,Sim2)
            % ~=
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','~=');
        end

        function obj=eq(Sim1,Sim2)
            % ==
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','==');
        end

        function obj=and(Sim1,Sim2)
            % &
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','&');
        end

        function obj=or(Sim1,Sim2)
            % |
            obj = sim_imarith('In1',Sim1,'In2',Sim2,'Op','|');
        end

        function obj=not(Sim)
            % ~
            obj = sim_ufun(Sim,'Op',@not);
        end

        function obj=ctranspose(Sim)
            % '
            obj = sim_flip(Sim,'Op',@ctranspose);
        end

        function obj=transpose(Sim)
            % .'
            obj = sim_flip(Sim,'Op',@transpose);
        end

        function obj=sqrt(Sim)
            % sqrt
            obj = sim_ufun(Sim,'Op',@sqrt);
        end
        
        function obj=sin(Sim)
            % sin
            obj = sim_ufun(Sim,'Op',@sin);
        end

        function obj=cos(Sim)
            % cos
            obj = sim_ufun(Sim,'Op',@cos);
        end

        function obj=tan(Sim)
            % tan
            obj = sim_ufun(Sim,'Op',@tan);
        end

        function obj=asin(Sim)
            % asin
            obj = sim_ufun(Sim,'Op',@asin);
        end

        function obj=acos(Sim)
            % acos
            obj = sim_ufun(Sim,'Op',@acos);
        end

        function obj=atan(Sim)
            % atan
            obj = sim_ufun(Sim,'Op',@atan);
        end

        function obj=exp(Sim)
            % exp
            obj = sim_ufun(Sim,'Op',@exp);
        end
        
        function obj=log(Sim)
            % log
            obj = sim_ufun(Sim,'Op',@log);
        end

        function obj=log10(Sim)
            % log10
            obj = sim_ufun(Sim,'Op',@log10);
        end
        
        function obj=fft(Sim)
            % fft
            obj = sim_fft(Sim,'Op',@fft2);
        end
        
        function obj=ifft(Sim)
            % ifft
            obj = sim_fft(Sim,'Op',@ifft2);
        end
        
        function obj=round(Sim)
            % round
            obj = sim_ufun(Sim,'Op',@round);
        end

        function obj=ceil(Sim)
            % ceil
            obj = sim_ufun(Sim,'Op',@ceil);
        end
        
        function obj=floor(Sim)
            % floor
            obj = sim_ufun(Sim,'Op',@floor);
        end
        
        function obj=fix(Sim)
            % fix
            obj = sim_ufun(Sim,'Op',@fix);
        end
        
        function obj=real(Sim)
            % real
            obj = sim_ufun(Sim,'Op',@real);
        end
        
        function obj=imag(Sim)
            % imag
            obj = sim_ufun(Sim,'Op',@imag);
        end
        
        function obj=abs(Sim)
            % abs
            obj = sim_ufun(Sim,'Op',@abs);
        end
        
        function obj=angle(Sim)
            % angle
            obj = sim_ufun(Sim,'Op',@angle);
        end
        
        function obj=conj(Sim)
            % conj
            obj = sim_ufun(Sim,'Op',@conj);
        end
        
        
        %--- Binary functions ---
        function obj=atan2(Sim1,Sim2)
            % atan2
            obj = sim_imarith('In1',Sim1,'In2',Sim2','Op',@atan2);
        end

        %--- Scalar output functions ---
        function obj=sum(Sim)
            % sum
            obj = sim_ufunv(Sim,'Op',@sum,'NaN',false);
        end

        function obj=nansum(Sim)
            % nansum
            obj = sim_ufunv(Sim,'Op',@sum,'NaN',true);
        end

        function obj=mean(Sim)
            % mean
            obj = sim_ufunv(Sim,'Op',@mean,'NaN',false);
        end

        function obj=nanmean(Sim)
            % nanmean
            obj = sim_ufunv(Sim,'Op',@mean,'NaN',true);
        end

        function obj=median(Sim)
            % median
            obj = sim_ufunv(Sim,'Op',@median,'NaN',false);
        end

        function obj=nanmedian(Sim)
            % nanmedian
            obj = sim_ufunv(Sim,'Op',@median,'NaN',true);
        end

        function obj=std(Sim,varargin)
            % std
            obj = sim_ufunv(Sim,'Op',@std,'NaN',false,'Par',varargin);
        end

        function obj=nanstd(Sim,varargin)
            % nanstd
            obj = sim_ufunv(Sim,'Op',@std,'NaN',true,'Par',varargin);
        end

        function obj=var(Sim)
            % var
            obj = sim_ufunv(Sim,'Op',@var,'NaN',false);
        end

        function obj=nanvar(Sim)
            % nanvar
            obj = sim_ufunv(Sim,'Op',@var,'NaN',true);
        end

        function obj=min(Sim)
            % min
            obj = sim_ufunv(Sim,'Op',@min,'NaN',false);
        end

        function obj=nanmin(Sim)
            % nanmin
            obj = sim_ufunv(Sim,'Op',@min,'NaN',true);
        end

        function obj=max(Sim)
            % max
            obj = sim_ufunv(Sim,'Op',@max,'NaN',false);
        end

        function obj=nanmax(Sim)
            % nanmax
            obj = sim_ufunv(Sim,'Op',@max,'NaN',true);
        end

        function obj=mode(Sim)
            % mode using mode_image
            obj = sim_ufunv(Sim,'Op',@mode_image,'NaN',false);
        end

        function obj=nanmode(Sim)
            % nanmode using mode_image
            obj = sim_ufunv(Sim,'Op',@mode_image,'NaN',true);
        end

        function obj=skeness(Sim)
            % skewness
            obj = sim_ufunv(Sim,'Op',@skewness,'NaN',false);
        end

        function obj=nanskeness(Sim)
            % nanskewness
            obj = sim_ufunv(Sim,'Op',@skewness,'NaN',true);
        end

        function obj=kurtosis(Sim)
            % kurtosis
            obj = sim_ufunv(Sim,'Op',@kurtosis,'NaN',false);
        end

        function obj=nankurtosis(Sim)
            % nankurtosis
            obj = sim_ufunv(Sim,'Op',@kurtosis,'NaN',true);
        end

        function obj=moment(Sim,varargin)
            % moment
            obj = sim_ufunv(Sim,'Op',@moment,'NaN',false,'Par',varargin);
        end

        function obj=nanmoment(Sim,varargin)
            % nanmoment
            obj = sim_ufunv(Sim,'Op',@moment,'NaN',true,'Par',varargin);
        end

        function obj=prctile(Sim,P)
            % prctile (ignoring NaN)
            obj = sim_ufunv(Sim,'Op',@prctile,'NaN',true,'Par',P);
        end

        function obj=quantile(Sim,P)
            % quantile (ignoring NaN)
            obj = sim_ufunv(Sim,'Op',@quantile,'NaN',true,'Par',P);
        end

        function obj=iqr(Sim)
            % iqr (ignoring NaN)
            obj = sim_ufunv(Sim,'Op',@iqr,'NaN',true);
        end

        function [JD,ExpTime,obj] = julday(Sim)
            % julday
            [JD,ExpTime,obj] = sim_julday(Sim);
        end
        
        function [N,X]=hist(Sim,varargin)
            % hist 
            if (numel(Sim)>1),
                error('hist is defined for a single SIM class image');
            end
            [N,X] = hist(Sim.Im(:),varargin)
        end
        
        function [N,X]=histc(Sim,varargin)
            % histc
            if (numel(Sim)>1),
                error('histc is defined for a single SIM class image');
            end
            [N,X] = histc(Sim.Im(:),varargin)
        end
        
        

        %--- Structre functions ---
        function obj=isfield(Sim,Field)
            % isfield 
            obj = any(strcmp(fieldnames(Sim),Field));
        end

        function obj=isstruct(Sim)
            obj = true;  %isstruct(Sim) || isa(Sim,'SIM');
        end

        
       
        %--- get functions ---
        %function obj=get.mean1(Sim)
        %    % mean
        %    obj = sim_ufunv(Sim,'Op',@mean,'NaN',false);        
        %end
    end
end

            
