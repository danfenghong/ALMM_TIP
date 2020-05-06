function [A_est, S_est, B_est, E_est, A_truth_patch, EM_est, AB_map] = ALMM(Y3d, endM, E_init, param, maxiter, flag, A_true)

%% Input:
%         Y3d       - HSI with the size of l*m*n
%                     l: the number of spectral bands
%                     m: the length of the HSI
%                     n: the width  of the HSI
%         endM      - given endmembers extracted by endmember extraction
%                     methods, e.g., VCA, PPI
%         E_init    - initialized spectral variability dictionary generated
%                     a random orthogonal matrix in our case
%         param     - parameters
%                   - alfa  : for abundance maps
%                   - beta  : for spectral variability coefficient
%                   - gama  : for spectral variability dictionary 
%                   - eta   : for spectral variability dictionary
%                   - mk    : the length or width of a patch
%         maxiter   - maximum iteration number
%         flag      - noBlind or Blind to control whether blind unmixing
%         A_true    - ground truth for abundacnes

%% Output:
%         A_est     - estimated abundaces
%         S_est     - estimated scaling factors
%         B_est     - estimated coefficient w.r.t. the spectral variability
%                     dictionary (E)
%         E_est     - estimated spectral variability dictionary
%         EM_est    - estimiated endmembers (if blind unmixing)
%         AB_map    - estimiated abundance maps

%% Abundances initialization using scaled constrained least squares unmixing (SCLSU)

        [m, n, ~] = size(Y3d);
        Y = hyperConvert2d(Y3d);
        
        A_SCLSU = sunsal(endM, Y, 'lambda', 0, 'ADDONE', 'no', 'POSITIVITY', 'yes', ...
                         'AL_iters', 200, 'TOL', 1e-3, 'verbose','yes');
        A_init = A_SCLSU ./ repmat(sum(A_SCLSU), size(A_SCLSU, 1), 1);
        
%% Data generated in batches
% the patch must be square (length = width).

        [~, p] = size(endM);
        A_esti3d = hyperConvert3d(A_init, m, n, p);
        
        if ~exist('A_true','var')
            A_true = zeros(p, m * n);
        end
        
        A_true3d = hyperConvert3d(A_true, m, n, p);
        
        [Y_patch, A_esti3d_patch, A_true3d_patch] = Data_in_batches(Y3d, A_esti3d, param.mk, A_true3d);
        
%% Data generated in batches
        
       A_est = []; %estimated abundances by ALMM
       S_est = []; %zeros(1,m*n); %estimated scaling factors by ALMM
       B_est = []; %estimated coefficient by ALMM
       A_truth_patch = []; %real abundances
       E_est = cell(1,1); %estimated spectral variability dictionary by ALMM
       EM_est_temp = cell(1,1); %estimated endmembers (spectral bundles), if blindly unmixing
       EM_est = 0;
       AB_map = zeros(m, n, p); %estimated abundamce maps
       k = 0; % counter
       
       if strcmp(flag, 'noBlind')
           
           i_end = 0;
            
           for i = 1 : ceil(m / param.mk)
                
                i_st = i_end + 1;
                i_end = i_end + size(Y_patch{i, 1}, 1);
                j_end = 0;

                for j = 1 : ceil(n / param.mk)
                    
                    j_st = j_end + 1;
                    j_end = j_end + size(Y_patch{i, j}, 2);

                    k = k+1;
                    
                    temp_Y = hyperConvert2d(Y_patch{i,j});
                    [A_est_temp, S_est_temp, B_est_temp, E_est{1,k}] ...
                                 = ALMM_DL(temp_Y, endM, E_init, A_esti3d_patch{i,j}, param.alfa, param.beta, ...
                                   param.gama, param.eta,maxiter);

                     A_est = [A_est, A_est_temp];
                     S_est = [S_est, S_est_temp];
                     B_est = [B_est, B_est_temp];
                     A_truth_patch = [A_truth_patch, A_true3d_patch{i,j}];
                     AB_map(i_st : i_end, j_st : j_end, :) = hyperConvert3d(A_est_temp, size(Y_patch{i,j},1), size(Y_patch{i,j}, 2),  p);

                end
            end
       else 
           
           i_end = 0;
           
           for i = 1 : ceil(m / param.mk)
                
                i_st = i_end + 1;
                i_end = i_end + size(Y_patch{i, 1}, 1);
                j_end = 0;

                for j = 1 : ceil(n / param.mk)
                    
                    j_st = j_end + 1;
                    j_end = j_end + size(Y_patch{i, j}, 2);

                    k = k+1;
                    
                    temp_Y = hyperConvert2d(Y_patch{i,j});
                    [A_est_temp, S_est_temp, B_est_temp, E_est{1,k}, EM_est_temp{1,k}] ...
                             = ALMM_DL_blind(temp_Y, endM, E_init, A_esti3d_patch{i,j}, param.alfa, param.beta, ...
                               param.gama, param.eta,maxiter);
                   
                     A_est = [A_est, A_est_temp];
                     S_est = [S_est, S_est_temp];
                     B_est = [B_est, B_est_temp];
                     A_truth_patch = [A_truth_patch, A_true3d_patch{i,j}];
                     EM_est = EM_est + EM_est_temp{1,k};
                     AB_map(i_st : i_end, j_st : j_end, :) = hyperConvert3d(A_est_temp, size(Y_patch{i,j},1), size(Y_patch{i,j}, 2),  p);

                end
           end   
           EM_est = EM_est / k;
       end
end