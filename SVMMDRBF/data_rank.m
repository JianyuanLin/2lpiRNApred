function [X,Y]=data_rank(X,Y)
% ---------------------------------------------------------------------------------------
% SIGNATURE
% ---------------------------------------------------------------------------------------
% Author: Jiangyuan Mei
% E-Mail: meijiangyuan@hit.edu.cn
% Date  : Oct 8 2015
% ---------------------------------------------------------------------------------------

%Rank the training data according to the rank of label vector Y
%Input:     X     --> training data before ranking 
%           Y     --> training label before ranking
%Output:    X     --> training data after ranking
%           Y     --> training label after ranking


% Jiangyuan Mei, Xianqiang Yang, and Huijun Gao, 
%"Learning a Mahalanobis distance kernel for support vector machine
% classification", Journal of The Franklin Institute, under review.


Y_kind=unique(Y);
X_data=[];
Y_data=[];
for l=1:length(Y_kind)
    index=find(Y==Y_kind(l));
    X_data=[X_data;X(index,:)];
    Y_data=[Y_data;Y(index,:)];
end
X=X_data;
Y=Y_data;