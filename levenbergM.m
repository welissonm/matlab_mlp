function newff = levenbergM(dataset,nnet, tol,eta,varargin)
	delta = cell(1,nnet.layers);
	%dW = cell(1,nnet.layers);
	E = zeros(p,n);
	%J = [];
	%J = dW;
	wOld = cell(1,nnet.layers);
  stp = 0;
  epoch = 0;
  dW = cell(1,nnet.layers);
  wOld = cell(1,nnet.layers);
  newff = nnet;
  n = size(dataset.data,1);
  m = size(dataset.data,2);
  options = [];
  alpha = 0;
  epochMax = 1000;
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
  kp = 0;
  wNew = wOld;
	while(~stp)
		sumErrorQ = 0;
		k = 1;
		epoch = epoch+1;
		for k=1:p:m-p
			kp = k+p-1;
      J = cell(1,nnet.layers);
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
					J{1,i+1} = [J{1,i+1}; reshape(dW{1,i+1}',1,prod(size(newff.layer{1,i+1}.w)))];
					delta{1,i} = -(newff.layer{1,i+1}.w'*delta{1,i+1}).*dlogsim(newff.layer{1,i}.net);
				end
				dW{1,1} = [dW{1,1};kron(delta{1,1},dataset.data(:,1)')];
				J{1,1} = [J{1,1}; reshape(dW{1,1}',1,prod(size(newff.layer{1,1}.w)))];
        clear dW;
			end
      for i=1:newff.layers
        J2 = J{1,i}'*J{1,i};
			  dW = ((J2 + eta*eye(size(J2)))^-1 )*J{1,i}'*E;
        wNew{1,i} = newff.layer{1,i}.w + reshape(dW(1:prod(size(newff.layer{1,i}.w)),i),size(newff.layer{1,i}.w))';
        newff.layer{1,i}.w = wNew{1,i};
      end
      clear J;
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