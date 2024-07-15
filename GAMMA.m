function [gamma_tot, gamma_ave] = GAMMA(ruta_archivo, D_orientacion, l_onda, armonico)
%ex. armonico=2;
% Abre el archivo
archivo = fopen(ruta_archivo, 'r');
orientacion=['Gamma ' D_orientacion];
% Inicializa una matriz para almacenar los valores
gammaw1 = [];
if l_onda<1000
    if armonico==1
        longitud_onda=['Gamma(-w;w,0,0) w=  ' num2str(l_onda)];
    elseif armonico==2
        longitud_onda=['Gamma(-2w;w,w,0) w=  ' num2str(l_onda)];
    end
elseif l_onda>=1000
    if armonico==1
        longitud_onda=['Gamma(-w;w,0,0) w= ' num2str(l_onda)];
    elseif armonico==2
        longitud_onda=['Gamma(-2w;w,w,0) w= ' num2str(l_onda)];
    end
end

% Bandera para indicar si se encontró la etiqueta
encontrada_rango_ori=false;
% Bandera para indicar si estamos dentro del rango de interés
en_rango = false;
fila_actual=1;

% Lee línea por línea del archivo
while ~feof(archivo)
    linea = fgetl(archivo);
    
    % Busca la etiqueta linea
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
    % Verifica si estamos dentro del rango y no en la línea "zzzz"
    if en_rango && ~(contains(linea, '(au)'))
        % Convertir la cadena en una sola cadena
        cadena_formato = string(linea);
        % Buscar los números en la cadena usando expresiones regulares
        valores_str = regexp(cadena_formato, '[-+]?[0-9]*\.?[0-9]+([eEdD][-+]?[0-9]+)?', 'match');
        %(MATLAB no entiende D, se cambiara por e)
        valores_aux = cellfun(@(x) str2double(strrep(x, 'D', 'e')), valores_str);
        % Almacenar los valores en la matriz
        gammaw1(fila_actual, :) = valores_aux;
        % Aumentar el contador de fila
        fila_actual = fila_actual + 1;
               % Salir del bucle cuando hayamos leído todos los valores
               if contains(linea, 'zzzz')
                   break;
               end
    end
end
gammaw1=-1*gammaw1; %(gaussian no tiene factor de menos -1)
% Cierra el archivo
fclose(archivo);
if armonico==1
    gamma_x=(1/15)*(gammaw1(3,1)+gammaw1(3,1)+gammaw1(3,1)...
    +gammaw1(10,1)+gammaw1(10,1)+gammaw1(15,1)...
    +gammaw1(24,1)+gammaw1(24,1)+gammaw1(33,1));
    
    gamma_y=(1/15)*(gammaw1(10,1)+gammaw1(10,1)+gammaw1(5,1)...
        +gammaw1(17,1)+gammaw1(17,1)+gammaw1(17,1)...
        +gammaw1(31,1)+gammaw1(31,1)+gammaw1(35,1));
    
    gamma_z=(1/15)*(gammaw1(24,1)+gammaw1(24,1)+gammaw1(8,1)...
        +gammaw1(31,1)+gammaw1(31,1)+gammaw1(20,1)...
        +gammaw1(38,1)+gammaw1(38,1)+gammaw1(38,1));
    
    gamma_tot=sqrt(gamma_x^2+gamma_y^2+gamma_z^2);
    gamma_ave=gamma_x+gamma_y+gamma_z;
elseif armonico==2
    gamma_x=(1/15)*(gammaw1(3,1)+gammaw1(3,1)+gammaw1(3,1)...
    +gammaw1(9,1)+gammaw1(24,1)+gammaw1(24,1)...
    +gammaw1(18,1)+gammaw1(48,1)+gammaw1(48,1));

    gamma_y=(1/15)*(gammaw1(22,1)+gammaw1(7,1)+gammaw1(7,1)...
    +gammaw1(28,1)+gammaw1(28,1)+gammaw1(28,1)...
    +gammaw1(37,1)+gammaw1(52,1)+gammaw1(52,1));

    gamma_z=(1/15)*(gammaw1(41,1)+gammaw1(14,1)+gammaw1(14,1)...
    +gammaw1(47,1)+gammaw1(35,1)+gammaw1(35,1)...
    +gammaw1(56,1)+gammaw1(56,1)+gammaw1(56,1));
    
    gamma_tot=sqrt(gamma_x^2+gamma_y^2+gamma_z^2);

    gamma_ave=gamma_x+gamma_y+gamma_z;
end
end