clear;close all; clc            %start algorithm
IG=zeros(56,20);
for k=1:56
    X=csvread(k+".csv");         %bring data in X as matrix

    num_rows=length( X(:,21) ); % No of data tuples
    num_cols=21;
    
    P(1)=sum(X(:,21)==0)/num_rows;
    P(2)=1-P(1);
    %y=unique(X(:,21));           % No of parent class
    %for i=1:length(y)
    %    P(i)=sum( X(:,21)==y(i))/num_rows;
        
    %end
    Ep=sum( -P .* log2(P) );      %Entropy of parent
    Ep=ones(1,21)*Ep; 
    %% Now we calculate mean of each coloumn
    %  Then we will perforn a two way split
    %  and Count the number of data in each class
    %  Using them we calculate Entropy of children

    M=mean(X);
    for j=1:num_cols
        ngem0(j)=sum( X(:,j)<=M(j) & X(:,21)==0);
        ngem1(j)=sum( X(:,j)<=M(j) & X(:,21)~=0);
        ngem=ngem0+ngem1;
        nlm0(j)= sum( X(:,j)> M(j)  & X(:,21)==0);
        nlm1(j)= sum( X(:,j)> M(j)  & X(:,21)~=0);
        nlm=nlm0+nlm1;
        EC1 = (-ngem0./ngem).*log2(ngem0./ngem) + (-ngem1./ngem).*log2(ngem1./ngem);
        EC2 = (-nlm0./nlm)  .*log2(nlm0./nlm)   + (-nlm1./nlm)  .*log2(nlm1./nlm);
        PC1= (ngem)./(nlm+ngem);
        PC2= (nlm)./(nlm+ngem);
    end
    
    %for j=1:num_cols
    %    PC1(j)=sum( X(:,j)>=M(j) )/num_rows;
    %    PC2(j)=sum( X(:,j)< M(j) )/num_rows;
    %end
    %EC1=( -PC1 .* log2(PC1));
    %EC2=( -PC2 .* log2(PC2));
    %% Info Gain

    InfoGain=Ep-PC1.*EC1-PC2.*EC2;
    InfoGain(:,21)=[];
    IG(k,:)=InfoGain;
end

filename='Id2016B5A70537H_2016B3AA0633H_infogain.xlsx';
writematrix(IG,filename,'Sheet',1,'Range','A1:Z1000')