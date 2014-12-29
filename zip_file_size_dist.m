%This script calculate the size of files and plot the distribution
%further it calculate the overall redaction persentage in size 
%   Amjad Yousef Majid  
%   Reference: [1] "Will Dynamic Spectrum Access Drain my
%   Battery?", submitted for publication, July 2014

%   Code development: 

%   Last update: 29 Dec 2014

%   This work is licensed under a Creative Commons Attribution 3.0 Unported
%   License. Link to license: http://creativecommons.org/licenses/by/3.0/

clc
clear
txt_sizes = [];
zip_sizes = [];
gzip_sizes = [];
num_of_files_to_be_read = 33 ;

txt_dir=dir('/home/amjed/Documents/Gproject/workspace/data/WSDB_DATA/google/txt/');
zip_dir=dir('/home/amjed/Documents/Gproject/workspace/data/WSDB_DATA/google/zip/');
gzip_dir=dir('/home/amjed/Documents/Gproject/workspace/data/WSDB_DATA/google/gzip/');

for i = 1:num_of_files_to_be_read
    % we need to use the strcmp to control the which file to read
    str  = [num2str(i) , '.txt'];
    index = strcmp({txt_dir.name}, str)
    
    txt_fileSize = txt_dir(index).bytes;
    zip_fileSize = zip_dir(index).bytes;
    tar_fileSize = gzip_dir(index).bytes;
   txt_sizes = [txt_sizes txt_fileSize];
   zip_sizes = [zip_sizes zip_fileSize];
   gzip_sizes = [gzip_sizes tar_fileSize];
end

%%
%Ploting the figures 
subplot(3,1,1)
bar(txt_sizes )
title('Plain text message sizes')
ylabel('Message size (bytes)')

subplot(3,1,2)
bar(zip_sizes , 'r' , 'EdgeColor' , 'r')
title('Zipped message sizes')
ylabel('Message size (bytes)')

subplot(3,1,3)
bar(gzip_sizes , 'g' , 'EdgeColor','g')
title('Gzipped message sizes')
ylabel('Message size (bytes)');
xlabel('Number of queries');

%%
red_zip =  (   (sum(txt_sizes) - sum(zip_sizes)) / sum(txt_sizes))  * 100 ;
fprintf('zip  overall reduction is %.2f %%  \n' , red_zip);  

red_tar =  (   (sum(txt_sizes) - sum(gzip_sizes)) / sum(txt_sizes))  * 100 ;
fprintf('tar overall reduction is %.2f %%  \n' , red_tar);  