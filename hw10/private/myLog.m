function logA=myLog(A)
% myLog: �קK���� log of zero ��ĵ�i�T��

%logA=log(A+eps);
logA=log(A+realmin);

%index=find(A==0);
%A(index)=eps;
%logA=log(A);
%logA(index)=-inf;