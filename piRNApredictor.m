

addpath('./SVMMDRBF');
addpath('./libsvm-3.20/matlab');
addpath('./cvx-w64/cvx');
load feature.mat
cvx_setup()
system('python ./Pse-in-One-2.0/psee.pyc ./data.txt RNA PC-PseDNC-General -w 0.5 -lamada 6 -i propChosen.txt -f tab -labels 0 -out PC3.txt');
system('python ./Pse-in-One-2.0/psee.pyc ./data.txt RNA PC-PseDNC-General -w 0.2 -lamada 9 -i propChosen.txt -f tab -labels 0 -out PC7.txt');
system('python ./Pse-in-One-2.0/psee.pyc ./data.txt RNA PC-PseDNC-General -w 0.2 -lamada 7 -i propChosen.txt -f tab -labels 0 -out PC8.txt');
system('python ./Pse-in-One-2.0/nac.pyc ./data.txt RNA Kmer -k 1 -f tab -labels 0 -out Kmer1.txt');
system('python ./Pse-in-One-2.0/nac.pyc ./data.txt RNA Kmer -k 3 -f tab -labels 0 -out Kmer3.txt');

PC3 = load('PC3.txt');
PC7 = load('PC7.txt');
PC8 = load('PC8.txt');
Kmer1 = load('Kmer1.txt');
Kmer3 = load('Kmer3.txt');
test3 = [PC3, Kmer1, Kmer3];
n=size(test3,1);
test3=test3(:,index3);
ytest3=ones(n,1);
prelabeltest3=DAGSVMMDRBF_predict(M_struct,SVM_model_struct,Train3,Train_labels3,test3,ytest3);
test7=[PC7,Kmer1,Kmer3];
test7=test7(:,index7);
% ytest7=ones(n,1);
[prelabeltest7,src_scores,uniqlabels]=src(Train7,Train_labels7,test7,0.3)    

test8=[PC8,Kmer1,Kmer3];
%
test8=test8(:,index8);
% ytest8=ones(n,1);
[prelabeltest8,src_scores,uniqlabels]=src(Train8,Train_labels8,test8,0.3) 

prelabeltest=[prelabeltest3,prelabeltest7,prelabeltest8];
numberindex=[];
value=[];
preENCRF=[];
numberclass=2;
class=[1 2];
for i=1:n 
    prelabelES=[];
    prelabelES= prelabeltest(i,:); 
    for j=1:numberclass
        index=[];
        index=find(prelabelES==class(j));
        numberindex(i,j)=length(index);
    end
    [value(i,1) indexmax(i,1)]=max(numberindex(i,:));
    preENCRF(i,1)=class(indexmax(i,1));
    predict_label(i)= preENCRF(i,1);
end

[Name seq]=fastaread('data.txt');
fid = fopen('result.txt', 'wt');
uu=0;
for m=1:n    
    if predict_label(m)==1
        fprintf(fid,'>%s \n',Name{1,m});
        fprintf(fid,'%s positive \n',seq{1,m}); 
    else
        fprintf(fid,'>%s \n%s negative \n',Name{1,m},seq{1,m});
    end
end