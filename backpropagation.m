function newff = backpropagation(dataset,nnet, tol,varargin)
	eta = 0.5;
	alpha = 0.0;
	newff = nnet;
	erro = cell(1,nnet.layers);
	epoch = 0;
	epochMax = 1000;
	eqm = 0;
	stp = 0;
	option = [];
	if(~isfield(dataset,'data') || ~isfield(dataset,'d'))
		error('O argumento #1 deve ser um struct contendo os campos "data" e "d"');
	end
	if(isempty(dataset.data) || isempty(dataset.d))
		error('Os campos "data" e "d" do argumento #1 nao podem ser vazios');
	end
	n = size(dataset.data,1);
	m = size(dataset.data,2);
	if(isnnff(nnet) ~= 1)
		error('O argumento #2 deve ser uma rede neural feedforwad valida');
	end
	if(n ~= nnet.numInput)
		error('o numero de linhas dos dados de entrada nao corresponde ao numero de entradas da rede.');
	end
	if(abs(tol) < eps)
		error('o modulo do argumento #3 nao pode ser menor que eps');
	end
	if(~isempty(varargin))
		option = varargin{1};
		if(isfield(option,'epochMax'))
			epochMax = option.epochMax;
		end
		if(isfield(option,'eta'))
			eta = option.eta;
		end
    if(isfield(option,'alpha'))
			alpha = option.alpha;
		end
	end
	delta = cell(1,nnet.layers);
	dW = cell(1,nnet.layers);
	wOld = cell(1,nnet.layers);
  for i=1:nnet.layers
    %wOld{1,i} = zeros(size(newff.layer{1,i}.w));
    wOld{1,i} = newff.layer{1,i}.w;
  end
  wNew = wOld;
	while(~stp)
		sumErrorQ = 0;
		k = 1;
		epoch = epoch+1;
		for k=1:m
			[y,newff] = sim(dataset.data(:,k),newff);
			erro = dataset.d(:,k)-y;
			sumErrorQ = sumErrorQ + erro.^2;
			delta{1,newff.layers} = erro.*dlogsim(newff.layer{1,newff.layers}.net);
			for i=newff.layers-1:-1:1
				dW{1,i+1} = kron(delta{1,i+1},newff.layer{1,i}.y');
				wNew{1,i+1} = newff.layer{1,i+1}.w + alpha*(newff.layer{1,i+1}.w - wOld{1,i+1}) + eta*dW{1,i+1};
				wOld{1,i+1} = newff.layer{1,i+1}.w;
				newff.layer{1,i+1}.w = wNew{1,i+1};
				delta{1,i} = -(newff.layer{1,i+1}.w'*delta{1,i+1}).*dlogsim(newff.layer{1,i}.net);
			end
			dW{1,1} = kron(delta{1,1},dataset.data(:,1)');
      wNew{1,1} = newff.layer{1,1}.w + alpha*(newff.layer{1,1}.w - wOld{1,1}) + eta*dW{1,1};
      wOld{1,1} = newff.layer{1,1}.w;
			newff.layer{1,1}.w = wNew{1,1}; 
		end
		eqm = sumErrorQ/m;
		if(max(sumErrorQ/m) <= tol)
			stp = 1;
		elseif(epoch == epochMax)
			stp =1;
			warning('criterio de parada: numero maximo de epoca foi atingido');
		end
	end
end