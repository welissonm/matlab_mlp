function[P, exitflag,niter]=mtPartLevMarq(...
 X,P,Func,FuncJacob,tol,nmaxiter, varargin)
  exitflag = 0 ;
  len = length(X) ;
  [A,B] =FuncJacob(P,X,varargin{:});
  [La,Ca,N] = size(A) ;
  [Lb, Cb, dummy] = size(B) ;
  N = len/La ;
  Vd = 1:(Cb+1):(Cb*Cb);
  Ud = 1:(Ca+1):(Ca*Ca);
  X2 = Func(P,varargin{:});
  Er = X-X2;
  lambda = 1e-3;
  % Loop p r i n c i p a l
  for niter =1:nmaxiter,
    [A, B] = FuncJacob(P,X2,varargin{:});
    U =zeros(Ca,Ca);
    iV = zeros(Cb,Cb,N);
    W = zeros(Cb,Ca,N);
    Ea = zeros(Ca,1);
    Eb = zeros(Cb,N);
    Y1 = zeros(Ca,Ca);
    Y2 = zeros(Ca,1);
    warning('o f f', 'all');
    for n =1:N,
      U = U + A(:,:,n)'*A(:,:,n);
      Vi = B(:,:,n)'*B(:,:,n);
      Vi(Vd) = (1+ lambda)*Vi(Vd) ;
      iV(:,:,n) = inv(Vi);
      W(:,:,n) = (A(:,:,n)'*B(:,:,n))';
      Ea = Ea + A(:,:,n)'*Er(1+(n-1)*La:n*La,1);
      Eb(:,n) = B(:,:,n)'*Er(1+(n-1)*Lb:n*Lb,1);
      tmp = W(:,:,n)'*iV(:,:,n);
      Y1 = Y1 + tmp*W(:,:,n);
      Y2 = Y2 + tmp*Eb(:,n);
     end
     U(Ud) = (1+ lambda )*U(Ud ) ;
     da = (U-Y1)\(Ea-Y2);
     warning('on','all');
     db = zeros(N*Cb,1 ) ;
     for n=1:N,
       db((1+(n-1)*Cb):n*Cb) = iV(:,:,n)*(Eb(:,n)-W(:,:,n)*da);
     end
     Ptmp = P+[da;db];
     X2 =Func(Ptmp,varargin{:});
     ErNew = X-X2;
     dEr = norm(Er) -norm(ErNew);
     if(dEr>0)
      P = Ptmp;
      Er = ErNew;
      lambda = lambda/10;
      % C r i t e r i o de parada
      if(abs(dEr)<tol)
        exitflag = 1;
        break;
      end
     else
      lambda = 10*lambda;
     end
  end
 end