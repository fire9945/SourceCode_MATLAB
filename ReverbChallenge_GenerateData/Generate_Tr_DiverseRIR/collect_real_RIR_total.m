%save_dir='RIRs_temp_to1_5';
%rir_dirs={'Sim_RIRs_temp_to1_5','Real_RIR_temp_to1_5'};

save_dir='Real_RIR_temp_to1_5_check';
%rir_dirs={'openair_entire'};
rir_dirs={'Aachen_RIRs','REVERB_RIRs','RWCP_RIRs','openair_entire'};

%save_dir='train_RIRs';
%rir_dirs={'Sim_RIRs','Real_RIRs'};

mkdir(save_dir);
target_FS=16000;

gtT60ID=fopen([save_dir, '/gtT60.txt'],'w');
RIRlistID=fopen([save_dir,'/RIR.lst'],'w');
num_rir=0;
for dirIdx = 1:size(rir_dirs,2)
    rir_list=dir(rir_dirs{dirIdx});
    num_rir=num_rir+size(rir_list,1)-2;
end
estT60hist=zeros(1,num_rir);
rcount=1;
for dirIdx = 1:size(rir_dirs,2)
    rir_list=dir(rir_dirs{dirIdx});
    for ririndex=3:size(rir_list,1)
        display(rir_list(ririndex).name);
        [RIR, Fs]=audioread([rir_dirs{dirIdx},'/',rir_list(ririndex).name]);
        num_ch=size(RIR,2);
        RIR=resample(RIR,target_FS,Fs);
        for ch_index=1:1
            [val, idx] = max(abs(RIR(:,ch_index)));
            ir = RIR(idx:end,ch_index);        
            [rt, ~] = t60_ir_nonlinfit(ir, target_FS, 0);

            if rt > 0.1 && rt < 1.5
                estT60hist(rcount)=rt; 
                fprintf(gtT60ID,'%f\n', rt);
                fprintf(RIRlistID,'%s\n', [rir_dirs{dirIdx},'_',int2str(ririndex-2),'_ch',int2str(ch_index),'.wav']);
                audiowrite([save_dir,'/',rir_dirs{dirIdx},'_',int2str(ririndex-2),'_ch',int2str(ch_index),'.wav'],ir,target_FS);
                rcount=rcount+1;
            end        

        end
    end
end
fclose(gtT60ID);
fclose(RIRlistID);
xlim([0.05 1.6])
%%
f = figure;
set(f,'position',[100,100,800,300])
hist(nonzeros(estT60hist),0.1:0.05:1.5);
xlim([0 1.6])
ax=gca;
ax.FontSize=15;



