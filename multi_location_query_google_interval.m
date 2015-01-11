function [response , delay , error] =  multi_location_query_google_interval...
    ( latitude_start, latitude_end, longitude_start,...
    longitude_end ,num_of_steps,height, distance_divider, key_counter, my_path,agl,request_type,device_type,...
    start_freq_1 ,stop_freq_1 ,start_freq_2, stop_freq_2)
% multi_location_query_google_interval query google WSDB poactively (multi
%location in one request)
%   Last update: 10 January 2015

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
%%
%Global Google parameters (refer to https://developers.google.com/spectrum/v1/paws/getSpectrum)
server_name='https://www.googleapis.com/rpc';

error=false; %Default error value
delay=[]; %Default delay value
text_coding='"Content-Type: application/json ; charset=utf-8; "';
%%
key = key_selector(key_counter);

%%
query_generator_interval...
    (request_type,device_type,latitude_start,latitude_end ,...
    longitude_start, longitude_end ,num_of_steps,height,distance_divider ,agl,key, my_path,...
    start_freq_1 ,stop_freq_1 ,start_freq_2, stop_freq_2);

my_path=regexprep(my_path,' ','\\ ');

cmnd=['/usr/bin/curl -X POST   ',server_name,' -H ',text_coding,' --data-binary @',my_path,'/google.json -w %{time_total}'];
%cmnd=['/usr/bin/curl -X POST  ',server_name,' -v -i -H "accept-encoding: gzip" ',text_coding,' --data-binary @',my_path,'/google.json -w %{time_total}'];
[status,response]=system(cmnd);

%check for error
err = findstr('error' , response);
if ~isempty(err)
    error = true;
end

warning_google='Daily Limit Exceeded'; %Error handling in case of exceeed API limit
if ~isempty(findstr(response,warning_google));
    fprintf('API limit exceeded - quitting.\n');
    return;
else
    end_query_str='"FccTvBandWhiteSpace-2010"';
    begining = findstr('{' ,response);
    response = response(begining(1):end);
    pos_end_query_str=findstr(response,end_query_str);
    % This number needs to be change with number of locations
    pos_end_query_str = pos_end_query_str(end);
    
    length_end_query_str=length(end_query_str)+21; %Note: constant 21 added due to padding of '}' in JSON response
    delay=  str2num(response(pos_end_query_str+length_end_query_str:end));
    response(pos_end_query_str+length_end_query_str:end)=[];
end
system('rm google.json');

end

function  query_generator_interval...
    (request_type,device_type,latitude_start,latitude_end ,...
    longitude_start, longitude_end ,num_of_steps,height,distance_divider,agl,key, my_path,...
    start_freq_1 ,stop_freq_1 ,start_freq_2, stop_freq_2)
%This function will generate the json array requests along a line between
%two points

% Dividing the distance into segmets to be queried gradually

longitude = linspace(longitude_start,longitude_end , distance_divider);
latitude = linspace(latitude_start,latitude_end , distance_divider);

% This is need it in order to dynamically add  and remove the comma to
% separate json object correctly
if num_of_steps > 1
    comma = ',';
else
    comma = '';
end

cd(my_path);
%To start the json array
dlmwrite('google.json','[','delimiter','');

for i = 1:num_of_steps
    if i == num_of_steps
        comma='';
    end
    request=['{"jsonrpc": "2.0",',...
        '"method": "spectrum.paws.getSpectrum",',...
        '"apiVersion": "v1explorer",',...
        '"params": {',...
        '"type": ',request_type,', ',...
        '"version": "1.0", ',...
        '"deviceDesc": ',...
        '{ "serialNumber": "your_serial_number", ',...
        '"fccId": "TEST", ',... %21 June 2014: fix to FCC's "OPSXX ids" case: replace "OPS13" with "TEST" [https://groups.google.com/forum/#!topic/google-spectrum-db-discuss/qitm_hgbw4A]
        '"fccTvbdDeviceType": ',device_type,' }, ',...
        '"location": ',...
        '{ "point": ',...
        '{ "center": ',...
        '{"latitude": ',num2str(latitude(i)),', '...
        '"longitude": ',num2str(longitude(i)),'} } },',...
        '"antenna": ',...
        '{ "height": ',num2str(height),', ',...
        '"heightType": ',agl,' },',...
        '"owner": { "owner": { } }, ',...
        '"capabilities": { "frequencyRanges": [{ "startHz":',num2str(start_freq_1),', "stopHz": ',num2str(stop_freq_1),' }, { "startHz": ',num2str(start_freq_2),', "stopHz": ',num2str(stop_freq_2),' }] }, ',...
        '"key": ',key,...
        '},"id": "any_string"}',comma];
    
    dlmwrite('google.json',request,'-append','delimiter','');
end
%close the json array
dlmwrite('google.json',']','-append','delimiter','');
end
