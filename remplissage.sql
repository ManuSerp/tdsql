
INSERT INTO `Activites`(`ActID`,`Lieu`,`Bus`,`Theme`,`Jour`) VALUES
(0,'Stade',1,'Rugby',1),
(1,'Piscine',2,'Natation',3),
(2,'LaMeuh',1,'PAF',6);
INSERT INTO `Classes`(`ClassID`,`Enseignant`) VALUES
(0,'Maria'),
(1,'Cotillon'),
(2,'Dumont');


INSERT INTO `Eleves`(`ElevID`,`Nom`,`Age`,`Ville`,`ClassID`) VALUES
(0,'Robin',15,'Metz',0),
(1,'Raoul',13,'Paris',0),
(2,'Martin',14,'Amiens',1),
(3,'Augustin',17,'Blois',1),
(4,'Gregoire',9,'Paris',2),
(5,'Paul',16,'Marseille',2);

INSERT INTO `Repartition`(`ElevID`,`ActID`) VALUES
(0,0),(1,0),(2,1),(3,1),(4,1),(5,2);

