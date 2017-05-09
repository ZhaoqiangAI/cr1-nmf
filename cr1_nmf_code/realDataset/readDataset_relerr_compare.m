% [ V,K_est,iter_mult,iter_hals,shift_mult,shift_hals,runtime_inits,cluster_gd ] = readDataset_time_compare( dataset_name )
%
% Input.
%   dataset_name   : a string; the name of the dataset
%
% Output.
%   V              : the data matrix obtained
%   K_est          : latent dimensionality
%   iter_mult      : number of iterations of mult to be run;
%   iter_hals      : number of iterations of hals to be run;
%   shift_mult     : a vector; contains the shifts of different initialization methods for mult
%   shift_hals     : a vector; contains the shifts of different
%                    initialization methods for hals
%   runtime_inits  : running time for the initialization methods
%   cluster_gd     : the ground truth of cluster labels;

function [ V,K_est,iter_mult,iter_hals,shift_mult,shift_hals,runtime_inits,cluster_gd ] = readDataset_relerr_compare( dataset_name )

if(strcmp(dataset_name,'CK'))
    % can be downloaded from http://www.consortium.ri.cmu.edu/ckagree/
    % Database Description
    % Image Data:Cohn-kanade.tgz (1.7gb): zipped file of image data in png format 
    % -585 directories (subject + session)
    % -97 subject directories
    % -8795 image files
    X = load('../dataset/CK49times64.mat');V=X.V; 
    K_est = 97;
    
    img_num_vec = [94,106,111,152,85,106,136,93,168,105,133,106,87,113,24,89,140,35,119,26,137,57,71,46,27,81,36,66,90,43,...
    98,39,83,53,104,95,119,112,102,84,143,138,66,55,102,119,59,33,31,34,80,72,73,43,66,56,35,106,36,142,66,63,86,85,156,...
    162,63,160,116,79,122,87,138,86,83,163,110,134,82,95,95,138,34,76,85,149,66,74,173,115,125,111,66,87,90,42,73];

    cluster_gd = [];
    for k = 1:K_est
        cluster_gd = [cluster_gd,k*ones(1,img_num_vec(k))];
    end
elseif(strcmp(dataset_name,'faces94'))
    % can be downloaded from http://cswww.essex.ac.uk/mv/allfaces/faces94.html
    % Database Description
    % Number of  individuals: 152
    % Image resolution: 200 by 180 pixels (portrait format)
    % Contains images of male and female subjects in separate directories
    % 3040 images; 20 images per person
    X = load('../dataset/faces94.mat');V=X.V;
    K_est = 152;
    [~,N] = size(V); 
    cluster_gd = reshape(repmat(1:K_est,N/K_est,1),1,N);
elseif(strcmp(dataset_name,'Georgia Tech'))
    % can be downloaded from http://www.anefian.com/research/face_reco.htm
    % 750 images; 15 images per person
    % original size: 480*640=307200; reshaped to size: 49*64=3136
    X = load('../dataset/Georgia_Tech.mat');V=X.V;
    K_est = 50;
    [~,N] = size(V); 
    cluster_gd = reshape(repmat(1:K_est,N/K_est,1),1,N);
elseif(strcmp(dataset_name,'PaviaU'))
    % can be downloaded from http://www.ehu.eus/ccwintco/index.php?title=Hyperspectral_Remote_Sensing_Scenes
    X = load('../dataset/PaviaU.mat'); V_temp = X.paviaU;
    V = reshape(V_temp,size(V_temp,1)*size(V_temp,2),size(V_temp,3));
    K_est = 9;
else
    fprintf('Error, no such dataset!\n');
    return;
end

[ iter_mult,iter_hals,shift_mult,shift_hals,running_time ] = datasetParams_relerr_compare( V,K_est );
runtime_inits = mean(running_time);

% save the results
iter_vec = [iter_mult,iter_hals,0];
param_mat = [iter_vec;shift_mult;shift_hals]; param_mat=[param_mat;running_time];
str_now = datestr(now,30);
filename = ['../output/realDataset/param_mat_dataset_',dataset_name,'_K_est',num2str(K_est),'_',str_now(1:8),'.mat'];
save(filename,'param_mat');
