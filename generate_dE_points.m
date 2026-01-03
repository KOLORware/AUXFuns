function dataset = generate_dE_points(N, seed, rmin, rmax)
% GENERATE_TEST_DATASET
% Generate paired Lab samples at controlled CIE76 ΔE distances
%
% dataset = generate_test_dataset(N, seed, rmin, rmax)
%
% Output:
%   dataset : [n x 2 x 3] array
%             dataset(:,1,:) = reference Lab*
%             dataset(:,2,:) = test Lab*
%
% Author: Muhammad Husnain
% Repository: auxfun

%KOLORware copyrights(c) 2026
%www.kolorware.com
%info@kolorware,com
%--------------------------------------------------------------------------
    
if nargin < 2 || isempty(seed),    seed = [];
end
if nargin < 3 || isempty(rmin),    rmin = 1e-3;
end
if nargin < 4 || isempty(rmax),    rmax = 5;
end

% --- RNG ---
if ~isempty(seed),  rng(seed, 'twister');
end

% --- Base Lab and radius ---
% [l0, a0, b0, r] ∈ [0,1]
U = rand(N,4);         
l0 = 100 * U(:,1);
a0 = (U(:,2) - 0.5) * 256;
b0 = (U(:,3) - 0.5) * 256;
r  = U(:,4) * (rmax - rmin) + rmin;

% --- Random direction ---
Z = randn(N,3);         % direction in Lab space
dl = Z(:,1);
da = Z(:,2);
db = Z(:,3);

% --- Normalize and scale to radius r ---
m  = r ./ sqrt(dl.^2 + da.^2 + db.^2);
dl = dl .* m;
da = da .* m;
db = db .* m;

% --- Second Lab point ---
l1 = l0 + dl;
a1 = a0 + da;
b1 = b0 + db;

% --- Pack output: [n × 2 × 3] ---
lab0 = [l0, a0, b0];
lab1 = [l1, a1, b1];

dataset = cat(3, lab0, lab1);