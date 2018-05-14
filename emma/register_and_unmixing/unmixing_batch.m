function unmixing_batch()
%
%   register_batch() will ask for your oif files that you want to register
%   as well as the channel to register on for each file. Then is will run
%   the registrations programs
%
%
    oif_files = [];
    ix = 0;
    bool = 1;
    while bool
       
        [file, path] = uigetfile('*.*', 'Choose an .oif file to open');
        oif_file = [path,file];

        eif isnumeric(file)
            msg=[];
            msg{1} = ['Since you did not choose an .oif file this job will not be included in batch'];
            msg{2} = 'Would you like to add another file to the batch?';
        else
            msg=[];
            ix = ix + 1;
            oif_files{ix} = oif_file;
            msg{1} = 'Would you like to add another file to the batch?';
    end
        
            choice = questdlg(msg, ...
                'Add another file to batch?', ...
                'Yes','No and run batch','Cancel and quit batch','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    bool = 1;
                case 'No and run batch'
                    bool = 0;
                case 'Cancel and quit batch'
                    disp('quiting')
                    return
            end
    end

    disp('running batch')
    
    for i = 1:length(oif_files)
        oif_file = oif_files{i};
        disp(['running unmixing(' oif_file ')']);
        disp(['job ' num2str(i) ' of ' num2str(length(oif_files))])
        unmixing(oif_file);
    end
    
    disp('batch complete')

end

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
