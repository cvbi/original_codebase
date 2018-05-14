function register_and_unmixing(registerChannel, varargin)
% 
%   The following function program will register and perform channel 
%   separation on an image (.oif file). The algorithm will register the 
%   image by aligning the selected channel on the same channel from the 
%   previous time point.
%
%   The unmixing (or channel separation) algorightm uses pca analysis to 
%   determine which channel each data point should be associated with. 
%
% Author: Jonathan Carroll-Nellenback


    if exist( fullfile('software','bioformats','5.3.3'), 'file') == 2   
        addpath( fullfile('.','utility_functions') );
        javaclasspath( fullfile('software','bioformats','5.3.3') );
    else
        addpath( fullfile('.','utility_functions') );
        addpath( fullfile('.','bfmatlab') );
        javaclasspath( fullfile('.','bfmatlab','bioformats_package.jar') );
    end
    

    % Prompt for a file if not input
    [file, path] = uigetfile('*.*', 'Choose an .oif file to open');

    outputdir=[path,file,'.files'];
    [dx,dy,dz,dt,data]=make5d([path,file]);
    [mx,my,mz,mc,mt]=size(data);

    %% Normalize the average intensity
    meanIntensity=mean(mean(mean(data,1),2),3);
    data=uint16(single(data).*repmat(meanIntensity(:,:,:,:,1),mx,my,mz,1,mt)./repmat(meanIntensity,mx,my,mz,1,1));

    %% Redo the pca analysis
    [coeff,data]=my_pca_shuffle(data,4); %get coefficients from first frame

    %% in case data is not in uint16
    data = uint16(data);
    
    %% Overwrite the oif file
	disp('Saving Output File');
    savedata(data,outputdir)    
    disp('Program completed');
    
end