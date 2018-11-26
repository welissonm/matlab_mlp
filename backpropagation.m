function newff = backpropagation(dataset,nnet, tol,varargin)
	eta = 0.1;
	newff = nnet;
	erro = cell(1,nnet.layers);
	eqm = 0.0;
	epoch = 0;
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
	delta = cell(1,nnet.layers);
	dW = cell(1,nnet.layers);
	eqm = tol+1;
	while( eqm > tol)
		for k=1:m
			y = sim(dataset.data(:,k),nnet);
			erro = dataset.d(:,k)-y;
			eqm = ((k-1)*eqm + erro)/k;
			delta(1,nnet.layers) = erro*dlogsim(nnet.layer(1,nnet.layers).net);
			for i=nnet.layers-1:-1:1
				dW(1,i+1) = eta*delta(1,i+1)*nnet.layer(1,i).y;
				nnet.layer(1,i+1).w = nnet.layer(1,i+1).w + dW(1,i+1);
				delta(1,i) = -(delta(1,i+1)*nnet.layer(1,i+1).w)*dlogsim(nnet.layer(1,i).net);
			end
			dW(1,1) = eta*delta(1,2)*nnet.layer(1,2).y;
			nnet.layer(1,1).w = nnet.layer(1,1).w + dW(1,1);
		end
	end
end