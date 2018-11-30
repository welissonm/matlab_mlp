function [t,y] = ensaio(tspan, timeSample, amp, delay)
    [t, prs, t_trans, u_trans] = prs_t(amp,delay,timeSample,tspan);
    t_trans
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
    Gd = c2d(G,0.001);
    [Ad, Bd, Cd, Dd] = tf2ss(Gd.num, Gd.den);
    y = zeros(1,length(t));
    x = y;
    j = 1;
    k = 0;
    sum_y = 0;
    my = 0;
    ii = 1;
    for i=2:1length(t)
      if(t(i) == t_trans(j))
        my = 0;
        j = j+1;
        ii = i;
      else
        k = k +1;
        sum_y = sum_y + y(i-1); %media do sinal;
        my = sum_y/k
        sy = sqrt((1/k)*sum(y(ii: i-1) - my));% desvio padrao da saida
      end
      x(i) = Ad*x(i-1) + Bd*u(i-1);
      y(i) = C*x(i-1) + Dd*u(i-1);
    end
    
end