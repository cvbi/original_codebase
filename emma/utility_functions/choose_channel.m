function chnnl = choose_channel(zslice)
% 
% will prompt user to select channel based off images
%   Wil only work with 6 or less channels
%
% Author: Chris Barilla
% Date:  3/23/2017

%% Set Screen
    
    chnnl = 0;

    Pix_SS = get(0,'screensize');
    width = Pix_SS(3) / 2;
    height = Pix_SS(4) / 2;
    x = 10;
    y = Pix_SS(4) - height - 30;
    
    S.fh = figure('units','pixels',...
                  'position',[x y width height],...
                  'menubar','none',...
                  'name','Choose Channel',...
                  'numbertitle','off',...
                  'resize','on');

    numChannels = size(zslice{1},3);
    rows = ceil(numChannels/3);

    for i=1:numChannels
        channelsStr{i} = num2str(i);
        subplot(rows,3,i);
        imshow(imadjust(zslice{1}(:,:,i)));
    end

    
    S.prompt = uicontrol('Style', 'text',...
        'String', 'Select Channel to Register on:',...
        'FontSize',8 ,...
        'Position', [10, 10, 180, 22]);
    
    S.listChannels = uicontrol('Style', 'popup',...
        'String', channelsStr,...
        'Position', [185, 10, 120, 22]);  
    
    S.pb = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[335 10 100 22],...
                 'string','Apply',...
                 'callback',{@pb_call,S});
             
    uiwait(S.fh)  % Prevent all other processes from starting until closed.

    function [] = pb_call(varargin)
    % Callback for the pushbutton.
        chnnl = get(S.listChannels,'Value');
        close(S.fh);  % Closes the GUI, allows the new R to be returned.
    end

end
    


         
