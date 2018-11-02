function [A M]=M_normalize(A)
% ---------------------------------------------------------------------------------------
% SIGNATURE
% ---------------------------------------------------------------------------------------
% Author: Jiangyuan Mei
% E-Mail: meijiangyuan@hit.edu.cn
% Date  : Oct 8 2015
% ---------------------------------------------------------------------------------------

%Normalize the Mahalanobis matrix
%Input:     A           --> projection matrix before Normalization 
%Output:    A           --> projection matrix after Normalization 
%           M           --> Mahalanobis matrix after Normalization 


% Jiangyuan Mei, Xianqiang Yang, and Huijun Gao, 
%"Learning a Mahalanobis distance kernel for support vector machine
% classification", Journal of The Franklin Institute, under review.

n_feature=size(A,1);
M=A*A';
M=M/trace(M)*n_feature;
[V,D,W]=eig(M);
for i=1:size(M,1)
    if D(i,i)<=1e-6
        D(i,i)=1e-6;
    end
end
A=V*sqrt(D);