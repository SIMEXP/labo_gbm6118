function samp = poissrnd_pm(lambda,size_samp,size_samp2)
% Genere du bruit de Poisson
% Syntaxe: samp = poissrnd_pm(lambda,size_samp)
%
% lambda (scalaire) parametre du processus
% size_samp (vecteur d'entiers) taille de l'echantillon.
% samp (matrice de taille size_samp) echantillons de Poisson
%
% (C) Pierre Bellec 2016

if nargin<1
    error('please specify lambda');
end

if nargin<2
    size_samp = 1;
end

if (nargin==3)&&(length(size_samp)==1)
    size_samp = [size_samp size_samp2];
end
if length(size_samp)==1
    size_samp = [size_samp 1];
end
if lambda>=100
    %% Use a Gaussian approximation for large lambda
    samp = round(sqrt(lambda)*randn(size_samp)+lambda);
    samp(samp<0) = 0;
else

    samp = zeros(size_samp);
    prob = ones(size_samp);
    mask = true(size_samp);
    thresh = exp(-lambda);
    while any(mask(:))
        prob(mask) = prob(mask).*rand(sum(mask(:)),1);
        mask = prob > thresh;
        samp(mask) = samp(mask)+1;
    end
end
