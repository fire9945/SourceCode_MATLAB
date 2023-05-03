addpath('../../Software/sap-voicebox/voicebox');
addpath('../../Software/scripts');

%speech_dir='../../../RT_est/make_data_TIMIT/TIMIT_wav/train';
%speech_lst='../../../RT_est/make_data_TIMIT/etc/TIMIT_train.lst'; 

%speech_dir='../LJSpeech-1.1/wavs_veryshort';
%speech_lst='../LJSpeech-1.1/LJSpeech_veryshort.lst'; 
%speech_dir='../qualcomm/wavs';
%speech_lst='../qualcomm/qualcomm_wav.lst'; 

%speech_dir='../ST-AED/wav_short';
%speech_lst='../ST-AED/ST-AED-short.lst'; 

speech_dir='C:\Users\minsik\Documents\Challenge_Database\ACE\ACE corpus\Speech';
%speech_dir='C:\Users\minsik\Documents\Challenge_Database\Speech\halfsil_speech';
speech_lst='C:\Users\minsik\Documents\Challenge_Database\ACE\ACE corpus\ACEspeech.lst'; 

%speech_dir='../../../TIDIGIT/TIDIGIT_WAV';
%speech_lst='../../../TIDIGIT/tidigits.lst'; 
%%
noise_dir='revnoise_RealRIRs_temp_to1_5';
save_dir='ACEval/';
rir_dir='../Real_RIR_temp_to1_5/';
rir_lst='../Real_RIR_temp_to1_5/RIR.lst';
num_rir=538;
%%


save_dir_tr=[save_dir, 'train'];


rcount=1;
rir_f=fopen(rir_lst,'r');
while(1)
    name=fgetl(rir_f);
    
    if ~ischar(name)
        break;
    end
    mkdir([save_dir_tr, num2str(rcount)]);  
    rcount = rcount+1;        
end

noiseType={'airport','babble', 'car', 'street','train','restaurant'};
num_noise=6;
snrRange = [0 10 20];
snrLabel = {'0dB', '10dB', '20dB'};

%snrRange = [-5 0 5 10 15 20];
%snrLabel = {'-5dB', '0dB', '5dB', '10dB', '15dB', '20dB'};


target_FS = 16000; %Hz
bitsPerSample = 16;

speech_f=fopen(speech_lst,'r');
epoch=0;
max_epoch=1;

while(epoch<max_epoch)
    rir_f=fopen(rir_lst,'r');
    rcount=1;
    while(1)
        name=fgetl(rir_f);
        if ~ischar(name)
            break;
        end
        rir_name=[rir_dir,name];
        [rir, rir_fs] = audioread([rir_dir, '/', rir_name]);    
        rir = resample(rir,target_FS,rir_fs);
        for ncount=1:num_noise
            noise_name=[noiseType{ncount},'_',num2str(rcount),'.wav'];
            [noise, noise_fs] = audioread([noise_dir, '/', noise_name]);    
            noise = resample(noise,target_FS,noise_fs);
            for snrInd = 1:length(snrRange)
                speech_name=fgetl(speech_f);
                    if ~ischar(speech_name)
                        fclose(speech_f);
                        speech_f=fopen(speech_lst,'r');
                        speech_name=fgetl(speech_f);
                    end
                [speech, speech_fs] = audioread([speech_dir, '/', speech_name]);    
                speech = resample(speech,target_FS,speech_fs);
                rev = fftfilt(rir,speech); 
                SNR=snrRange(snrInd);
                noisyrev = v_addnoise(rev,target_FS,SNR,'',noise,target_FS);
                noisyrev = noisyrev/max(max(abs(noisyrev)));
                eval(['audiowrite(''',save_dir_tr, num2str(rcount) , '/',noiseType{ncount},'_',snrLabel{snrInd},'_', speech_name,''',noisyrev,target_FS,''BitsPerSample'',bitsPerSample);']);
                display(['Epoch:','%%%{',num2str(epoch+1),'/',num2str(max_epoch),'}%%%','RIR:',rir_name,'%%%{',num2str(rcount),'/',num2str(num_rir),'}%%%','   noise:',noise_name,'   SNR:',snrLabel{snrInd},'   speech:',speech_name,])
            end
        end
        rcount=rcount+1;
    end
    epoch = epoch + 1;
end
fclose(speech_f);
fclose(rir_f);
copyfile([rir_dir,'gtT60.txt'],[save_dir,'gtT60.txt'])
