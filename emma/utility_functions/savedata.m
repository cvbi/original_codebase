function [result]=savedata(data5d,dir)
h = waitbar(0,'Please wait...');
steps = size(data5d,4)*size(data5d,5);
step=0;
for k=1:size(data5d,5)   
    for i=1:size(data5d,4)
        step=step+1;
        waitbar(step/steps);
        for j=1:size(data5d,3)
            filename=[dir,sprintf('%ss_C%3.3dZ%3.3dT%3.3d.tif',filesep, i, j, k)];
            imwrite(squeeze(data5d(:,:,j,i,k)),filename);
        end
    end   
end
close(h)
end
