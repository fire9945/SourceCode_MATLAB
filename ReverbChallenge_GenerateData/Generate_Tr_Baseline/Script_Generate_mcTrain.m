WSJ_dir_name='C:\Users\식식\Documents\Database\WSJCAM0';
DATA_dir_name='../Data';

save_dir='C:\Users\식식\Documents\Database\REVERB_WSJCAM0_tr';

Generate_mcTrainData_cut(WSJ_dir_name, save_dir, DATA_dir_name)

%주의할점: speech signal, RIR, noise의 row x col ..
%speech: 1 x length
%RIR: length x num_channel
%noise: length x num_channel