select surname from players where team like %ia% and minutes < 200 and passes > 100;

select * from players where shots>20 order by shots desc;

select pl.surname, pl.minutes, pl.team from players as pl inner join teams as te on pl.team = te.team where te.games>4 and pl.position = "goalkeeper";

select count(pl.surname) as superstar from players as pl inner join teams as te on pl.team = te.team where pl.minutes>350 and te.ranking<10;

select avg(passes) as AveragePasses, position from players where position in ("forward","midfielder") group by position;

select te1.teams, te2.teams, te1.goalsFor, te1.goalsAgainst from teams as te1 join teams as te2 where te1.goalsFor = te2.goalsFor and te1.goalsAgainst = te2.goalsAgainst and te1.team<te2.team;

select team from teams where (goalsFor/goalsAgainst)=(select MAX(goalsFor/goalsAgainst from teams);

select te.team, AVG(pl.passes) from teams as te inner join players as pl on te.team = pl.team where pl.position="defender" group by te.team having avg(pl.passes)>150 order by avg(pl.passes) desc;