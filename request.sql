/*q3*/
/* On groupe les élèves par ClassID pour obtenir l'effectif de chaque classes puis ont fait une jointure pour obtenir le professeur de chaque classes. */

SELECT Enseignant, ListeEleves 
FROM Classes AS C JOIN (SELECT ClassID, GROUP_CONCAT(Nom) as ListeEleves FROM Eleves GROUP BY ClassID) AS T 
ON C.ClassID=T.ClassID

/*q4*/
/* on groupe les eleves par activités via une jointure entre Repartition et Activites puis on groupe le nombre d'élèves et le bus par jours*/ 
SELECT Jour, GROUP_CONCAT('Bus n°',Bus,' : ',  Nb,' élèves') AS ListeDesBus 
FROM (SELECT ActID, COUNT(ElevID) as Nb FROM Repartition GROUP BY ActID) as C JOIN Activites AS A ON C.ActID=A.ActID
GROUP BY Jour

/*q5*/
/* on fait une jointure de élèves et Repartition puis une jointure sur Activites
ensuite on choisit les noms parmis les noms et jours des élèves groupés par jours et noms avec la condition COUNT(jours)>1 */

SELECT DISTINCT Nom As Eleves FROM
(SELECT Nom, Jour, COUNT(Jour) as Occurence
FROM Eleves as Z JOIN (SELECT ElevID,Jour from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
GROUP BY Nom,Jour) AS A WHERE A.Occurence > 1


/*q6*/
/*
On fait une jointure sur toutes les tables puis on groupe les noms en comptant les jours distincts pour obtenir
le nombre de jours d'activités pour chaques personnes. Ensuite on selectionne les noms qui font aux moins un nombre d'activités égale au nombre de jours où il y a 
des activités.

*/

SELECT Nom FROM
(SELECT Nom,COUNT(DISTINCT Jour) as Presence FROM
(SELECT Nom,Jour
FROM Eleves as Z JOIN (SELECT ElevID,Jour from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID) AS A
GROUP BY Nom) AS B WHERE B.Presence = (SELECT COUNT(DISTINCT Jour) From Activites)



/*q7*/

/* On fait une jointure de toutes les bases puis on selectionne les nom où ville de résidence correspond au lieu de l'activité. */

SELECT DISTINCT Nom
FROM Eleves as Z JOIN (SELECT ElevID,Jour,Lieu from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
WHERE Ville=Lieu

/*q8*/

/*   Par jointure entre Activites et Repartition on donnes les tables des effectifs de chaques activités, 
puis on groupe la table par effectif pour avoir les activités de même effectif,avec un COUNT pour connaitre le nombre d'activités de même effectif, 
puis on choisit celle qui sont plus d'une de même effectif. */

SELECT Activites,effectif FROM (SELECT GROUP_CONCAT(Theme) AS Activites,effectif,COUNT(effectif) AS ce FROM
(SELECT Theme, effectif FROM (SELECT ActID,Theme FROM Activites) AS A JOIN (
SELECT ActID,COUNT(ElevID) as effen veut les activitésctif FROM Repartition
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
HAVING a1<a2

/*On calcule le nombre d'élève partagé entre deux activité et on selectionne les pairs qui en ont le plus*/


 
/*q10*/
/*     On calcule le nombre d'élève par activités par jointure et groupe puis trie par effectif     */
SELECT Theme, effectif FROM (SELECT ActID,Theme FROM Activites) AS A JOIN (
SELECT ActID,COUNT(ElevID) as effectif FROM Repartition
GROUP BY ActID ) AS B ON A.ActID=B.ActID  ORDER BY effectif DESC, A.ActID


/*q11*/

/* 
On calcule la moyenne par classes puis par jointure on trouve les enseignants
*/

SELECT Enseignant
from Classes as C 
JOIN (SELECT ClassID,COUNT(ClassID) as effectif FROM Eleves GROUP BY ClassID ) as D
on C.ClassID=D.ClassID
where effectif > (select AVG(ListeEleves) from (SELECT COUNT(ClassID) as ListeEleves FROM Eleves GROUP BY ClassID) as A)


 
/*q12*/

/* On calcule les chiffres demandés sur la jointure groupée thème de Repartition,Eleves et Activites */

SELECT Theme,MIN(Age) as Min,MAX(Age) as Max, AVG(Age) as Moyenne, -MIN(Age)+MAX(Age) as Amplitude
FROM Eleves as Z JOIN (SELECT ElevID,Theme from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
GROUP BY Theme

/*q13*/

/* On fait la jointure de Eleves, Repartition et Activites. On calcul le nombre d'élèves par ville par activités et on choisit les couples thèmes villes 
dont l'effectif correspond au max d'effectif dans une ville pour le thème */ 

SELECT Theme, Ville FROM 
(SELECT Ville, Theme,COUNT(Z.ElevID) as hab
FROM Eleves as Z JOIN (SELECT ElevID,Theme from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
GROUP BY Ville, Theme) as tb
WHERE hab = (SELECT MAX(hab) FROM (SELECT Theme,COUNT(Z.ElevID) as hab
FROM Eleves as Z JOIN (SELECT ElevID,Theme from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
GROUP BY Ville, Theme)as m WHERE m.Theme=tb.Theme)

/*q14*/
/* on choisit les élèves qui ont une activités dans leurs villes puis on donne le thème par jointure */
SELECT Nom,jour,Theme
FROM Eleves as Z JOIN (SELECT ElevID,Jour,Lieu,Theme from Repartition as C JOIN Activites AS A ON C.ActID=A.ActID) AS E ON Z.ElevID=E.ElevID
WHERE Ville=Lieu


/*q15*/
/* on calcule le rapport pour chaque lieu du nombre d'élèves pratiquant une activités sur le nombre d'actitivités totale */
SELECT Lieu, COUNT(ElevID)/(SELECT COUNT(ActID) 
FROM Repartition) from Activites NATURAL JOIN Repartition GROUP by Lieu
 
/*q16*/
SELECT DISTINCT b1.X, b2.Y FROM(
(SELECT T1.ElevID as X,T2.ElevID as Y
from (SELECT ActID,ElevID from Repartition ) as T1 INNER JOIN (SELECT ActID,ElevID from Repartition ) as T2 ON T1.ActID=T2.ActID
WHERE T1.ElevID!=T2.ElevID) as b1
)
INNER JOIN(
SELECT e1.ElevID as X,e2.ElevID as Y FROM Eleves as e1, Eleves as e2
WHERE e1.ClassID!=e2.ClassID
) as b2 WHERE b1.X=b2.X and b1.Y=b2.Y
HAVING X<Y

/*On cherche les couples d'élèves qui ne sont pas dans la meme classe, ceux qui ont une activité en commun, puis on réalise une intersection entre les deux tables*/


/*q17*/
/*   On calcule l'effectif de chaque classes, on calcul l'effectif de chaque activités, on joint les deux tables et 
on extrait le couple où les deux effectifs sont égaux  */

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
