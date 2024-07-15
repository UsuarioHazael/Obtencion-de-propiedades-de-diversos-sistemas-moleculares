function [alpha_iso, alpha_aniso] = ALFA(ruta_archivo, D_orientacion, l_onda)

% Abre el archivo
archivo = fopen(ruta_archivo, 'r');
orientacion=['Alpha ' D_orientacion]; % es la etiqueta de orientacion

if l_onda<1000
    longitud_onda=['Alpha(-w;w) w=  ' num2str(l_onda)];
elseif l_onda>=1000
    longitud_onda=['Alpha(-w;w) w= ' num2str(l_onda)];
end

% Inicializa una matriz para almacenar los valores
alphaw1 = [];
% Bandera para indicar si se encontró la etiqueta
encontrada_rango_ori=false;
% Bandera para indicar si estamos dentro del rango de interés
en_rango = false;
fila_actual=1;

% Lee línea por línea del archivo
while ~feof(archivo)
    linea = fgetl(archivo);   
    % Busca la etiqueta "D_orientacion"
    if contains(linea, orientacion)
        % Establece la bandera en verdadero
        encontrada_rango_ori = true;
        continue
    end
    if encontrada_rango_ori && contains(linea, longitud_onda)
        % Establece la bandera para indicar que estamos dentro del rango
        en_rango = true;       
        % Continúa con la siguiente línea
        continue;
    end
    % Verifica si estamos dentro del rango y no en la línea "(au)"
    if en_rango && ~(contains(linea, '(au)'))
        % Convertir la linea de caracteres en una sola cadena
        cadena_formato = string(linea);
        % Buscar los números en la cadena usando expresiones regulares
        valores_str = regexp(cadena_formato, '[-+]?[0-9]*\.?[0-9]+([eEdD][-+]?[0-9]+)?', 'match');
        %(MATLAB no entiende D, se cambiara por e)
        valores_aux = cellfun(@(x) str2double(strrep(x, 'D', 'e')), valores_str);
        % Almacenar los valores en la matriz
        alphaw1(fila_actual, :) = valores_aux;
        % Aumentar el contador de fila
        fila_actual = fila_actual + 1;
               % Salir del bucle cuando hayamos leído todos los valores
               if contains(linea, 'zz')
                   break;
               end
    end
end
% Cierra el archivo
fclose(archivo);

% Muestra la matriz de valores si se encontró la etiqueta
alpha_iso=(1/3)*(alphaw1(3,1)+alphaw1(5,1)+alphaw1(8,1));
alpha_aniso=sqrt(((alphaw1(3,1)-alphaw1(5,1))^2 ...
    +(alphaw1(3,1)-alphaw1(8,1))^2 ...
    +(alphaw1(5,1)-alphaw1(8,1))^2+...
    6*(alphaw1(4,1)^2+alphaw1(6,1)^2+alphaw1(7,1)^2))/2);