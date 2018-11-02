function Predict=DAGSVMMDRBF_predict(M_struct,SVM_model_struct,X_train,Y_train,X_test,Y_test)
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
%           M_struct    --> a struct containing multi Mahalanobis distance function
%           SVM_model_struct     --> the corresponding SVM model struct
%Output:    Predict     --> Predicted results


% Jiangyuan Mei, Xianqiang Yang, and Huijun Gao, 
%"Learning a Mahalanobis distance kernel for support vector machine
% classification", Journal of The Franklin Institute, under review.

ngroups=size(M_struct,2);
nsamples=size(X_test,1);

for i=1:nsamples
    m=1;n=ngroups;
    for j=1:ngroups-1
        M=M_struct{m,n};
        SVM_model=SVM_model_struct{m,n};
        subtrain=[X_train(Y_train==m,:);X_train(Y_train==n,:)];
        subgroupnames=[Y_train(Y_train==m);Y_train(Y_train==n)];
        outclass=SVMMDRBF_predict(M,subtrain, X_test(i,:),subgroupnames, Y_test(i));
        if isequal(outclass,SVM_model.Label(1))
            n=n-1;
        elseif isequal(outclass,SVM_model.Label(2))
            m=m+1;
        end
    end
    Predict(i,1)=outclass;
end
