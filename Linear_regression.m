clear;close all;clc
Main_MMRE=zeros(56,1);
Main_RMSE=zeros(56,1);
for i=1:56
    X=csvread(i+".csv");
    n_rows=size(X,1);
    Y=X(:,21);
    X(:,21)=[];
%% Normalizing the data
    minimum=min(X);
    maximum=max(X);
    
    X_norm=(X-minimum)./(maximum-minimum);
    X_norm(isnan(X_norm))=0.5;
%% Dividing into training and testing data

    P = 0.70 ;
    idx = randperm(n_rows);
    X_normTr = X_norm(idx(1:round(P*n_rows)),:) ; 
    X_normTs = X_norm(idx(round(P*n_rows)+1:end),:);
    Y_Tr = Y(idx(1:round(P*n_rows)),:);
    Y_Ts = Y(idx(round(P*n_rows)+1:end),:);
%% Find coefficients B0 and B1[]
    B1 = sum( ((X_normTr-mean(X_normTr)).*(Y_Tr-mean(Y_Tr))) )./(sum((X_norm - mean(X_normTr)).^2));
    B1(isnan(B1))=0;
    B0 = mean(Y_Tr)-mean(X_normTr)*B1';
%%  Test the result using RMSE and MMRE
    RMSE= sqrt(sum((Y_Ts-(X_normTs*B1'-B0)).^2)/size(Y_Ts,1) );
    MMRE= abs(Y_Ts-(X_normTs*B1'-B0)) ./ (Y_Ts+0.0005);
    MMRE= sum(MMRE)/size(Y_Ts,1);
    Main_MMRE(i)=MMRE;
    Main_RMSE(i)=RMSE;
end
%%  Write Back to Excel files
filename1='Id2016B5A70537H_2016B3AA0633H_mmre.xlsx';
writematrix(Main_MMRE,filename1,'Sheet',1,'Range','A1:Z1000');

filename2='Id2016B5A70537H_2016B3AA0633H_rmse.xlsx';
writematrix(Main_RMSE,filename2,'Sheet',1,'Range','A1:Z1000');
