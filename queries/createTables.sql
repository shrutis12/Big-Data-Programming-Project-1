create table teams (
team varchar(50) not null,
ranking smallint unsigned not null,
games smallint unsigned,
wins smallint unsigned,
draws smallint unsigned,
losses smallint unsigned,
goalsFor smallint unsigned,
goalsAgainst smallint unsigned,
yellowCards smallint unsigned,
redCards smallint unsigned,
primary key (team));


create table players(
surname varchar(50) not null,
team varchar(50) not null,
position varchar(50),
minutes bigint unsigned,
shots smallint unsigned,
passes smallint unsigned,
tackles smallint unsigned,
saves smallint unsigned,
primary key (surname),
foreign key (team) references teams(team));

