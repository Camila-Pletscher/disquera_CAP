using { disquera as my } from '../db/schema';

service DisqueraService {
    entity Bandas as projection on my.Bandas;
    @cds.redirection.target
    entity Discos as projection on my.Discos;
    entity Musicos as projection on my.Musicos;
    entity Centros as projection on my.Centros;
    entity Sesiones as projection on my.Sesiones;
    entity CentrosDiscos as projection on my.CentrosDiscos;
    entity MusicosBandas as projection on my.MusicosBandas;

// punto 1
    entity DisqueraInfo as select from my.Discos{
        nombre,
        banda.nombre as nombre_banda,
        canciones,
        centros.centro.nombre as centros
    };

    @cds.redirection.target
    entity Grabacion as select from my.Sesiones {
        createdAt as creado,
        disco.nombre as nombre,
        disco.banda.nombre as nombre_banda,
        disco.banda.genero as genero,
        disco.banda.musicos.musico.nombre as nombre_musico,
        
    }order by creado desc limit 1;

    function FreeRecordingHours(ID: Integer) returns String;
    function GetMusicoByID(ID:Integer) returns String;

    action CreateMusicos(musicosData: array of Musicos) returns array of Musicos;
    action DeleteMusicos(musicosDelete: array of Musicos) returns String;
    // action DeleteMusicos(ID: array of Integer) returns String;

}