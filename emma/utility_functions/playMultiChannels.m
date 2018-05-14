function playMultiChannels(data, mt, mc, chs)

    clear zslice
    for i=1:mt
        zslice{i}=squeeze(uint16(mean(data(:,:,:,:,i),3))); %note mean returns a double so we need to convert it back to uint16
    end
    size(zslice{1});
    for i=chs
        bc(:,i)=stretchlim(zslice{1}(:,:,i));  %brightness contrast array [rl,gl,bl;rh,gh,bh]
    end
    cmap = [1:numel(chs)];
    clf
    for i=1:mt
        my_imshow(zslice{i}(:,:,chs),bc,cmap);
        frm(i)=getframe();    
    end
    implay(frm);
end