clear all
clc
w = cell(1,2);
b = cell(1,2);
w{1,1} = [0.15, 0.20;0.25,0.3];
w{1,2} = [0.4, 0.45;0.5,0.55];
b{1,1} = [0.35;0.35];
b{1,2} = [0.6;0.6];
opt = struct('weight',w,'bias',b);
nnff = newff(2,[2,2],opt);
data = [0.05,0.05;0.10,0.10];
[y,nnff] = sim(data,nnff);