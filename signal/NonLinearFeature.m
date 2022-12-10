%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0 August 2022   |  Copyright (c) 2022   | All rights reserved       %
%                                                                               %
%                                                                               %
%   Farhad Abedinzadeh torghabeh | Master Student of Biomdeical Engineering     %
%                      farhaad.abedinzade@gmail.com                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [SampleEntropy,ShannonEn,Dispx,MSEnt]=NonLinearFeature(X,m,r,tau)
fprintf('Nonlinear Feature Extraction is Starting ... \n');

if nargin < 4

    
    %     opt = input('Do You Want use Default Options? Yes = 1 | No = 2 > ');
    opt = 1;
    if opt == 1 || opt~=2
        m=2;r=0.2;tau=3;
    else
        m = input('Please Enter m(m is the Embedding Dimension):');
        r = input('Please Enter r(r is the Tolerance Value):');
        tau = input('Please Enter the tau:');
    end
end
 tic
%% sample entropy parameter
% m=opts.m;
% r=opts.r;
% tau=opts.tau;
% if (m < 0 || r < 0)
%     error('Invalid parameter values');
% end

% m is the embedding dimension.
% r is the tolerance value.

for i=1:size(X,2)
%     SampleEntropy(:,i) = SampEn(X(:,i),m,r);
SampleEntropy = [];
    ShannonEn(:,i) = ShannonEntropy(X(:,i));
    [Dispx(:,i), ~] = DispEn(X(:,i));
%     [ MSEnt(:,i), ~, ~ ] = multiscaleSampleEntropy(X(:,i), m, r, tau);
MSEnt = [];

end

fprintf('Nonlinear Feature Extraction is finished ...');
 toc
fprintf('...................................................................\n');
end