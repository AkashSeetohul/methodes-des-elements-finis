function [] = erreur_en_h()

  h = linspace(0.1, 1, 10); % initialisation des tailles du maillage de 0.1 à 1.0

  % on initialise les arrays pour les erreurs de P1 et P2, et pour les normes euclidiennes et infinies
  erreur_euclidien_P1 = zeros(size(h));
  erreur_euclidien_P2 = zeros(size(h));
  erreur_infinie_P1 = zeros(size(h));
  erreur_infinie_P2 = zeros(size(h));

  for i = 1:size(h)
    [approx_u_degre_1, noeuds_maillage_P1] = resoudre_edp(h, 1);
    [approx_u_degre_2, noeuds_maillage_P2] = resoudre_edp(h, 2);

    % on parcourt les noeuds du maillage P1
    % on calcule les "vrais" valeurs de la solution à chaque noeud
    % on ajoutera la norme de la différrence entre u_solution et u_approximé
    for j = 1:size(noeuds_maillage_P1, 1)
      u = cos(pi * noeuds_maillage_P1(j,1)) * cos(pi * noeuds_maillage_P1(j,2));
      erreur_euclidien_P1(i) = erreur_euclidien_P1(i) + norm(approx_u_degre_1(j) - u);
      erreur_infinie_P1(i) = max(erreur_euclidien_P1(i), norm(approx_u_degre_1(j) - u));
    endfor

    % on parcourt les noeuds du maillage P2
    % on calcule les "vrais" valeurs de la solution à chaque noeud
    % on ajoutera la norme de la différrence entre u_solution et u_approximé
    for j = 1:size(noeuds_maillage_P2, 1)
      u = cos(pi * noeuds_maillage_P2(j,1)) * cos(pi * noeuds_maillage_P2(j,2));
      erreur_euclidien_P2(i) = erreur_euclidien_P2(i) + norm(approx_u_degre_2(j) - u);
      erreur_infinie_P2(i) = max(erreur_euclidien_P2(i), norm(approx_u_degre_2(j) - u));
    endfor
  endfor

  plot(h, log(log(erreur_euclidien_P1))), '--';
  hold on
  plot(h, log(log(erreur_infinie_P1)));
  plot(h, log(log(erreur_euclidien_P2)), '--');
  plot(h, log(log(erreur_infinie_P2)));
  hold off

  xlabel('h')
  ylabel('log(log(erreur))');
  legend('Erreur euclidien en P1', 'Erreur infinie en P1', 'Erreur euclidien en P2', 'Erreur infinie en P2');

% résultat des erreurs
##erreur_euclidien_P1 =
##
##   64.8590   19.9170   11.8410    7.3494    5.3495    6.4019    4.3675    4.5344    4.4617    2.4505
##
##erreur_euclidien_P2 =
##
## Columns 1 through 9:
##
##   1089.000    303.670    160.680     91.690     65.425     69.243     38.715     43.153     50.462
##
## Column 10:
##
##     18.795
##
##erreur_infinie_P1 =
##
##   0.4794   0.4883   0.4987   0.5157   0.5358   0.5935   0.5701   0.5586   0.5290   0.6210
##
##erreur_infinie_P2 =
##
##   5.0052   4.8156   4.8389   4.7851   4.8278   4.9441   4.9661   4.7596   4.7091   2.6445
##

% On retrouvera un erreur plus élevé pour la norme euclidienne qui diminue avec l'augmentation de la taille h, mais c'est expliqué par le fait qu'il y a plus de noeuds de maillage et donc plus d'erreur additioné à chaque étape.
% on retrouvera néanmois que l'erreur maximum (avec la norme infinie) est le minimum avec le plus petit h, qui explique que l'approximation devient plus précise avec une maillage à taille h plus petite.
