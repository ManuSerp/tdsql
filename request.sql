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

/*q6*/

SELECT Nom FROM
(SELECT Nom,COUNT(Jour) as Presence FROM
(SELECT Nom,Jour
FROM Eleves as Z JOIN (SELECT ElevID,Jour from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
GROUP BY Nom,Jour) AS A
GROUP BY Nom) AS B WHERE B.Presence = (SELECT COUNT(DISTINCT Jour) From Activites)

/*q7*/

SELECT *
FROM Eleves as Z JOIN (SELECT ElevID,Jour,Lieu from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
WHERE Ville=Lieu




/*q8*/
SELECT Activites,effectif FROM (SELECT GROUP_CONCAT(Theme) AS Activites,effectif,COUNT(effectif) AS ce FROM
(SELECT Theme, effectif FROM (SELECT ActID,Theme FROM Activites) AS A JOIN (
SELECT ActID,COUNT(ElevID) as effectif FROM Repartition
GROUP BY ActID) AS B ON A.ActID=B.ActID) AS F
GROUP BY effectif) AS G WHERE G.ce >1