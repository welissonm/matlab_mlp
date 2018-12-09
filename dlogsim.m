function y = dlogsim(n)
	x = logsig(n);
	y = x.*(ones(size(x))-x);
end
