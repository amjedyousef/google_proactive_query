tic; 
clear all; 
close all; 
clc;
%%
%Path to save files (select your own)
my_path='/home/amjed/Documents/Gproject/workspace/data/WSDB_DATA';
%%
%Global Google parameters (refer to https://developers.google.com/spectrum/v1/paws/getSpectrum)
type='"AVAIL_SPECTRUM_REQ"';
height= 30.0; %In meters; Note: 'height' needs decimal value
agl='"AMSL"';
num_of_steps = [1 2 4 8 16 32 64 128 256 512]; % will be increased inside the for loop
key_counter = 0;
fileId = 0 ;
%%

    %The data stored in the file as longitude latitude longitude latitude
    format long;
    long_lat = load('long_lat.txt');
    [r ,c] = size(long_lat);
    ind = randi(r , 1,1);

    %Location data    
    long_start= long_lat(ind , 1);  
    lat_start=long_lat(ind , 2); 
    
    long_end=long_lat(ind , 3); 
    lat_end=long_lat(ind , 4); 
    

    %collect the delay 
    delay_google=[];
    delay_temp=[];
    %Collect the number of locations being queried
    num_of_locations = [];
    
    for i = 1:length(num_of_steps)
            for j = 1:5
                fileId = fileId + 1 ;
                %We need this counter to switch keys once we reachedf 1000
                %or a multiple of it
                key_counter = key_counter + num_of_steps(i) ; % num_of_steps reperesents the  number of locations being queried in one json array (one request)
                %disp(['key_counter' ,num2str(key_counter)]) % for debugging
                 cd([my_path,'/google']);
                 
                [msg_google,delay_google_tmp,error_google_tmp]=...
                    multi_location_query_google_interval(type,lat_start ,lat_end ,long_start,...
                    long_end,num_of_steps(i),height,agl,key_counter, my_path );
                
                delay_te mp = [delay_temp  delay_google_tmp];
                
                % writing the response to a file
                if error_google_tmp==0
                    var_name_txt=strcat(num2str(fileId));
                    var_name_zip=strcat(num2str(fileId))     
                    dlmwrite(['txt/',var_name_txt,'.txt'],msg_google,'');
                    zip(['zip/',var_name_zip], ['txt/',var_name_txt,'.txt']);
                    gzip( ['txt/',var_name_txt,'.txt'] ,'gzip/' );
                end
            end 

            %Get the average of the delay of the same queried area
            delay = sum(delay_temp)/length(delay_temp);
            %collecting the averaged delay 
            delay_google = [delay_google delay];
            delay_temp = [] ;
            delay = [] ;
    end
    
    %%
            
            plot(num_of_steps , delay_google , '-*', 'LineWidth' , 1);
            xlabel('Number of locations per one request');
            ylabel('Delay (sec)');  


%%
['Elapsed time: ',num2str(toc/60),' min']