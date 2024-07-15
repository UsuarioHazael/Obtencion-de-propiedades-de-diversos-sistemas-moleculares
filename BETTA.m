function [beta_tot, beta_proj] = BETTA(ruta_archivo, D_orientacion, l_onda, armonico)
%Ex. armonico=2;  indica cual armonico se esta trabajando.

% Abre el archivo
archivo = fopen(ruta_archivo, 'r');
orientacion_dipole=['Electric dipole moment ' D_orientacion ':']; 
orientacion_beta=['Beta ' D_orientacion '.']; % es la etiqueta de orientacion
% Inicializa una matriz para almacenar los valores
betaw1 = [];
dipolew1 = [];

if l_onda<1000
    if armonico==1
        longitud_onda=['Beta(-w;w,0) w=  ' num2str(l_onda)];
    elseif armonico==2
        longitud_onda=['Beta(-2w;w,w) w=  ' num2str(l_onda)];
    end
elseif l_onda>=1000
    if armonico==1
        longitud_onda=['Beta(-w;w,0) w= ' num2str(l_onda)];
    elseif armonico==2
        longitud_onda=['Beta(-2w;w,w) w= ' num2str(l_onda)];
    end
end

% Bandera para indicar si se encontró la etiqueta
encontrada_rango_ori_beta=false;
encontrada_rango_ori_dipole = false;
% Bandera para indicar si estamos dentro del rango de interés
en_rango = false;
fila_actual=1;
fila_dipolo=1;

% Lee línea por línea del archivo
while ~feof(archivo)
    linea = fgetl(archivo);
       % Busca la etiqueta de orientacion del momento dipolar
    if contains(linea, orientacion_dipole)
        % Establece la bandera en verdadero
        encontrada_rango_ori_dipole = true;
        continue
    end
    %% Se busca momento dipolar
    if encontrada_rango_ori_dipole && ~(contains(linea, 'Debye'))
        % Convertir la cadena en una sola cadena
        cadena_formato = string(linea);
        % Buscar los números en la cadena usando expresiones regulares
        valores_str = regexp(cadena_formato, '[-+]?[0-9]*\.?[0-9]+([eEdD][-+]?[0-9]+)?', 'match');
        %(MATLAB no entiende D, se cambiara por e)
        valores_aux = cellfun(@(x) str2double(strrep(x, 'D', 'e')), valores_str);
        % Almacenar los valores en la matriz
        dipolew1(fila_dipolo, :) = valores_aux;
        % Aumentar el contador de fila
        fila_dipolo = fila_dipolo + 1;
               % Salir del bucle cuando hayamos leído todos los valores
               if contains(linea, 'z')
                   encontrada_rango_ori_dipole = false;
               end
    end

    %% Busca la etiqueta de orientacion
    if contains(linea, orientacion_beta)
        % Establece la bandera en verdadero
        encontrada_rango_ori_beta = true;
        continue
    end
    %checa que estemos en orientacion y longitud correcta
    if encontrada_rango_ori_beta && contains(linea, longitud_onda)
        % Establece la bandera para indicar que estamos dentro del rango
        en_rango = true;
        % Continúa con la siguiente línea
        continue;
    end

    % Verifica si estamos dentro del rango y no en la línea de unidades
    if en_rango && ~(contains(linea, '(au)'))
        % Convertir la cadena en una sola cadena
        cadena_formato = string(linea);
        % Buscar los números en la cadena usando expresiones regulares
        valores_str = regexp(cadena_formato, '[-+]?[0-9]*\.?[0-9]+([eEdD][-+]?[0-9]+)?', 'match');
        %(MATLAB no entiende D, se cambiara por e)
        valores_aux = cellfun(@(x) str2double(strrep(x, 'D', 'e')), valores_str);
        % Almacenar los valores en la matriz
        betaw1(fila_actual, :) = valores_aux;
        % Aumentar el contador de fila
        fila_actual = fila_actual + 1;
               % Salir del bucle cuando hayamos leído todos los valores
               if contains(linea, 'zzz')
                   break;
               end
    end
end
betaw1=-1*betaw1; %(gaussian no tiene factor de menos -1)
% Cierra el archivo
fclose(archivo);
if armonico==1
    beta_x=(1/3)*(betaw1(7,1)+betaw1(7,1)+betaw1(7,1)...
    +betaw1(14,1)+betaw1(9,1)+betaw1(14,1)...
    +betaw1(22,1)+betaw1(12,1)+betaw1(22,1));

    beta_y=(1/3)*(betaw1(8,1)+betaw1(13,1)+betaw1(8,1)...
    +betaw1(15,1)+betaw1(15,1)+betaw1(15,1)...
    +betaw1(23,1)+betaw1(18,1)+betaw1(23,1));

    beta_z=(1/3)*(betaw1(10,1)+betaw1(19,1)+betaw1(10,1)...
    +betaw1(17,1)+betaw1(21,1)+betaw1(17,1)...
    +betaw1(24,1)+betaw1(24,1)+betaw1(24,1));
    
    beta_tot=sqrt(beta_x^2+beta_y^2+beta_z^2);
elseif armonico==2
    beta_x=(1/3)*(betaw1(7,1)+betaw1(7,1)+betaw1(7,1)...
    +betaw1(13,1)+betaw1(11,1)+betaw1(11,1)...
    +betaw1(22,1)+betaw1(18,1)+betaw1(18,1));

    beta_y=(1/3)*(betaw1(8,1)+betaw1(10,1)+betaw1(10,1)...
    +betaw1(14,1)+betaw1(14,1)+betaw1(14,1)...
    +betaw1(23,1)+betaw1(21,1)+betaw1(21,1));

    beta_z=(1/3)*(betaw1(9,1)+betaw1(16,1)+betaw1(16,1)...
    +betaw1(15,1)+betaw1(20,1)+betaw1(20,1)...
    +betaw1(24,1)+betaw1(24,1)+betaw1(24,1));
    
    beta_tot=sqrt(beta_x^2+beta_y^2+beta_z^2);
end
beta_proj=(dipolew1(2,1)*beta_x+dipolew1(3,1)*beta_y...
    +dipolew1(4,1)*beta_z)/sqrt(dipolew1(2,1)^2+dipolew1(3,1)^2+dipolew1(4,1)^2);
end

