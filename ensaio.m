function [t,y] = ensaio(tspan, timeSample, amp, delay)
    [t, prs] = prs_t(amp,delay,timeSample,tspan);
    m = mean(prs);
    mini = min(prs);
    maxi = max(prs);
    disp('minimo: ');
    disp(mini);
    disp('maximo: ');
    disp(maxi);
    disp('media: ');
    disp(m);
    y = prs;
    plot(t,y);
end