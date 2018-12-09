%% correntropia cruzada centralizada para amostras finitas
function corre = correntropia(x,y,weight_kernel,varargin)
%     [nx,mx] = size(x);
%     [ny,my] = size(y);
tipo = 'correntropia';
if(~isempty(varargin))
    if(strcmp(varargin{1}, 'ccc')==1 || strcmp(varargin{1},'correntropia cruzada centralizada') == 1)
        tipo = 'correntropia cruzada centralizada';
    end
end
n = min(length(x),length(y));
corre = 0;
corre_des = 0;
if(strcmp(tipo, 'correntropia') == 1)
    for i =1:n
        corre = corre + kappa(x(i),y(i),weight_kernel);
    end
    corre = (corre/n);
else
    for i =1:n
        for j=1:n
            corre_des = corre_des+ kappa(x(i),y(j),weight_kernel);
        end
        corre = corre + kappa(x(i),y(i),weight_kernel);
    end
    corre = (corre/n) - (corre_des/(n^2));
end

end
function k = kappa(x,y,weight_kernel)
sig = 1/sqrt(2*pi*weight_kernel);
k = sig*exp(-(((x - y).^2)/(2*sig^2)));
end