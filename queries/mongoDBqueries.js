db.Players.find({"team":/ia/, minutes:{$lt:200}, passes:{$gt:100}},{surname:1}).pretty();

db.Players.find({shots:{$gt:20}}).sort({shots:-1}).pretty();

db.Players.aggregate([{ $lookup: {from:"Teams", localField: "team", foreignField: "team", as: "Teams"}}, {$match:{$and: [{"position":"goalkeeper"}, {"Teams.games":{$gt:4}}]}}, {$project:{"surname":1, "team":1, "minutes":1} }]);

db.Players.aggregate([{$lookup: {from:"Teams", localField: "team", foreignField: "team", as: "Teams"}}, {$match:{$and: [{"Teams.ranking":{$lt:10}}, {"minutes":{$gt:350}}]}}, {$count:"superstar"}]);

db.Players.aggregate([ {$group:{_id:"$position", average:{$avg:"$passes"}}},  {$match:{$or:[{"_id":"midfielder"},{"_id":"forward"}]} }, {$project: {"_id":0, "Position":"$_id", "Average": "$average"}}]).pretty();

db.getCollection('Teams').aggregate([
{$lookup : { from : "Teams",
let:{bId:'$_id',bTeam:'$team',bgoalsFor:'$goalsFor',bgoalsAgainst:'$goalsAgainst'},
pipeline: [
{ $match:
{$and:[
{$expr:{$lt: ['$_id','$$bId']}},
{$expr:{$ne: ['$team','$$bTeam']}},
{$expr:{$eq: ['$goalsFor','$$bgoalsFor']}},
{$expr:{$eq: ['$goalsAgainst','$$bgoalsAgainst']}}
]}}], as:"team2"}},
{$unwind:'$team2'},{$addFields: {"against_team": "$team2.team"}},
{$project:{team:1,goalsFor:1,goalsAgainst:1,'against_team':1}}]);

db.Teams.aggregate([ {$project: { team : 1, ratio: { $divide: [ "$goalsFor", "$goalsAgainst" ] } } },{ $sort: { ratio: -1 } }, { $limit: 1} ]);

db.Teams.aggregate([{ $lookup: { from: "Players", localField: "team", foreignField: "team", as: "p" } }, { $unwind: "$p" }, { $match: { "p.position": "defender" } }, { "$group": { "_id": "$team", "avg_a": { "$avg": "$p.passes" } } },{"$match":{"avg_a":{"$gt":150}}}]);