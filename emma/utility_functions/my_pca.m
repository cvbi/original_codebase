function [coeff,dataout]=my_pca(data,dim)
   %shift the dimensions to the left dim times to put the desired dimension last
   dataout=reshape(shiftdim(data,dim),[],size(data,dim)); 

   % shift the data to have zero mean  
   dataout=single(dataout)-repmat(mean(dataout,1),size(dataout,1),1); 
   
   % get the coefficients matrix containing the eigenvects
   coeff=pca(dataout); 
    
   % project the data onto the eigenvects
   dataout=dataout*coeff;

   % rescale the data to have the range appropriate for 16 bit unsigned integers
   minval=min(min(dataout)); 
   maxval=max(max(dataout));
   dataout=uint16((dataout-minval)/(maxval-minval)*2^16);

   % reshape the data and shift the dimensions full circle.
   dataout=shiftdim(reshape(dataout,circshift(size(data),[0,-dim])),ndims(data)-dim);
end
