function Predict=SVMMDRBF_predict(M,X_train, X_test,Y_train, Y_test)
% ---------------------------------------------------------------------------------------
% SIGNATURE
% ---------------------------------------------------------------------------------------
% Author: Jiangyuan Mei
% E-Mail: meijiangyuan@hit.edu.cn
% Date  : Oct 8 2015
% ---------------------------------------------------------------------------------------

%Predict the classification results using SVM with Mahalanobis distance based radial basis function (MDRBF) kernel
%Input:     X_train     --> training data 
%           Y_train     --> training label
%           X_test      --> testing data  
%           Y_test      --> testing label
%           M           --> Mahalanobis matrix
%Output:    Predict     --> Predicted results


% Jiangyuan Mei, Xianqiang Yang, and Huijun Gao, 
%"Learning a Mahalanobis distance kernel for support vector machine
% classification", Journal of The Franklin Institute, under review.

n_train=size(X_train,1);
n_test=size(X_test,1);

Distance_train=CalculateDistance(M,X_train);
Distance_test=CalculateDistance(M,X_train,X_test);
mean_value=mean(Distance_train(:));
K_train=exp(-Distance_train/mean_value);
K_test=exp(-Distance_test/mean_value); 
SVM_model = svmtrain(Y_train, [(1:n_train)',K_train], '-t 4');   
[Predict,~,~] = svmpredict(Y_test, [(1:n_test)',K_test], SVM_model);
return;