function register_pca(id, varargin)
addpath /software/bioformats/5.3.3
% Prompt for a file if not input
if nargin == 0 || exist(id, 'file') == 0
    [file, path] = uigetfile('*.*', 'Choose a file to open');
    id = [path file];
    if isequal(path, 0) || isequal(file, 0), return; end
end
outputdir=[path,file,'.files'];
[dx,dy,dz,dt,data]=make5d([path,file]);
[mx,my,mz,mc,mt]=size(data);
cmap=[1,2];

%% Normalize the average intensity
meanIntensity=mean(mean(mean(data,1),2),3);
data=uint16(single(data).*repmat(meanIntensity(:,:,:,:,1),my,mx,mz,1,mt)./repmat(meanIntensity,my,mx,mz,1,1));

%% Redo the pca analysis
[coeff,data]=my_pca_shuffle(data,4); %get coefficients from first frame

%% And plot the results
%data4d=uint16(squeeze(mean(data(:,:,:,:,:),3)));
%bc=my_stretchlim(data4d)
%playstack(data4d,bc,cmap)

%% Image registration
[optimizer,metric]=imregconfig('monomodal')
optimizer.MaximumIterations=300;

%% register stack
for i=1:mt
    moving=data(:,:,:,1,i);
    fixed=data(:,:,:,1,max(1,i-1));
    tform{i}=imregtform(moving,fixed,'translation',optimizer,metric);
end

%% Accumulate transforms by matrix multiplication
for i=2:mt
    tform{i}.T=tform{i-1}.T*tform{i}.T
end

%% Apply the transform to both channels
for i=1:mt
    for j=1:2
        data(:,:,:,j,i)=imwarp(data(:,:,:,j,i),tform{i},'OutputView',imref3d([my,mx,mz]));
    end
end

%%
save([path,file,'.mat'],'tform','meanIntensity','coeff');
savedata(data,outputdir)
end