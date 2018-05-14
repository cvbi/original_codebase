function [y,ntags]=trajectory_tag(proplist,maxd)
% For each time step and each centroid, we work backwards in time trying to find the nearest
% centroid point within 10 pixels not already associated with a closer
% centroid at the current time step.

ntags=0; %unique tag label

% loop forwards in time
for t=1:numel(proplist)

    % Get number of cells at current time and initialize their tags to zero
    ncells=numel(proplist{t});
    for i=1:ncells
        proplist{t}(i).tag=0;
    end
    
    % Start to work backwards to find a close enough neighbor not
    % associated with a different current particle

    for t1=t-1:-1:1 %compare current frame with all previous frames until every cell has a tag
    
        % Get list of unassigned cells at current time
        unassigned=find([proplist{t}(:).tag]==0);
        if ~ any(unassigned) %then we are done
            break
        end
        
        % Get list of tags already assigned to other cells at current time
        badtags=[proplist{t}([proplist{t}(:).tag] > 0).tag]; 
        
        % Get number of cells at previous time to build distance matrix
        noldcells=numel(proplist{t1});
        d=zeros(numel(unassigned), noldcells);

        for j=1:noldcells
            if (any(proplist{t1}(j).tag == badtags)) %Don't pair with old cells already in trajectories of current cells
                d(:,j)=Inf;
            else
                for i=1:numel(unassigned)                           
                    d(i,j)=sqrt(sum((proplist{t1}(j).Centroid-proplist{t}(unassigned(i)).Centroid).^2));
                end
            end
        end
        
        %Then find the shortest distances and make the connection
        for i=1:min(size(d))
            [y,indx]=min(d(:));
            if (y > maxd)  %then we are done
                break
            end
            [j,k]=ind2sub(size(d),indx);
            proplist{t}(unassigned(j)).tag=proplist{t1}(k).tag;
            d(j,:)=Inf;
            d(:,k)=Inf;
        end
    end
    % Any still unassigned after going back to beginning should get new
    % unique tag
    unassigned=find([proplist{t}(:).tag]==0);
    for i=1:numel(unassigned)
        ntags=ntags+1;
        proplist{t}(unassigned(i)).tag=ntags;        
    end
end
y=proplist;
end
