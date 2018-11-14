function [time,u] = prs_t(amp, delay,timeSample,tspan)
  ampMax = 0;
  ampMin = 0;
  tInit = 0;
  tEnd = 0;
  if(size(size(amp),2) ==2)
    ampMin = amp(1);
    ampMax = amp(2);
  elseif(~isempty(amp))
    ampMax = amp(1);
	ampMin = ampMax -2*ampMax;
  else
    error('o argumento #1 nao pode ser nulo.');
  end
  if(ampMin >= ampMax)
	error('o elemento do indice 1 do argumento #1 deve ser menor que o indice 2');
  end
  if(timeSample <= 0)
    error('O argumento #3 deve ser maior que zero.');
  end
  if(2*timeSample >= delay)
    error('O argumento #2 deve ser no minimo 2 vezes maior que o argumento #3');
  end
  if(size(size(tspan),2) ==2)
    tInit = tspan(1);
    tEnd = tspan(2);
  elseif(~isempty(tspan))
    tEnd = tspan(1);
  else
    error('o argumento #4 nao pode ser nulo.');
  end
  if(tInit >= tEnd)
    error('o elemento do indice 1 do argumento #4 deve ser menor que o indice 2');
  end
  if((tEnd - tInit)<= delay)
	  error('A diferenca (indice 2 - indice 1) do argumento #4 deve ser maior que o argumento #2');
  end
  if(mod(delay,timeSample) > eps)
    error('o argumento #2 deve ser multiplo do argumento #3');
  end
  time = (tInit:timeSample:tEnd)';
  values = zeros(length(time),1);
  t = tInit;
  i = 1;
  nt = floor(delay/timeSample);
  while(t<tEnd)
    tr = timeSample*randi([nt,2*nt]);
    if(tEnd -t < tr)
      tr = tEnd -t;
    end
    t = t+tr;
    vr = randNum(ampMin,ampMax);
    values(i:floor((t-tInit)/timeSample),1) = vr;
    i = floor((t-tInit)/timeSample)+1;
  end
  values(i:end) = vr;
  u = values;
end