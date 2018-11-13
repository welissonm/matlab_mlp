function nnet = newff(layers)
	nnet = struct("layers",length(layers));
	nnet.layer = cell(1,nnet.layers);
	for i=1:nnet.layers
    nnet.layer(1,i) = struct("bias",-1*ones(layers(i),1),"w",rand(1,layers(i)),...
    "net",zeros(layers(i),1),"y",zeros(layers(i),1),"f",@logsig);
	end
end