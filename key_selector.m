%  key_selector select a google api key
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

function [ key ] = key_selector( key_counter )
%This function will get a counter and return a google api key

 if key_counter < 1000
          key='"AIzaSyAYMovM80dqfP8kwFXPyO8A-GMSOl-Bmu0"';    
    elseif key_counter < 2000
         key='"AIzaSyAzPFUygHFwOfoU8uzDtSma0sHgoFtRIU4"';     
     elseif key_counter < 3000
          key='"AIzaSyAX0R4PSx9taUbFNyo9Ka5W1dGU2Xt72Dc"';
     elseif key_counter < 4000
          key='"AIzaSyCzAkKfQl93D8xAv_4kyMJSnvX1xz7VT6Q"';
     elseif key_counter < 5000
          key='"AIzaSyD9kWXHHBL4zkXfEPUIzahPJUwXoqygzKU"';
     elseif key_counter < 6000 
        key='"AIzaSyAWyzxfLNLV8ls-hhjGu1tZrTYUjZHnmH0"';
     elseif key_counter < 7000
         key='"AIzaSyDESRe8rnVr4r-be1higwGmfAgE8nOS1CU"';
     elseif key_counter < 8000
         key='"AIzaSyBORRyv4vfrKJ6D73P0qJZjp-dgYlD9If4"';
     elseif key_counter < 9000
         key = '"AIzaSyDdYFocs4Jdvp0DhfbPFNsvZeviNC9x6eo"'; 
    elseif key_counter < 10000
          key='"AIzaSyCFBZevCyqYzwrW-i0mbb0sMtFSUt-rAnA"';
    elseif key_counter < 11000
         key ='"AIzaSyAB5Qtjau-4enAmiWL-a_wMTq5Nvb9QPY8"';
     elseif key_counter < 12000
         key='"AIzaSyDniefmKJNv42I6w7kEkDQc2QLkLs-omQ0"';
 else
         key='"AIzaSyCCweYzxC6BHSFqDbvDr6Jf4k1GNKWpivI"';
        
 end
end

