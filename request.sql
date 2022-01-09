/*q3*/
/* On groupe les eleves par ClassID pour obtenir l'effectif de chaques classes puis ont fait une jointure pour obtenir le professeur de chaque classes. */

SELECT Enseignant, ListeEleves 
FROM Classes AS C JOIN (SELECT ClassID, GROUP_CONCAT(Nom) as ListeEleves FROM Eleves GROUP BY ClassID) AS T 
ON C.ClassID=T.ClassID

/*q4*/
/* on groupe les eleves par activites via une jointure entre repartition et activites puis on groupe le nombre d'eleves et le bus par jours*/ 
SELECT Jour, GROUP_CONCAT('Bus n°',Bus,' : ',  Nb,' élèves') AS ListeDesBus 
FROM (SELECT ActID, COUNT(ElevID) as Nb FROM Repartition GROUP BY ActID) as C JOIN Activites AS A ON C.ActID=A.ActID
GROUP BY Jour

/*q5*/
/* on choisis fait une jointure de eleves et repartition puis une jointure sur activites
ensuite on choisit les noms parmis les noms et jours des eleves groupés par jours et nom avec la conditions COUNT(jours)>1 */

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

select ActID, LENGTH(GROUP_CONCAT(ElevID)) as nb_eleve
from repartition
GROUP by ActID  
HAVING nb_eleve = (SELECT MAX(len) FROM (select ActID, LENGTH(GROUP_CONCAT(ElevID)) as len from repartition  GROUP by ActID   ) as T) 

 
/*q10*/

SELECT Theme, effectif FROM (SELECT ActID,Theme FROM Activites) AS A JOIN (
SELECT ActID,COUNT(ElevID) as effectif FROM Repartition
GROUP BY ActID ) AS B ON A.ActID=B.ActID  ORDER BY effectif DESC, A.ActID
SELECT Nom,jour,Theme
FROM Eleves as Z JOIN (SELECT ElevID,Jour,Lieu,Theme from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
WHERE Ville=Lieu

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
SELECT X,Y,nb FROM((
SELECT e1.ElevID as X, e2.ElevID as Y from Eleves as e1,Eleves as e2 
WHERE e1.ClassID!=e2.ClassID) as T)
WHERE 
(SELECT COUNT(T1.ActID) as nb
from (SELECT ActID from  Repartition where ElevID=X ) as T1 
INNER JOIN (SELECT ActID from  Repartition where ElevID=Y ) as T2 ON T1.ActID=T2.ActID) >0





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
