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
    key='"AIzaSyAfbZXBX5ZUq8Ux19h-XHb8SP19vNvghmY"';
elseif key_counter < 2000
    key='"AIzaSyCMEduOKdv_VZlNBQdzTXKzV_lKKMCJkEc"';
elseif key_counter < 3000
    key='"AIzaSyBW2b0HgPnv4922F9b6KtH7P9CrPU2H4GU"';
elseif key_counter < 4000
    key='"AIzaSyDeCuuOoRfDrXO5W5Fd-Js_IUNS4-PFFNo"';
elseif key_counter < 5000
    key='"AIzaSyDrvbHX9qtoBE27a3gGEdwa2UzYfzDgyX8"';
elseif key_counter < 6000
    key='"AIzaSyBpvmvux9H2uA696wyS3On0QwkPEmkSoj4"';
elseif key_counter < 7000
    key='"AIzaSyCg11sdt6F_twljdEn26zwGKazvvhNkL2c"';
elseif key_counter < 8000
    key='"AIzaSyDRcbZiM8y8lPqmEp7p7CBWku9GmnV5uPQ"';
elseif key_counter < 9000
    key = '"AIzaSyDgLBJTUpwPQ2q1HOEMxkAKG8qYmH4rqHo"';
elseif key_counter < 10000
    key='"AIzaSyDSSLVLmXG-1Z7TB4KkLWy912hlwGzo6ig"';
elseif key_counter < 11000
    key ='"AIzaSyAFnWosvYlOgm4PtzcgqoOZ6XsH4twOHjE"';
elseif key_counter < 12000
    key='"AIzaSyAF3D6geK2hJm5iDtadkbDYe66mwiVEJtE"';
elseif key_counter < 13000
    key='"AIzaSyBGXMtOR8Ft4KKFqjyc6GRO7m2R8OfJdpA"';
elseif key_counter < 14000
    key='"AIzaSyDl6Oef9zk_nrGLAxEfBawVCt1y9NryXd0"';
elseif key_counter < 15000
    key='"AIzaSyCCweYzxC6BHSFqDbvDr6Jf4k1GNKWpivI"';
elseif key_counter < 16000
    key='"AIzaSyBE-GOIVm2-uhWKeB1oINpmoSeyl7dUi3A"';
elseif key_counter < 17000
    key='"AIzaSyAl9rewC1BA-FQyu3iN5xb06_7d9eiiArU"';
elseif key_counter < 18000
    key='"AIzaSyBw4Pt8NYYIwRo-9GHsMWbqzlWVLO90_5c"';
elseif key_counter < 19000
    key='"AIzaSyDniefmKJNv42I6w7kEkDQc2QLkLs-omQ0"';
elseif key_counter < 20000
    key='"AIzaSyCDriOhv2l_pXTMkTLab3oJk0zVstjY-Hw"';
elseif key_counter < 21000
    key='"AIzaSyDdYFocs4Jdvp0DhfbPFNsvZeviNC9x6eo"';
elseif key_counter < 22000
    key='"AIzaSyB4sYk0TxrMElO2X4KjkhwjZBM2Xk49kuk"';
elseif key_counter < 23000
    key='"AIzaSyCX5QLIbuWlyRE32uRe9VkdmDjn7T-Won8"';
elseif key_counter < 24000
    key='"AIzaSyA9uNfnvSK1JpiYGd3VcCHM555U1ul7lxc"';
elseif key_counter < 25000
    key='"AIzaSyCAdizltwoqC3uDKpNH799inmGJHWrJJgM"';
else
    key='"AIzaSyAEHyYlYbuealIsdSWXc4G3HLR6MU8VElk"';
    
end
end

