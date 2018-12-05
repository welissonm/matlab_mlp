function newff = levenbergM(dataset,nnet, tol,varargin)
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
		if(isfield(option,'p'))
			p = option.p;
		else
			p = n;
		end
	end
	delta = cell(1,nnet.layers);
	%dW = cell(1,nnet.layers);
	E = zeros(p,n);
	%J = [];
	%J = dW;
	wOld = cell(1,nnet.layers);
  for i=1:nnet.layers
    %wOld{1,i} = zeros(size(newff.layer{1,i}.w));
    wOld{1,i} = newff.layer{1,i}.w;
  end
  kp = 0;
  wNew = wOld;
	while(~stp)
		sumErrorQ = 0;
		k = 1;
		epoch = epoch+1;
		for k=1:p:m-p
			kp = k+p-1;
      
      J = [];
			for j=k:kp
        dW = cell(1,nnet.layers);
				[y,newff] = sim(dataset.data(:,j),newff);
				erro = dataset.d(:,j)-y;
				E(j,:) = erro';
				err2 = erro.^2;
				sumErrorQ = sumErrorQ + erro.^2;
				%V = sum(sum(err2,1),2);
				delta{1,newff.layers} = erro.*dlogsim(newff.layer{1,newff.layers}.net);
          for i=newff.layers-1:-1:1
					dW{1,i+1} = [dW{1,i+1};kron(delta{1,i+1},newff.layer{1,i}.y')];
					J = [J, dW{1,i+1}];
					%wNew{1,i+1} = newff.layer{1,i+1}.w + alpha*(newff.layer{1,i+1}.w - wOld{1,i+1}) + eta*dW{1,i+1};
					%wOld{1,i+1} = newff.layer{1,i+1}.w;
					%newff.layer{1,i+1}.w = wNew{1,i+1};
					delta{1,i} = -(newff.layer{1,i+1}.w'*delta{1,i+1}).*dlogsim(newff.layer{1,i}.net);
				end
				dW{1,1} = [dW{1,1};kron(delta{1,1},dataset.data(:,1)')];
				J = [J, dW{1,1}];
        clear dW;
				%wNew{1,1} = newff.layer{1,1}.w + alpha*(newff.layer{1,1}.w - wOld{1,1}) + eta*dW{1,1};
				%wOld{1,1} = newff.layer{1,1}.w;
				%newff.layer{1,1}.w = wNew{1,1};
			end
			J2 = J'*J;
			dW = ((J2 + eta*eye(size(J2)))^-1 )*J'*E;
      clear J;
			for i=1:newff.layers
         wNew{1,i} = newff.layer{1,i}.w + reshape(dW(1:prod(size(newff.layer{1,i}.w)),i),size(newff.layer{1,i}.w))';
         newff.layer{1,i}.w = wNew{1,i};
      end
		end
		eqm = sumErrorQ/m;
		if(sqrt(max(sumErrorQ)/m) <= tol)
			stp = 1;
		elseif(epoch == epochMax)
			stp =1;
			warning('criterio de parada: numero maximo de epoca foi atingido');
		end
	end
end