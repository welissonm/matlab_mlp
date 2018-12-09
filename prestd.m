function [pn,meanp,stdp,tn,meant,stdt] = prestd(p,t)
  [np,mp] = size(p);
  pn = zeros(np,mp);
  meanp = zeros(np,1);
  stdp = zeros(np,1);
  for i=1:np
    meanp(i,1) = mean(p(i,:));
    stdp(i,1) = sqrt(var(p(i,:)));
    pn(i,:) = (p(i,:) - meanp(i,1))/stdp(i,1);
  end
  [nt,mt] = size(t);
  tn = zeros(nt,mt);
  meant = zeros(nt,1);
  stdt = zeros(nt,1);
  for i=1:nt
    meant(i,1) = mean(t(i,:));
    stdt(i,1) = sqrt(var(t(i,:)));
    tn(i,:) = (t(i,:) - meant(i,1))/stdt(i,1);
  end
end