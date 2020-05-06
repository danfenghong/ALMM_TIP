function [A_est, S_est, B_est, E_est, endM]=ALMM_DL_blind(Y, endM, E, A_init, alfa, beta, gama, eta, maxiter)

[D,N]=size(Y);
[D,P]=size(endM);
[D,PE]=size(E);

norm_y = sqrt(mean(mean(Y.^2)));
endM = endM/norm_y;
Y = Y/norm_y;

iter = 1;
epsilon =1e-6;
stop = false;

X=A_init;
G=zeros(P,N);
H=zeros(P,N);
B=zeros(PE,N);
Q=zeros(D,PE);
T=zeros(N,N);
S=diag(ones(N,1));
Z=zeros(size(endM));


lamda1=zeros(P,N);
lamda2=zeros(P,N);
lamda3=zeros(P,N);
lamda4=zeros(D,PE);
lamda5=zeros(N,N);
lamda6=zeros(size(Z));

mu=1e-3;
rho=1.5;
mu_bar=1e+6;

rid = zeros(1,maxiter+1);
rid(1,iter)=0.5*(norm(Y-endM*X*S-E*B,'fro')^2)+alfa*sum(sum(abs(X)))+0.5*beta*(norm(B,'fro')^2)...
    +0.5*gama*(norm(endM'*E,'fro')^2)+0.5*eta*(norm(E*E'-eye(size(E*E')))^2);

while ~stop && iter < maxiter+1
    Qp=E;
%     
    %update M
    M=(endM'*endM+mu*eye(size(endM'*endM)))\(endM'*Y-endM'*Qp*B+mu*X*S-lamda3);
    
    %update B
    B=((Qp'*Qp)+beta*eye(size(Qp'*Qp)))\(Qp'*Y-Qp'*endM*M);
     
    %update E
    E=((Y-endM*M)*B'+mu*Q+lamda4)/(B*B'+mu*eye(size(B*B')));

    %update Q
    Q=(gama*(endM*endM')+eta*(Qp*Qp')+mu*eye(size(Qp*Qp')))\(eta*Qp+mu*E-lamda4);
    
    %update X
    X=(mu*G+lamda1+mu*H+lamda2+lamda3*S'+mu*M*S')/(mu*(S*S')+2*mu*eye(size(S*S')));
    X=X./repmat(sum((X)),P,1);
    
    %update endM
    endM=(Y*M'-E*B*M'+mu*Z+lamda6)/(M*M'+mu*eye(size(M*M')));
    
    %update S
    SL=mu*(X'*X)+mu*eye(size(X'*X));
    SR=mu*X'*M+X'*lamda3+mu*T+lamda5;
    for i=1:N
        S(i,i)=SL(:,i)\SR(:,i);
    end
    
    %update G
    G=max(abs(X-lamda1/mu)-(alfa/mu),0).*sign(X-lamda1/mu); 
    
    %optimize H
    H=max(X-lamda2/mu,0);  
    
    %optimize T
    T=max(S-lamda5/mu,0);  

    %optimize Z
    Z=max(endM-lamda6/mu,0);  
    
    %update lamda1-5
    lamda1=lamda1+mu*(G-X);
    lamda2=lamda2+mu*(H-X);
    lamda3=lamda3+mu*(M-X*S);
    lamda4=lamda4+mu*(Q-E);
    lamda5=lamda5+mu*(T-S);
    lamda6=lamda6+mu*(Z-endM);
    mu=min(mu*rho,mu_bar);
    
    iter=iter+1;
    
    %check convergence
    res1=norm(G-X,'fro');
    res2=norm(H-X,'fro');
    res3=norm(M-X*S,'fro');
    res4=norm(Q-E,'fro');
    res5=norm(T-S,'fro');
    res6=norm(Qp-E,'fro');
    res7=norm(Z-endM,'fro');
    
    rid(1,iter)=0.5*(norm(Y-endM*X*S-E*B,'fro')^2)+alfa*sum(sum(abs(X)))+0.5*beta*(norm(B,'fro')^2)...
    +0.5*gama*(norm(endM'*E,'fro')^2)+0.5*eta*(norm(E*E'-eye(size(E*E')))^2);

    if res3<epsilon&&res1<epsilon&&res4<epsilon&&res2<epsilon&&res5<epsilon&&res7<epsilon&&res6<epsilon
        stop = true;
        break;
    end
end

A_est=X;
S_est=diag(S)';
B_est=B;
E_est=E;
end