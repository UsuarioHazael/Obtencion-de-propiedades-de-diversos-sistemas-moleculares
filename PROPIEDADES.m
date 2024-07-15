clc, clearvars, close all

%Se define la orientacion '(input orientation)' o '(dipole orientation)'
D_orientacion='(input orientation)';

%Longitudes de onda
lambda=[550 630 800 850 1064.2 1310 1550]';

% Definir la ruta base común (donde se encuentran las salidas) sin el sufijo:
%Ex. "C:\Users\Hazael\Downloads\Tolueno\BMIM-Toluene-BF4_"
ruta_base = 'C:\Users\Hazael\Downloads\Tolueno\BMIM-Toluene-BF4_';

% Definir los sufijos de los archivos
sufijos = {'-0_75-OP.out', '-0_5-OP.out', '-0_4-OP.out'...
    , '-0_2-OP.out', '0_0-OP.out', '0_1-OP.out'...
    , '0_2-OP.out', '0_4-OP.out', '0_7-OP.out'...
    , '1_0-OP.out', '1_25-OP.out', '1_5-OP.out'...
    , '1_75-OP.out', '2_25-OP.out', '3_0-OP.out'...
    , '3_5-OP.out', '4_0-OP.out', '4_5-OP.out'...
    , '5_0-OP.out', '6_0-OP.out', '8_0-OP.out', '10_0-OP.out'};

desplazamientos=[-0.75 -0.5 -0.4 -0.2 0.0 0.1 0.2 0.4 0.7 1.0...
    1.25 1.5 1.75 2.25 3.0 3.5 4.0 4.5 5.0 6.0 8.0 10.0];

% Inicializar las matrices para almacenar los resultados
num_archivos = numel(sufijos);
A = cell(1, num_archivos);

% Iterar sobre los sufijos
for j = 1:num_archivos
    %Concatena ruta base con sufijos y lo itera 22 veces (cantidad de archivos)
    ruta_archivo = [ruta_base, sufijos{j}];  
    
    % Inicializar la matriz para el archivo actual
    A{j} = zeros(size(lambda, 1), 14); %El 12 indica los parametros
    
    % Iterar sobre lambda
    for i = 1:size(lambda, 1)
        %Funciones para obtener los parametros de interes
        [alpha_iso, alpha_aniso] = ALFA(ruta_archivo, D_orientacion, lambda(i, :));
        [beta_tot, beta_proj] = BETTA(ruta_archivo, D_orientacion, lambda(i, :), 1);
        [beta_tot2, beta_proj2] = BETTA(ruta_archivo, D_orientacion, lambda(i, :), 2);
        [gamma_tot, gamma_ave] = GAMMA(ruta_archivo, D_orientacion, lambda(i, :), 1);
        [gamma_tot2, gamma_ave2] = GAMMA(ruta_archivo, D_orientacion, lambda(i, :), 2);
        [promedio_distancias] = D_INT(ruta_archivo);
        [E] = EHF(ruta_archivo);
        % Almacenar los resultados en la matriz correspondiente
        % Y acomoda los parametros de interes
        A{j}(i, :) = [lambda(i, :) desplazamientos(1,j) promedio_distancias... 
            E alpha_iso*(1.4819*10^-25) alpha_aniso*(1.4819*10^-25)... 
            beta_tot*(8.63922*10^-33) beta_tot2*(8.63922*10^-33) beta_proj*(8.63922*10^-33)...
            beta_proj2*(8.63922*10^-33) gamma_tot*(5.03670*10^-40) gamma_tot2*(5.03670*10^-40)...
            gamma_ave*(5.03670*10^-40) gamma_ave2*(5.03670*10^-40)];
    end
end
A=A';
Total=cell2mat(A);
T = array2table(Total);% Se convirtio a una tabla para filtrar
B = []; % Inicializar la matriz vacía para almacenar los datos filtrados

for i = 1:7
    filtro_Total = lambda(i, 1); % Definir el filtro Total
    datos_filtrados = T(T.Total1 == filtro_Total, :); % Filtrar los datos
    B = [B; datos_filtrados]; % Agregar los datos filtrados a la matriz B
end

B.Properties.VariableNames = ["Longitud_de_onda", "Desplazamiento", "Distancia_de_interaccion",... 
    "Energia_HF", "Alpha_isotropico", "Alpha_anisotropico",... 
    "Beta_total", "Beta_total_2", "Beta_total_proyectada",... 
    "Beta_total_proyectada_2", "Gamma_total", "Gamma_total_2",...
    "Gamma_promedio", "Gamma_promedio_2"];

%% Escribe los valores como una matriz de exel
writetable(B, 'Tolueno.xlsx')