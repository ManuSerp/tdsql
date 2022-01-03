
INSERT INTO `Activites`(`ActID`,`Lieu`,`Bus`,`Theme`,`Jour`) VALUES
(0,'Stade',1,'Rugby',1),
(1,'Piscine',2,'Natation',3),
(2,'LaMeuh',1,'PAF',6);
INSERT INTO `Classes`(`ClassID`,`Enseignant`) VALUES
(0,'Maria'),
(1,'Cotillon'),
(2,'Dumont');

INSERT INTO `Repartition`(`ElevID`,`ActID`) VALUES
(0,0),(1,0),(2,1),(3,1),(4,1),(5,2);
