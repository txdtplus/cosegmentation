function y = Dp(Ic,T,lp)
% Ic is difference image
% T is threshold
% lp is 'fg' or 'bg'

if strcmp(lp,'fg')
    y = -log(Ic/(2*T));
elseif strcmp(lp,'bg')
    y = -log(1 - Ic/(2*T));
else
    error('lp must be ''fg'' or ''bg'' !');
end
end

