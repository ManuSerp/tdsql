/*q3*/

SELECT Enseignant, ListeEleves 
FROM Classes AS C JOIN (SELECT ClassID, GROUP_CONCAT(Nom) as ListeEleves FROM Eleves GROUP BY ClassID) AS T 
ON C.ClassID=T.ClassID

/*q4*/

SELECT Jour, GROUP_CONCAT('Bus n°',Bus,' : ',  Nb,' élèves') AS ListeDesBus 
FROM (SELECT ActID, COUNT(ElevID) as Nb FROM Repartition GROUP BY ActID) as C JOIN Activites AS A ON C.ActID=A.ActID
GROUP BY Jour

/*q5*/

SELECT DISTINCT Nom As Eleves FROM
(SELECT Nom, Jour, COUNT(Jour) as Occurence
FROM Eleves as Z JOIN (SELECT ElevID,Jour from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
GROUP BY Nom,Jour) AS A WHERE A.Occurence > 1
