% google_locations_query query google WSDB poactively (multi-location in one request)
%   Last update: 11 January 2015

% Reference:
%   P. Pawelczak et al. (2014), "Will Dynamic Spectrum Access Drain my
%   Battery?," submitted for publication.

%   Code development: Amjed Yousef Majid (amjadyousefmajid@student.tudelft.nl),
%                     Przemyslaw Pawelczak (p.pawelczak@tudelft.nl)

% Copyright (c) 2014, Embedded Software Group, Delft University of
% Technology, The Netherlands. All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
%
% 1. Redistributions of source code must retain the above copyright notice,
% this list of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright
% notice, this list of conditions and the following disclaimer in the
% documentation and/or other materials provided with the distribution.
%
% 3. Neither the name of the copyright holder nor the names of its
% contributors may be used to endorse or promote products derived from this
% software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
% HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
% TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
tic;
clear;
close all;
clc;
%%
%Path to save files (select your own)
my_path='/home/amjed/Documents/Gproject/workspace/data/WSDB_DATA';
%%
num_of_steps = [1 2 4 8 16 32 64 128];% 256];
num_of_query_per_location = 20;
distance_divider =  num_of_steps(length(num_of_steps));
key_counter = 0; % used to switch google api keys 
fileId = 0 ;
%Global Google parameters (refer to https://developers.google.com/spectrum/v1/paws/getSpectrum)
height= 30.0; %In meters; Note: 'height' needs decimal value
start_freq_1 =  800000000 ;
stop_freq_1 = 850000000 ;
start_freq_2 = 900000000;
stop_freq_2 = 950000000 ;
agl='"AMSL"';
request_type='"AVAIL_SPECTRUM_REQ"';
device_type='"MODE_2"'; %Types of TVWS device: http://en.wikipedia.org/wiki/TV-band_device
%%
%The data stored in the file as longitude latitude longitude latitude
long_lat = load('long_lat.txt');
[r ,c] = size(long_lat);
delay_google_vec = [];
for k=1:r
    %Location data
    long_start= long_lat(k , 1);
    lat_start=long_lat(k , 2);
    long_end=long_lat(k , 3);
    lat_end=long_lat(k , 4);
    
    %collect the delay
    delay_temp=[];
    delay_google=[];
    for i = 1:length(num_of_steps)
        for j = 1:num_of_query_per_location
            fileId = fileId + 1 ;
            %We need this counter to switch keys once we reachedf 1000
            %or a multiple of it
            key_counter = key_counter + num_of_steps(i) ; % num_of_steps reperesents the  number of locations being queried in one json array (one request)
            cd(my_path);
            
            [msg_google,delay_google_tmp,error_google_tmp]=...
                multi_location_query_google_interval(...
                lat_start ,lat_end ,long_start,long_end,num_of_steps(i),height ,...
                distance_divider ,key_counter, my_path,agl,request_type,device_type,...
                start_freq_1 ,stop_freq_1 ,start_freq_2, stop_freq_2);
            
            % writing the response to a file
            if error_google_tmp==0
                delay_temp = [delay_temp  delay_google_tmp];
                var_name_txt=strcat(num2str(fileId));
                var_name_zip=strcat(num2str(fileId));
                var_name=(['google_', num2str(fileId) , '_',datestr(clock, 'DD_mm_YYYY_HH_MM_SS')]);
                
                dlmwrite([var_name,'.txt'],msg_google,'');
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