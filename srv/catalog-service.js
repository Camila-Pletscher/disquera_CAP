const cds = require('@sap/cds');
const { Musicos, Sesiones } = cds.entities

module.exports = cds.service.impl(function () {

  // ENUNCIADO: interprete que habia que contar las horas de todas las sesiones de los musicos para calcular la promoción. Por eso primero traje las sesiones por musico, si el musico tenia mas de una sesion sumaba todas las horas y ahi podia determinar si conseguia las 2 horas gratis o no. 

  this.on('FreeRecordingHours', async (req) => {
    const { ID } = req.data;

    //OBTENGO EL MUSICO DE LA SESION X ID 
    const sesionesTotales = await SELECT.from(Sesiones).columns('ID', 'horas').where({ musico_ID: ID });
    console.log(sesionesTotales);

    //SUMO LAS HORAS DE GRABACION POR SI HAY MAS DE UNA SESION 
    const totalHorasHoy = sesionesTotales.reduce((total, sesion) => total + sesion.horas, 0);
    console.log(totalHorasHoy);

    //CONDICIONAL PARA LAS HORAS GRATIS // CAMBIO EL BOOLEAN DE GRATIS
    if (totalHorasHoy >= 6) {
      await UPDATE(Musicos, ID).set({ promocion: true });

      // SUMO 2 HORAS A LA SESION DE ESE MUSICO 
      for (const sesion of sesionesTotales) {
        await UPDATE(Sesiones, sesion.ID).set({ horas: sesion.horas + 2 }).where({ musico_ID: ID });
      }
      return "Tenes 2 horas de grabación gratis y el campo 'gratis' se ha actualizado a true.";
    } else
      return "No cumples los requisitos para horas gratis.";

  });

  //ACTION POR NUEVOS MUSICOS 
  this.on('CreateMusicos', async (req) => {
    const { musicosData } = req.data;
    console.log(musicosData);
    const newMusicosData = await INSERT.into(Musicos).entries(musicosData);
    return newMusicosData;
  })

  //ACTION DELETE VARIOS MUSICOS 
  this.on('DeleteMusicos', async (req) => {
    const { musicosDelete } = req.data;
    console.log(musicosDelete);

    for (const musico of musicosDelete) {
      await DELETE(Musicos).where({ ID: musico.ID });
    }

    return "Se eliminaron varios musicos";
  })

  //RECUPERAR MUSICO POR ID  
  this.on('GetMusicoByID', async (req) => {
    const { ID } = req.data;

    const [musico] = await SELECT.from(Musicos).columns('nombre').where({ ID: ID });

    if (musico) {
      console.log(musico);
      return `Músico: ${musico.nombre}`;
    } else {
      return 'Músico no encontrado';
    }
  })


});
