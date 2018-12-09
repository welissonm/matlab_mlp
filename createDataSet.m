%% Cria um conjunto de treinamento com amostras no tempo. No argumento #3, 
% as linhas representam as entradas da rede e as colunas as amostras no tempo.
% No argumento #4, as colunas sao as saidas desejadas correspondente a cada entra
% e as colunas sao as saidas desejdas amostradas no tempo.
% o argumento #1 e #2 sao o numero de entradas e saidas da rede respectivamente.
%%
function dataset = createDataSet(numInput,numOut,x,d)
n = size(x,2);
m = size(x,1);
%if(m ~= numInput)
%  error('as dimensoes do argumento #3 sao incompativeis com o argumento #1.');
%end
%if(numOut ~= size(d,1))
%  error('as dimensoes do argumento #4 sao incompativeis com o argumento #2.');
%end
if(n ~= size(d,2))
  error('o numero de colunas do argumento #3 deve ser o mesmo que o argumento #4');
end
dataset.data = zeros(numInput,n);
data.d = zeros(numOut,n);
for i=1:numInput
  for j=1:n-i+1
    dataset.data(i,i+j-1) = x(j);
    dataset.d(i,i+j-1) = d(j);
  end
end
end