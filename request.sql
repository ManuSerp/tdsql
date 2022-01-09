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

SELECT DISTINCT Nom
FROM Eleves as Z JOIN (SELECT ElevID,Jour,Lieu from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
WHERE Ville=Lieu

/*q8*/
SELECT Activites,effectif FROM (SELECT GROUP_CONCAT(Theme) AS Activites,effectif,COUNT(effectif) AS ce FROM
(SELECT Theme, effectif FROM (SELECT ActID,Theme FROM Activites) AS A JOIN (
SELECT ActID,COUNT(ElevID) as effectif FROM Repartition
GROUP BY ActID) AS B ON A.ActID=B.ActID) AS F
GROUP BY effectif) AS G WHERE G.ce >1


/*q9*/
SELECT a1,a2 FROM(
SELECT T1.ActID as a1, T2.ActID as a2, COUNT(T1.ElevID) as nb
FROM (SELECT ElevID,ActID FROM repartition ) AS T1 ,(SELECT ElevID,ActID FROM repartition )AS T2 WHERE T1.ElevID=T2.ElevID
GROUP BY T1.ActID,T2.ActID 
HAVING a1!=a2) as temp
WHERE nb=(SELECT MAX(nb) FROM (
SELECT T1.ActID as a1, T2.ActID as a2, COUNT(T1.ElevID) as nb
FROM (SELECT ElevID,ActID FROM repartition ) AS T1 ,(SELECT ElevID,ActID FROM repartition )AS T2 WHERE T1.ElevID=T2.ElevID
GROUP BY T1.ActID,T2.ActID 
HAVING a1!=a2) as temp1)

/*On calcule le nombre d'élève partagé entre deux activité et on selectionne les pairs qui en ont le plus*/


 
/*q10*/
SELECT Theme, effectif FROM (SELECT ActID,Theme FROM Activites) AS A JOIN (
SELECT ActID,COUNT(ElevID) as effectif FROM Repartition
GROUP BY ActID ) AS B ON A.ActID=B.ActID  ORDER BY effectif DESC, A.ActID

/*q11*/
SELECT Enseignant
from classes as C 
JOIN (SELECT ClassID,COUNT(ClassID) as effectif FROM eleves GROUP BY ClassID ) as D
on C.ClassID=D.ClassID
where effectif > (select AVG(ListeEleves) from (SELECT COUNT(ClassID) as ListeEleves FROM Eleves GROUP BY ClassID) as A)


 
/*q12*/

SELECT Theme,MIN(Age) as Min,MAX(Age) as Max, AVG(Age) as Moyenne, -MIN(Age)+MAX(Age) as Amplitude
FROM Eleves as Z JOIN (SELECT ElevID,Theme from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
GROUP BY Theme

/*q13*/

SELECT Theme, Ville FROM 
(SELECT Ville, Theme,COUNT(Z.ElevID) as hab
FROM Eleves as Z JOIN (SELECT ElevID,Theme from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
GROUP BY Ville, Theme) as tb
WHERE hab = (SELECT MAX(hab) FROM (SELECT Theme,COUNT(Z.ElevID) as hab
FROM Eleves as Z JOIN (SELECT ElevID,Theme from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
GROUP BY Ville, Theme)as m WHERE m.Theme=tb.Theme)

/*q14*/

SELECT Nom,jour,Theme
FROM Eleves as Z JOIN (SELECT ElevID,Jour,Lieu,Theme from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
WHERE Ville=Lieu


/*q15*/
SELECT Lieu, COUNT(ElevID)/(SELECT COUNT(ActID) 
FROM Repartition) from Activites NATURAL JOIN Repartition GROUP by Lieu
 
/*q16*/
(SELECT T1.ElevID as X,T2.ElevID as Y
from (SELECT ActID,ElevID from Repartition ) as T1 INNER JOIN (SELECT ActID,ElevID from Repartition ) as T2 ON T1.ActID=T2.ActID
WHERE T1.ElevID!=T2.ElevID)


/*On réalise une intersection sur les actID, puis on trie le résultat pour éviter les doublons types X,Y =Y,X*/



/*q17*/


SELECT cleff.ClassID,Theme FROM
(SELECT ClassID, Theme, eff FROM 
(SELECT  ClassID,ActID,COUNT(A.ElevID) as eff
FROM Eleves AS A JOIN Repartition AS B ON A.ElevID=B.ElevID
GROUP BY ClassID,ActID) as effect JOIN Activites AS K ON effect.ActID=K.ActID) as acteff
JOIN
(SELECT ClassID,COUNT(ElevID) as classe_effectif FROM Eleves
GROUP BY ClassID) as cleff
ON acteff.ClassID = cleff.ClassID
WHERE eff=classe_effectif
