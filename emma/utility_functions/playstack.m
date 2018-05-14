function []=playstack(data,bc,cmap)
%%% Takes a 4D array (MxNxCxT), a brightness contrast array, and a channel mapping
%%% and creates a movie showing each time frame.
  f=figure();
  for i=1:size(data,4)
      my_imshow(data(:,:,:,i),bc,cmap);
      frm(i)=getframe(f);
  end
  delete(f)
  implay(frm)
end