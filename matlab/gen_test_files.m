clear variables

A = rand(5000);
tic
[V,D] = eig(A);
toc

A_test = A;
clear A;
D_test = D;
clear D;
V_test = V;
clear V;

save('A_test.mat', 'A_test')
save('D_test.mat', 'D_test')
save('V_test.mat', 'V_test')