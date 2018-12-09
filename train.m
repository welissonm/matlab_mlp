function newff = train(dataset,nnet, tol,varargin)
	eta = 0.5;
	alpha = 0.0;
	erro = cell(1,nnet.layers);
	epochMax = 1000;
	eqm = 0;
	option = [];
	method = 'backpropagation';
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
		if(isfield(option,'method'))
			method = option.method;
		end
	end
	switch(method)
		case {'levenberg-marquardt' 'lm'}
			newff = levenbergM(dataset,nnet, tol,eta,varargin{:});
		otherwise
			newff = backpropagation(dataset,nnet,tol,eta,varargin{:});
	end
end