function r=ARMSE(X,X_ref)

[P,N]=size(X);
ss=zeros(N,1);

for i=1:N
    s=zeros(1,P);
    for j=1:P
         s(1,j)=(X(j,i)-X_ref(j,i)).^2;
    end
    ss(i,1)=sqrt(sum(s)/P);
end
r=sum(ss)/N;
