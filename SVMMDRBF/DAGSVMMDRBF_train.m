function [M_struct,SVM_model_struct]=DAGSVMMDRBF_train(X_train,Y_train)
% ---------------------------------------------------------------------------------------
% SIGNATURE
% ---------------------------------------------------------------------------------------
% Author: Jiangyuan Mei
% E-Mail: meijiangyuan@hit.edu.cn
% Date  : Oct 8 2015
% ---------------------------------------------------------------------------------------

%Training multiclass data using DAG strategy
%Input:     X_train     --> training data 
%           Y_train     --> training label
%Output:    M_struct    --> a struct containing multi Mahalanobis distance function
%           SVM_model_struct     --> the corresponding SVM model struct


% Jiangyuan Mei, Xianqiang Yang, and Huijun Gao, 
%"Learning a Mahalanobis distance kernel for support vector machine
% classification", Journal of The Franklin Institute, under review.




ngroups=length(unique(Y_train));
for i=1:ngroups
    for j=i+1:ngroups
        subtrain=[X_train(Y_train==i,:);X_train(Y_train==j,:)];
        subgroupnames=[Y_train(Y_train==i);Y_train(Y_train==j)];
        [M,SVM_model]=SVMMDRBF_train(subtrain,subgroupnames);
        M_struct{i,j}=M;
        SVM_model_struct{i,j}=SVM_model;
    end
end