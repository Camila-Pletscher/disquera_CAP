namespace disquera;

using {
    cuid,
    managed
} from '@sap/cds/common';

type Info {
    dni    : Integer;
    rol    : String(50);
    genero : String(50);
}

entity Musicos : managed {
    key ID        : Integer;
        nombre    : String(100);
        bandas    : Association to many MusicosBandas
                        on bandas.musico = $self;
        info      : Info;
        promocion : Boolean default false;
}

entity Bandas : managed {
    key ID      : Integer;
        nombre  : String(100);
        musicos : Association to one MusicosBandas
                      on musicos.banda = $self;
        discos  : Association to many Discos
                      on discos.banda = $self;
        genero  : String(50);
}

entity Discos : managed {
    key ID        : Integer;
        banda     : Association to one Bandas;
        centros   : Association to many CentrosDiscos
                        on centros.disco = $self;
        nombre    : String(100);
        canciones : Integer
}

entity Centros : managed {
    key ID     : Integer;
        nombre : String(100);
        discos : Association to one CentrosDiscos
                     on discos.centro = $self;
}

entity Sesiones : managed {
    key ID     : Integer;
        horas  : Integer;
        disco  : Association to Discos;
        musico : Association to Musicos;

}

entity MusicosBandas {
    musico : Association to one Musicos;
    banda  : Association to one Bandas;
}

entity CentrosDiscos {
    disco  : Association to one Discos;
    centro : Association to one Centros;
}
