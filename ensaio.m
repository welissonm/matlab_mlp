function [t,y] = ensaio(tspan, timeSample, amp, delay)
    [t, prs] = prs_t(amp,delay,timeSample,tspan);
    m = mean(prs);
    y = prs - m;
    mini = min(y);
    maxi = max(y);
    if(mini < 0)
        delta = amp(2) - (abs(mini) + maxi);
        y = y + delta;
    end
end