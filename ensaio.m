function [t,y] = ensaio(tspan, timeSample, amp, delay)
    [t, prs, t_trans, u_trans] = prs_t(amp,delay,timeSample,tspan);
    m = mean(prs);
    mini = min(prs);
    maxi = max(prs);
    disp('minimo: ');
    disp(mini);
    disp('maximo: ');
    disp(maxi);
    disp('media: ');
    disp(m);
    plot(t,prs);
    u_trans
    G = tf([0.0194],[1 0.1312 0.004302]);
    Gd = c2d(G,timeSample);
    [Ad, Bd, Cd, Dd] = tf2ss(Gd.num, Gd.den);
    y = zeros(1,length(t));
    x = y;
    j = 1;
    k = 0;
    sum_y = 0;
    my = 0;
    ii = 1;
	h = 0;
    for i=2:1length(t)
      if(t(i) == t_trans(j))
        my = 0;
        j = j+1;
        ii = i;
		h = 2 + eps;
		k = 1;
      else
        k = k +1;
        sum_y = sum_y + y(i-1); %media do sinal;
        my = sum_y/k
        sy = sqrt((1/k)*sum(y(ii: i-1) - my));% desvio padrao da saida
		if(my > 0)
			h = (sy/my)*100.0;
		else
			warning('saida media do sistema eh zero');
		end	
      end
	  if(h <= 2 && k >2)
		u(i-1) = randNum(-1.02*prs(i-1),1.02*prs(i-1));
	  else
		u(i-1) = prs(i-1);
	  end
      x(i) = Ad*x(i-1) + Bd*u(i-1);
      y(i) = C*x(i-1) + Dd*u(i-1);
    end
    
end