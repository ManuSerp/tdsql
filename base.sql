 
CREATE TABLE `Eleves` (
  `ElevID` int(11) NOT NULL,
  `Nom` varchar(100) NOT NULL,
  `Age` int(11) NOT NULL,
  `Ville` varchar(100) NOT NULL,
  `ClassID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `Classes` (
  `ClassID` int(11) NOT NULL,
  `Enseignant` varchar(100) NOT NULL
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `Activites` (
  `ActID` int(11) NOT NULL,
  `Lieu` varchar(100) NOT NULL,
  `Bus` int(11) NOT NULL,
  `Theme` varchar(100) NOT NULL,
  `Jour` int(11) NOT NULL
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8;