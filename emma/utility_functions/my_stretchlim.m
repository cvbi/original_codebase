function bc=my_stretchlim(data)
%%% Extension to stretchlim for multiple channels.  This just loops over
%%% each channel and calculates the limits using stretchlim
  for i=1:size(data,3)
    bc(:,i)=stretchlim(data(:,:,i));  %brightness contrast array [rl,gl,bl;rh,gh,bh]
  end
end