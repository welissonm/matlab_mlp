function [y,nnff] = sim(inputData, nnet)
	if(size(inputData,1) ~= size(nnet.layer{1,1}.w,2))
		error('O conjunto de dados de entrada possui dimensoes incompativeis em relacao as entradas da rede');
	end
	[n,m] = size(inputData);
	if(isnnff(nnet) ~= 1)
		error('O argumento #2 deve ser uma rede neural feedforwad valida');
    end
    nnet.layer{1,1}.y = zeros(size(nnet.layer{1,1}.w,1),m);
    nnet.layer{1,1}.net = zeros(size(nnet.layer{1,1}.w,1),m);
  for k=2:nnet.layers
      nnet.layer{1,k}.y = zeros(size(nnet.layer{1,k}.w,1),m);
      nnet.layer{1,k}.net = zeros(size(nnet.layer{1,k}.w,1),m);
  end
  for j=1:m
    %nnet.layer{1,1}.net(:,j) = sum(kron(inputData(:,j),nnet.layer{1,1}.w),1)' + nnet.layer{1,1}.bias;
	nnet.layer{1,1}.net(:,j) = nnet.layer{1,1}.w*inputData(:,j) + nnet.layer{1,1}.bias;
    nnet.layer{1,1}.y(:,j) = nnet.layer{1,1}.f(nnet.layer{1,1}.net(:,j));
  end
  for j=1:m
    for k=2:nnet.layers
      %nnet.layer{1,k}.net(:,j) = sum(kron(nnet.layer{1,k-1}.y(:,j),nnet.layer{1,k}.w),1)' + nnet.layer{1,k}.bias;
	  nnet.layer{1,k}.net(:,j) = nnet.layer{1,k}.w*nnet.layer{1,k-1}.y(:,j) + nnet.layer{1,k}.bias;
      nnet.layer{1,k}.y(:,j) = nnet.layer{1,k}.f(nnet.layer{1,k}.net(:,j));
    end
  end
	y = nnet.layer{1,end}.y;
  nnff = nnet;
end