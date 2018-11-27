function nnet = newff(numInput,layers, varargin)
	options = [];
	if(numInput <= 0 )
		error('o numero de entradas deve ser maior que zero');
	end
	nnet = struct('layers',length(layers),'numInput',numInput);
	nnet.layer = cell(1,nnet.layers);
	w = [];
	b = [];
	if(nargin > 2 && ~isempty(varargin))
		options = varargin{1};
	end
	if(~isempty(options))
		if(isfield(options,'weight') && isfield(options,'bias'))
			w = {options.weight};
			b = {options.bias};
		elseif(isfield(options,'weight'))
			b = struct('bias',cell(1,nnet.layers));
			for i=1:nnet.layers
				b(1,i).bias = -1*ones(layers(i),1);
			end
    end
  else
    w = cell(1,nnet.layers);
    b = cell(1,nnet.layers);
    w(1,1) = rand(layers(1),numInput);
    b(1,1) = -1*ones(layers(1),1);
    for i=2:nnet.layers
      w(1,i) = rand(layers(i),layers(i-1));
      b(1,i) = -1*ones(layers(i),1);
    end
	end
	%for i=1:nnet.layers
	%		nnet.layer(1,i) = struct("bias",-1*ones(layers(i),1),"w",rand(1,layers(i)),...
	%		"net",zeros(layers(i),1),"y",zeros(layers(i),1),"f",@logsig);
	%end
	for i=1:nnet.layers
			nnet.layer{1,i} = struct('bias',b(1,i),'w',w(1,i),...
			'net',zeros(layers(i),1),'y',zeros(layers(i),1),'f',@logsig);
	end	
end
%https://mattmazur.com/2015/03/17/a-step-by-step-backpropagation-example/