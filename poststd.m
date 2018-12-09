 function [Pp,Tt] = poststd(Pn,meanp,stdP,Tn,meanT,stdT)
  [np,mp] = size(Pn);
  Pp = zeros(np,mp);
  for i=1:np
    Pp(i,:) = (Pn(i,:) + meanp(i,1))*stdP(i,1);
  end
  [nt,mt] = size(Tn);
  Tt = zeros(nt,mt);
  for i=1:nt
    Tt(i,:) = (Tn(i,:) + meanT(i,1))*stdT(i,1);
  end
 end