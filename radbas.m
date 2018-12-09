function y = radbas(n,varargin)
  if(nargin > 1 && ~isempty(varagin))
    beta = varargin(1);
    if(beta <= 0)
      error('parametro beta deve ser maior que zero');
    end
  else
    beta = 1;
  end
  y = 1./exp(beta*(n.^2));
end