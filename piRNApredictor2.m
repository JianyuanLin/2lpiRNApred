cvx_setup()
addpath('./SVMMDRBF');
addpath('./libsvm-3.20/matlab');
load feature2.mat

[FileName, PathName, FilterIndex]=uigetfile('.txt','Select file to open');
data_file = [PathName, FileName];
data_file
system(['python ./Pse-in-One-2.0/psee.pyc ',data_file, ' RNA PC-PseDNC-General -w 0.2 -lamada 2 -i propChosen.txt -f tab -labels 0 -out PC2.txt']);
system(['python ./Pse-in-One-2.0/psee.pyc ',data_file, ' RNA PC-PseDNC-General -w 0.5 -lamada 7 -i propChosen.txt -f tab -labels 0 -out PC13.txt']);
system(['python ./Pse-in-One-2.0/psee.pyc ',data_file, ' RNA PC-PseDNC-General -w 0.8 -lamada 7 -i propChosen.txt -f tab -labels 0 -out PC14.txt']);
system(['python ./Pse-in-One-2.0/psee.pyc ',data_file, ' RNA PC-PseDNC-General -w 0.1 -lamada 8 -i propChosen.txt -f tab -labels 0 -out PC15.txt']);
system(['python ./Pse-in-One-2.0/psee.pyc ',data_file, ' RNA PC-PseDNC-General -w 0.4 -lamada 9 -i propChosen.txt -f tab -labels 0 -out PC16.txt']);

system(['python ./Pse-in-One-2.0/nac.pyc ',data_file, ' RNA Kmer -k 3 -f tab -labels 0 -out Kmer3.txt']);

system(['python ./Pse-in-One-2.0/acc.pyc ',data_file, ' RNA GAC -lamada 9 -i propChosen.txt -f tab -labels 0 -out GAC.txt']);

system(['python ./Pse-in-One-2.0/acc.pyc ',data_file, ' RNA NMBAC -lamada 3 -i propChosen.txt -f tab -labels 0 -out NMBAC.txt']);

system(['python ./Pse-in-One-2.0/psee.pyc ',data_file, ' RNA SC-PseDNC-General -w 0.4 -lamada 1 -i propChosen.txt -f tab -labels 0 -out SC-PseDNC-General.txt']);


% 
% test2=[PC2,GAC,NMBAC,SC-PseDNC-General,Kmer3];
PC2 = load('PC2.txt');
PC13 = load('PC13.txt');
PC14 = load('PC14.txt');
PC15 = load('PC15.txt');
PC16 = load('PC16.txt');
Kmer3 = load('Kmer3.txt');
GAC = load('GAC.txt');
NMBAC =load('NMBAC.txt');
SC_PseDNC_General = load('SC-PseDNC-General.txt');
NMBAC(:,[1 2 3 4 5 6])=NMBAC(:,[3 1 6 2 4 5]);
GAC(:,[1 2 3 4 5 6])=GAC(:,[3 1 6 2 4 5]);
test2=[PC2,GAC,NMBAC,SC_PseDNC_General,Kmer3];
n=size(test2,1);

test2=test2(:,index2);
[prelabeltest2,src_scores,uniqlabels]=src(Train2,Train_labels2,test2,0.3)    

test13=[PC13,GAC,NMBAC,SC_PseDNC_General,Kmer3];
test13=test13(:,index13);
[prelabeltest13,src_scores,uniqlabels]=src(Train13,Train_labels13,test13,0.3)    

test14=[PC14,GAC,NMBAC,SC_PseDNC_General,Kmer3];
test14=test14(:,index14);
[prelabeltest14,src_scores,uniqlabels]=src(Train14,Train_labels14,test14,0.3)    

test15=[PC15,GAC,NMBAC,SC_PseDNC_General,Kmer3];
test15=test15(:,index15);
[prelabeltest15,src_scores,uniqlabels]=src(Train15,Train_labels15,test15,0.3)    

test16=[PC16,GAC,NMBAC,SC_PseDNC_General,Kmer3];
test16=test16(:,index16);
[prelabeltest16,src_scores,uniqlabels]=src(Train16,Train_labels16,test16,0.3)    

prelabeltest=[prelabeltest2,prelabeltest13,prelabeltest14,prelabeltest15,prelabeltest16];
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
for m=1:n    
    if predict_label(m)==1
        fprintf(fid,'>%s \n',Name{1,m});
        fprintf(fid,'%s positive \n',seq{1,m}); 
    else
        fprintf(fid,'>%s \n%s negative \n',Name{1,m},seq{1,m});
    end
end
