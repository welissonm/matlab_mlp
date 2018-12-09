function y = tansig(n)
  y = 2*logsig(2*n) - ones(size(n));
end