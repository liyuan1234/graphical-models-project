%[2018]-"Improved binary dragonfly optimization algorithm and wavelet
%packet based non-linear features for infant cry classification" (3)

function ShannonEn = ShannonEntropy(X,~) 
% Convert probability using energy
P    = (X .^ 2) ./ sum(X .^ 2);
% Entropy 
En   = P .* log2(P);
ShannonEn = -sum(En); 
end

