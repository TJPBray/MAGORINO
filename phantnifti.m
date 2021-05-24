%Converts .mat files to nifti files for putting ROIs on 
%Uses fat images for ease of viewing

%Define folders for import
phantfolder='/Users/tjb57/Dropbox/MATLAB/Rician FW MRI/datasets';

%Get folder info
phantfolderinfo=dir(phantfolder);

for k=1:(numel(phantfolderinfo)-2)
    
    filename=phantfolderinfo(k+2).name;
    
    %Add name to structure
    data{k}.name=filename;
    
    load(filename)
    
    %Specify folder to load to 
    cd '/Users/tjb57/Dropbox/MATLAB/Rician FW MRI/datasets_nifti'
    
    %Write to folder
    niftiwrite(fwmc_ff,filename)
    
end


    
    