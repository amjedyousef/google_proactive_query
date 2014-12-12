function [response , delay , error] =  multi_location_query_google_interval...
    (request_type, latitude_start, latitude_end, longitude_start,...
    longitude_end ,num_of_steps,height,agl, key_counter, my_path)
%%
error=false; %Default error value
delay=[]; %Default delay value

server_name='https://www.googleapis.com/rpc';
text_coding='"Content-Type: application/json ; charset=utf-8; "';
device_type='"MODE_2"'; %Types of TVWS device: http://en.wikipedia.org/wiki/TV-band_device
%%
 if key_counter < 1000
         key='"AIzaSyAYMovM80dqfP8kwFXPyO8A-GMSOl-Bmu0"';%API selection
    elseif key_counter < 2000
         key='"AIzaSyAX0R4PSx9taUbFNyo9Ka5W1dGU2Xt72Dc"';
     elseif key_counter < 3000
         key='"AIzaSyCzAkKfQl93D8xAv_4kyMJSnvX1xz7VT6Q"';
     elseif key_counter < 4000
         key='"AIzaSyDESRe8rnVr4r-be1higwGmfAgE8nOS1CU"';
     elseif key_counter < 5000
          key='"AIzaSyBE-GOIVm2-uhWKeB1oINpmoSeyl7dUi3A"';
     elseif key_counter < 6000
          key='"AIzaSyCFBZevCyqYzwrW-i0mbb0sMtFSUt-rAnA"';
     else
         key='"AIzaSyBORRyv4vfrKJ6D73P0qJZjp-dgYlD9If4"';
 end

%%
query_generator_interval...
    (request_type,device_type,latitude_start,latitude_end ,...
    longitude_start, longitude_end ,num_of_steps,height,agl,key, my_path)

%my_path=regexprep(my_path,' ','\\ ');

cmnd=['/usr/bin/curl -X POST   ',server_name,' -H ',text_coding,' --data-binary @',my_path,'/google/google.json -w %{time_total}'];
%cmnd=['/usr/bin/curl -X POST  ',server_name,' -v -i -H "accept-encoding: gzip" ',text_coding,' --data-binary @',my_path,'/google.json -w %{time_total}'];
[status,response]=system(cmnd);
disp(response)
disp('status ----->')
disp(status)
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
    longitude_start, longitude_end ,num_of_steps,height,agl,key, my_path)
%This function will generate the json array requests along a line between
%two points

% Dividing the distance into segmets to be queried gradually 
distance_divider = 256 ;

 cd([my_path,'/google']);
%To start the json array
dlmwrite('google.json','[','delimiter','');

longitude = linspace(longitude_start,longitude_end , distance_divider);
latitude = linspace(latitude_start,latitude_end , distance_divider);

% This is need it in order to dynamically add  and remove the comma to
% separate json object correctly 
    if num_of_steps > 1
        comma = ',';
    else
        comma = '';
    end
    
%     if num_of_steps == 1
%         count = 1;
%     else 
%         count = num_of_steps - 1; % -1 is need it because initially it is set to 1 and then increased by 10
%     end
    
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
        '"capabilities": { "frequencyRanges": [{ "startHz": 800000000, "stopHz": 850000000 }, { "startHz": 900000000, "stopHz": 950000000 }] }, ',...
        '"key": ',key,...
        '},"id": "any_string"}',comma];

    dlmwrite('google.json',request,'-append','delimiter','');
end
%close the json array
dlmwrite('google.json',']','-append','delimiter','');
end
