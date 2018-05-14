function []=my_imshow(data,bc,cmap)
%%% Extension for imshow that takes a 3D array with an arbitrary number of
%%% channels, a brightness contrast array (bc), and a channel mapping 
%%% (cmap) and creates the correposnding imshow command.

% Create image arrays and brightness contrast arrays with 3 color channels
% and default range of values
tmp=zeros(size(data,1),size(data,2),3,'like',data);
tmpbc=[0,0,0;1,1,1];

% Fill in channels of image and brightness/contrast arrays from input data
% using cmap.
for i=1:numel(cmap)
    if cmap(i) ~= 0
      tmp(:,:,cmap(i))=data(:,:,i);
      tmpbc(:,cmap(i))=bc(:,i);
    end
end

% Draw the image
imshow(imadjust(tmp,tmpbc));
end