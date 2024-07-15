function [promedio_distancias] = D_INT(ruta_archivo)

archivo = fopen(ruta_archivo, 'r');
identificador='Charge =  0 Multiplicity = 1';
bandera=false;
i=0;

while ~feof(archivo)
    linea = fgetl(archivo);
    if contains(linea, identificador)
        bandera=true;
        continue;
    end
    if bandera==true
        cadena_formato = string(linea);
        valores_str = regexp(cadena_formato, '[-+]?[0-9]*\.?[0-9]+([eEdD][-+]?[0-9]+)?', 'match');
        x = str2double(valores_str) ;
        i=i+1;
        Posiciones(i, :) = x;
    end
    if i==30
        break;
    end
end
fclose(archivo);

dist1=sqrt(sum((Posiciones(25,:)-Posiciones(2,:)).^2));
dist2=sqrt(sum((Posiciones(23,:)-Posiciones(2,:)).^2));
dist3=sqrt(sum((Posiciones(23,:)-Posiciones(20,:)).^2));
dist4=sqrt(sum((Posiciones(25,:)-Posiciones(6,:)).^2));
dist5=sqrt(sum((Posiciones(10,:)-Posiciones(24,:)).^2));
promedio_distancias=(dist1+dist2+dist3+dist4+dist5)/5;