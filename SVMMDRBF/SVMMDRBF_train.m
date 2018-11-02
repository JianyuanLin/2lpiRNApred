function [M,SVM_model]=SVMMDRBF_train(X_train, Y_train)
% ---------------------------------------------------------------------------------------
% SIGNATURE
% ---------------------------------------------------------------------------------------
% Author: Jiangyuan Mei
% E-Mail: meijiangyuan@hit.edu.cn
% Date  : Oct 8 2015
% ---------------------------------------------------------------------------------------

%Train a Mahalanobis distance kernel for support vector machine classification
%Input:     X_train       --> training data  n-by-D
%           Y_train       --> training label n-by-1
%Output:    M             --> learned PSD matrix
%           SVM_model     --> the learned SVM parameters.

% Jiangyuan Mei, Xianqiang Yang, and Huijun Gao, 
%"Learning a Mahalanobis distance kernel for support vector machine
% classification", Journal of The Franklin Institute, under review.


%% initial parameters;
n_feature=size(X_train,2);
n_train=size(X_train,1);
M0=eye(n_feature,n_feature);
A0=M0;
M=M0;
Distance0=CalculateDistance(M0,X_train);
mu0=mean(Distance0(:));
gamma=1/mu0;
sigma_initial=0.01;
A=A0;
tic
%% training

for loop=1:8
    Distance_M=CalculateDistance(M,X_train);
    K_train=exp(-Distance_M*gamma);
%     figure(1),imshow(K_train,[]);
    
    %  obtain SVM parameters 
    SVM_model = svmtrain(Y_train, [(1:n_train)',K_train], '-t 4');  
    sv_indices=SVM_model.sv_indices;
    Alpha=SVM_model.sv_coef;
    n_sv=length(sv_indices);
    % updating A using gradient descent method
    
    fM_value_old=0;
    dA_value_old=0;
 
    % increase the initial sigma 
    sigma0=sigma_initial;
    sigma=sigma0;
    
    for i=1:n_sv
        for j=1:n_sv
            if i==j
                continue;
            end
            ii=sv_indices(i);
            jj=sv_indices(j);
            vector=(X_train(ii,:)-X_train(jj,:));
            tmp=vector'*vector;
            dA_value_old=dA_value_old-gamma*Alpha(i)*Alpha(j)*K_train(ii,jj)*tmp*A;
            fM_value_old=fM_value_old+1/2*Alpha(i)*Alpha(j)*K_train(ii,jj);
        end
    end
    A_tmp=A+sigma*dA_value_old;
    [A_tmp M_tmp]=M_normalize(A_tmp);
    
    iter=0;
    while iter<10
        fM_value_new=0;
        dA_value_new=0;
        Distance_tmp=CalculateDistance(M_tmp,X_train);
        K_tmp=exp(-gamma*Distance_tmp);
        for i=1:n_sv
            for j=1:n_sv
                if i==j
                    continue;
                end
                ii=sv_indices(i);
                jj=sv_indices(j);
                vector=(X_train(ii,:)-X_train(jj,:));
                tmp=vector'*vector;
                dA_value_new=dA_value_new-gamma*Alpha(i)*Alpha(j)*K_tmp(ii,jj)*tmp*A_tmp;
                fM_value_new=fM_value_new+1/2*Alpha(i)*Alpha(j)*K_tmp(ii,jj);
            end
        end
        
        if fM_value_new>0
            break;
        elseif fM_value_new>fM_value_old
            % normalize M
            A=A_tmp;
            [A M]=M_normalize(A);
            fM_value_old=fM_value_new;
            sigma=sigma0;
            A_tmp=A+sigma*dA_value_new;
            [A_tmp M_tmp]=M_normalize(A_tmp);
        else
            sigma=sigma/2;
            A_tmp=A+sigma*dA_value_old;
            [A_tmp M_tmp]=M_normalize(A_tmp);
        end
        iter=iter+1; 
    end     
    fprintf('*');
end

toc