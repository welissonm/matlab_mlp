clc
clear
s = struct('weight',cell(1,2),'bias',cell(1,2));
s(1,1).weight = [0.15, 0.20; 0.25,0.3];
s(1,2).weight = [0.4, 0.45; 0.50,0.55];
s(1,1).bias = [0.35;0.35];
s(1,2).bias = [0.6;0.60];
nnet = newff(2,[2,2],s)
y = sim([0.05, 0.05;0.10, 0.10],nnet);
for i=1:size(y,1)
    if(abs(y(i,1)-y(i,2)) >eps)
        error('Erro na validacao da simulacao da rede');
    end
end
disp('saida da simulacao: ');
disp(y);