function newff = backpropagation(dataset,nnet, tol,eta,varargin)
  stp = 0;
  epoch = 0;
  delta = cell(1,nnet.layers);
  dW = cell(1,nnet.layers);
  wOld = cell(1,nnet.layers);
  newff = nnet;
  n = size(dataset.data,1);
  m = size(dataset.data,2);
  options = [];
  alpha = 0;
  epochMax = 1000;
  rmes = 0;
  if(~isempty(varargin))
	option = varargin{1};
		if(isfield(option,'epochMax'))
			epochMax = option.epochMax;
		end
		if(isfield(option,'alpha'))
			alpha = option.alpha;
		end
  end
  for i=1:nnet.layers
    %wOld{1,i} = zeros(size(newff.layer{1,i}.w));
    wOld{1,i} = nnet.layer{1,i}.w;
  end
  wNew = wOld;
	while(~stp)
		sumErrorQ = 0;
		k = 1;
		epoch = epoch+1;
        disp(['epoch: ',num2str(epoch)])
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
        rmes = sqrt(max(sumErrorQ)/m);
        disp(['rmes: ',num2str(rmes)])
		if( rmes <= tol)
			stp = 1;
		elseif(epoch == epochMax)
			stp =1;
			warning('criterio de parada: numero maximo de epoca foi atingido');
		end
	end
end