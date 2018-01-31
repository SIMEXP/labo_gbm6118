function [tf,tv,auc] = roc_img(img,verite)
% Calcule les taux de faux et vrai positifs dans une image pour differents seuils
% [tf,tv,auc] = roc_img(img,verite_seuils)
%
% Entrees:
%   img (matrice) une image
%   verite (matrice, meme taille que img) image binaire definissant la verite
%     de terrain pour la detection.
%
% Sorties:
%   tf (vecteur) taux de faux positif pour different seuils
%   tv (vecteur) taux de vrai positif pour differents seuils
%   asc (scalaire) l'aire sous la courbe ROC

seuils = unique(img(:));
seuils = seuils(end:-1:1);
seuils = [Inf ; seuils ; -Inf]; % On ajoute un seuil de -Inf (sensibilité parfaite) et Inf (spécificité parfaite)
fp = zeros(length(seuils),1); % Initialisation de la liste des faux positifs observés pour différents seuils
tp = zeros(length(seuils),1); % Initialisation de la liste des vrais positifs observés pour différents seuils
for vv = 1:length(seuils) % On itére sur tous les seuils
    img_t = img>seuils(vv); % On seuille l'image
    tf(vv) = sum(img_t(:)&~verite(:))/sum(~verite(:)); % on calcule le nombre de faux positifs
    tv(vv) = sum(img_t(:)&verite(:))/sum(verite(:));   % on calcule le nombre de vrais positifs
end
auc = trapz(tf,tv);
