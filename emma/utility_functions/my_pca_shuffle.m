function [coeff,dataout]=my_pca_shuffle(data,dim)
   %shift the dimensions to the left dim times to put the desired dimension last
   dataout=reshape(shiftdim(data,dim),[],size(data,dim)); 

   % shift the data to have zero mean  
   dataout=double(dataout)-repmat(mean(dataout,1),size(dataout,1),1); 
   
   % get the coefficients matrix containing the eigenvects
   coeff=pca(dataout); 
    
   %% Reorder principal components to minimize impact on channel order
   mc=size(data,dim);
   mind=trace(eye(mc)-abs(coeff));
   for i=perms([1:mc])'
       mcoeff=coeff(:,i);
       d=trace(eye(mc)-abs(mcoeff));
       if d <= mind
           mind=d;
           mincoeff=mcoeff;
       end
   end
   coeff=mincoeff;
   for i=1:mc
      if (coeff(i,i) < 0)
          coeff(:,i)=-coeff(:,i)
      end
   end

   % project the data onto the eigenvects
   dataout=dataout*coeff;

   % rescale the data to have the range appropriate for 16 bit unsigned integers
   minval=min(min(dataout)); 
   maxval=max(max(dataout));
   dataout=uint16((dataout-minval)/(maxval-minval)*2^16);

   % reshape the data and shift the dimensions full circle.
   dataout=shiftdim(reshape(dataout,circshift(size(data),[0,-dim])),ndims(data)-dim);
end
