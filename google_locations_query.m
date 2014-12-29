%   Amjad Yousef Majid  
%   Reference: [1] "Will Dynamic Spectrum Access Drain my
%   Battery?", submitted for publication, July 2014

%   Code development: 

%   Last update: 29 Dec 2014

%   This work is licensed under a Creative Commons Attribution 3.0 Unported
%   License. Link to license: http://creativecommons.org/licenses/by/3.0/

tic; 
clear; 
close all; 
clc;
%%
%Path to save files (select your own)
my_path='/home/amjed/Documents/Gproject/workspace/data/WSDB_DATA';
%%
%Global Google parameters (refer to https://developers.google.com/spectrum/v1/paws/getSpectrum)
height= 30.0; %In meters; Note: 'height' needs decimal value
num_of_steps = [1 2 4 8 16 32 64]% 128] %256]; 
distance_divider =  num_of_steps(length(num_of_steps));
key_counter = 0;
fileId = 0 ;
num_of_query_per_location = 20;
%%
    %The data stored in the file as longitude latitude longitude latitude
    format long;
    long_lat = load('long_lat.txt');
    [r ,c] = size(long_lat);
    delay_google_vec = [];
for k=1:r    
        %Location data    
        long_start= long_lat(k , 1)
        lat_start=long_lat(k , 2)
        long_end=long_lat(k , 3)
        lat_end=long_lat(k , 4)


        %collect the delay 
        delay_temp=[];
        delay_google=[];
        for i = 1:length(num_of_steps)
                for j = 1:num_of_query_per_location
                    fileId = fileId + 1 ;
                    %We need this counter to switch keys once we reachedf 1000
                    %or a multiple of it
                    key_counter = key_counter + num_of_steps(i) ; % num_of_steps reperesents the  number of locations being queried in one json array (one request)
                     cd([my_path,'/google']);
                    
                    [msg_google,delay_google_tmp,error_google_tmp]=...
                        multi_location_query_google_interval(...
                        lat_start ,lat_end ,long_start,long_end,num_of_steps(i),height , distance_divider ,key_counter, my_path );

                    delay_temp = [delay_temp  delay_google_tmp];

                    % writing the response to a file
                    if error_google_tmp==0
                        var_name_txt=strcat(num2str(fileId));
                        var_name_zip=strcat(num2str(fileId));     
                         var_name=(['google_', num2str(fileId) , '_',datestr(clock, 'DD_mm_YYYY_HH_MM_SS')]);
                     
                         dlmwrite(['data/',var_name,'.txt'],msg_google,'');
                        %The following output used in zip_file_size_dist.m
                        %and for compression 
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
        hold on
            plot(num_of_steps , delay_google , '-*', 'LineWidth' , 1);
            xlabel('Number of locations per one request');
            ylabel('Delay (sec)');  
            delay_google_vec = [delay_google_vec delay_google];
            delay_google = []; % reset required for the next step
end
legend('10km','10km','10km','50km','across US')
hold off

%%
['Elapsed time: ',num2str(toc/60),' min']