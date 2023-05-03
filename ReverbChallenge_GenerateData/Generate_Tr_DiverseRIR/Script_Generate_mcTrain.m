WSJ_dir_name='C:\Users\식식\Documents\Database\WSJCAM0';
DATA_dir_name='../Data_Diverse';

%save_dir='C:\Users\식식\Documents\Database\REVERB_WSJCAM0_DiverseTr_Type1';
%Generate_DiverseTR_Type1_cut(WSJ_dir_name, save_dir, DATA_dir_name)

save_dir='C:\Users\식식\Documents\Database\REVERB_WSJCAM0_DiverseTr_Type2';
Generate_DiverseTR_Type2_cut(WSJ_dir_name, save_dir, DATA_dir_name)

%주의할점: speech signal, RIR, noise의 row x col ..
%speech: 1 x length
%RIR: length x num_channel
%noise: length x num_channel