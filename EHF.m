function [E] = EHF(ruta_archivo)

archivo = fopen(ruta_archivo, 'r');
identificador='HF=-';
bandera=false;

while ~feof(archivo)
    linea = fgetl(archivo);
    if contains(linea, identificador)
        bandera=true;
    end
    if bandera==true
        cadena_formato = string(linea);
        valores_str = regexp(cadena_formato, 'HF=[-+]?[0-9]*\.?[0-9]+([eEdD][-+]?[0-9]+)?', 'match');
        valores_str = regexp(valores_str, '[-+]?[0-9]*\.?[0-9]+([eEdD][-+]?[0-9]+)?', 'match');
        E = str2double(valores_str);
        if isempty(E)==true
            E=0;
            break;
        else
            break;
        end
    end
end
fclose(archivo);