function newff = backpropagation(dataset,nnet, tol,varargin)
	eta = 0.1;
	newff = nnet;
	erro = cell(1,nnet.layers);
	eqm = 0.0;
	epoch = 0;
	while( eqm <= tol)
		for i=1:nnet.layers
			erro = 
		end
end