function Distance=CalculateDistance(M,X1,X2)
% ---------------------------------------------------------------------------------------
% SIGNATURE
% ---------------------------------------------------------------------------------------
% Author: Jiangyuan Mei
% E-Mail: meijiangyuan@hit.edu.cn
% Date  : Oct 8 2015
% ---------------------------------------------------------------------------------------

%Calculate the Mahalanobis distance matrix of feature vectors 
%Input:     X1, X2      --> feature vectors 
%           M           --> Mahalanobis distance
%Output:    Distance    --> Mahalanobis distance matrix 


% Jiangyuan Mei, Xianqiang Yang, and Huijun Gao, 
%"Learning a Mahalanobis distance kernel for support vector machine
% classification", Journal of The Franklin Institute, under review.


numberCandidate1=size(X1,1);
for i=1:numberCandidate1
    l1(i)=X1(i,:)*M*X1(i,:)';
end

if ~exist('X2')
    D1=repmat(l1,numberCandidate1,1);
    D2=repmat(l1',1,numberCandidate1);
    K=X1*M*X1';
    Distance=D1+D2-2*K;
else
    numberCandidate2=size(X2,1);
    for i=1:numberCandidate2
        l2(i)=X2(i,:)*M*X2(i,:)';
    end
    D1=repmat(l1,numberCandidate2,1);
    D2=repmat(l2',1,numberCandidate1);
    K=X2*M*X1';
    Distance=D1+D2-2*K;
end
return