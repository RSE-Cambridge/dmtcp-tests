clear variables

load('A_test.mat')

tic
[V,D] = eig(A_test);
toc

save('D.mat', 'D')
save('V.mat', 'V')