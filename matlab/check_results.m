clear variables

load('D_test.mat')
load('V_test.mat')

load('D.mat')
load('V.mat')

passed=true;
if(D~=D_test)
    disp('D is different!')
    passed=false;
end

if(V~=V_test)
    disp('V is different!')
    passed=false;
end

if(passed)
    disp('Test successful')
else
    disp('Test failed')
end