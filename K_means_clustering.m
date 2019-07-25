%% Start algorithm
clear;
close all;
clc   
%% Read all data to a matrix X(82351x21)
X=csvread("1.csv");
for i=2:56
    x=csvread(i+".csv");
    X=[X;x];    
end
X(:,21)=[];  %remove class infomation variable
%% Finding the optimal value of k
for i=1:10
    [idx,centerCordinates,SSE]=kmeans(X,i);
    s(i)=sum(SSE);
end
i=[1 2 3 4 5 6 7 8 9 10];
plot(i,s);
%hold on;
%% Apply Kmeans clustering to find SSE and Silhotte
[idx,centerCordinates,SSE]=kmeans(X,2);

C1=find(idx==1);
C2=find(idx==2);
for i=1:82351
    index=find(C1==i);
    if length(index)>0
        s=(C1-index).^2;
        s=sqrt(sum(s))/(length(C1)-1);
        s1=mean(sqrt(sum( (C2-index).^2)));
        SV(i)=(s1-s)/max(s1,s);
    else
        index=find(C2==i);
        s=(C2-index).^2;
        s=sqrt(sum(s))/(length(C2)-1);
        s1=mean(sqrt(sum( (C1-index).^2)));
        SV(i)=(s1-s)/max(s1,s);        
    end
end

silh=mean(SV);
SSE=sum(SSE);
performance=zeros(2,1);
performance(1)=SSE;
performance(2)=silh;


%% Write back to excel file
filename='Id2016B5A70537H_2016B3AA0633H_performance.xlsx';
writematrix(performance,filename,'Sheet',1,'Range','A1:Z1000');


