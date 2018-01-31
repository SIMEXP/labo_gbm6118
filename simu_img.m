function [img,verite] = simu_img(taille,amp,fwhm)
% Genere une simulation d'image avec bruit de Poisson
% [img,verite] = simu_img(taille,amp,fwhm)
%
% Entrees:
%    taille (vecteur 1x2, defaut [8 1])
%      Premier coefficient: taille du carre "cible" (en pixels).
%      Deuxieme coefficient: nombre de carres dans l'image.
%    amp (vecteur 1x2, defaut [100 200])
%      1er coefficient: amplitude du signal dans l'arriere plan de l'image
%      2ieme coefficient: amplitude du signal dans l'avant plan de l'image
%    fwhm (scalaire, defaut 0)
%      full-width-at-half-maximum (en pixels) d'un noyau de convolution Gaussien,
%      modélisant la résolution intrinséque de l'image
%
% Sorties:
%    img (matrice) une image simulee.
%    verite (matrice) une image binaire. L'arriere-plan est rempli de zeros,
%      et l'avant-plan est rempli de 1.
%
% Note: le signal est genere via un processus de Poisson.
% Exemple:
%     [img,verite] = simu_img([8 3],[50 100],3)
% (C) MIT license, P. Bellec DIRO Universite de Montreal 2017

if nargin < 1
    taille = [8 1];
end

if nargin < 2
    amp = [100 200];
end

if nargin < 3
    fwhm = 0;
end

% Genere la verite de terrain
n = taille (1);
bord = ceil(n/2);
himg = n+2*bord;
verite = false(2*n+himg,2*n + taille(2)*himg);
for cc = 1:taille(2)
    xmin = bord+n+1;
    xmax = bord+n+taille(1);
    ymin = xmin+himg*(cc-1);
    ymax = xmax+himg*(cc-1);
    verite(xmin:xmax,ymin:ymax) = true;
end

% Genere l'image
img = zeros(size(verite));
img(verite) = poissrnd_pm(amp(2),sum(verite(:)));
img(~verite) = poissrnd_pm(amp(1),sum(~verite(:)));

% Ajoute du flou sur l'image
if fwhm>0
    nx = size(verite,2);
    grid = (1:nx)-(nx+1)/2;
    [x,y] = meshgrid(grid,grid);
    sig2 = fwhm^2/(8*log(2));
    ker = exp((-x.^2 - y.^2)/(2*sig2))/(2*pi*sig2);
    img = conv2(img,ker,'same');
end
