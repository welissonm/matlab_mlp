function y = logsig(n)
  den = ones(size(n)) + exp(n);
  y = 1./den;
end