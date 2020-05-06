function [Y_patch, ref_ab_estimation, ref_ab] = Data_in_batches(Y, ref_estimation, patch_size, ref)

%% Variable Statement
% Y: spectral signatures
% ref_estimation: initialized abundances
% ref: real abundances

[m, n, ~] = size(Y);
Y_patch = cell(1, 1);
ref_ab = cell(1, 1);
ref_ab_estimation = cell(1, 1);

%% if m and n are divisble to 10, then go to the next step
%% otherwise, pixel padding 
if mod(m, 10) ~= 0 & mod(n, 10) ~= 0
   p_row = floor(m / patch_size);
   p_col = floor(n / patch_size);
else
   p_row = (m / patch_size);
   p_col = (n / patch_size);
end

for i = 1 : ceil(m / patch_size)
    for j = 1 : ceil(n / patch_size)
        if i <= p_row & j <= p_col
            SA = Y((i - 1) * patch_size + 1 : i * patch_size, (j - 1) * patch_size + 1 : j * patch_size, :);
            Sref = ref((i-1)*patch_size+1:i*patch_size,(j-1)*patch_size+1:j*patch_size,:);
            Sref_e = ref_estimation((i - 1) * patch_size + 1 : i * patch_size, (j - 1) * patch_size + 1 : j * patch_size, :);
            Y_patch{i, j} = SA;
            ref_ab{i, j} = hyperConvert2d(Sref);
            ref_ab_estimation{i, j} = hyperConvert2d(Sref_e);
        end
        if i > p_row & j <= p_col
            SA = Y((i - 1) * patch_size + 1 : end, (j - 1) * patch_size + 1 : j * patch_size, :);
            Sref = ref((i - 1) * patch_size + 1 : end, (j - 1) * patch_size + 1 : j * patch_size, :);
            Sref_e = ref_estimation((i - 1) * patch_size + 1 : end, (j - 1) * patch_size + 1 : j * patch_size, :);
            Y_patch{i, j} = SA;
            ref_ab{i, j} = hyperConvert2d(Sref);
            ref_ab_estimation{i, j} = hyperConvert2d(Sref_e);
        end
        if i <= p_row & j > p_col
            SA = Y((i - 1) * patch_size + 1 : i * patch_size,(j - 1) * patch_size + 1 : end, :);
            Sref = ref((i - 1) * patch_size + 1 : i * patch_size, (j - 1) * patch_size + 1 : end,:);
            Sref_e = ref_estimation((i - 1) * patch_size + 1 : i * patch_size,(j - 1) * patch_size + 1 : end, :);
            Y_patch{i, j} = SA;
            ref_ab{i, j} = hyperConvert2d(Sref);
            ref_ab_estimation{i, j} = hyperConvert2d(Sref_e);
        end
        if i > p_row & j > p_col
            SA = Y((i - 1) * patch_size + 1 : end,(j - 1) * patch_size + 1 : end, :);
            Sref = ref((i - 1) * patch_size + 1 : end, (j - 1) * patch_size + 1 : end, :);
            Sref_e = ref_estimation((i - 1) * patch_size + 1 : end, (j - 1) * patch_size + 1 : end, :);
            Y_patch{i, j} = SA;
            ref_ab{i, j} = hyperConvert2d(Sref);
            ref_ab_estimation{i, j} = hyperConvert2d(Sref_e);
        end
    end
end

end