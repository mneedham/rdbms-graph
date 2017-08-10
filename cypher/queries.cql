// Transfers by date
match (t:Transfer)
return apoc.date.format(t.timestamp,'s', 'yyyy-MM-dd', "GMT+01:00"), count(*) AS count
ORDER BY count DESC;

// Chelsea to Man Utd
MATCH (from:Club)<-[:FROM_CLUB]-(transfer:Transfer)-[:TO_CLUB]->(to:Club),
      (transfer)-[:OF_PLAYER]->(player)
WHERE from.name = "Chelsea" AND to.name = "Man Utd"
RETURN player.name, transfer.numericFee, transfer.season;

// Brexit means Brexit
MATCH (to:Club)<-[:TO_CLUB]-(t:Transfer)-[:FROM_CLUB]-(from:Club), (t)-[:OF_PLAYER]->(player:Player)
WHERE to.country = "England" AND from.country = "England" AND player.nationality = "England"
RETURN player.name, from.name, to.name, t.numericFee, t.season
ORDER BY t.numericFee DESC
LIMIT 10;

// from south america -> europe
MATCH (to:Club)<-[:TO_CLUB]-(t:Transfer)-[:FROM_CLUB]-(from:Club), (t)-[:OF_PLAYER]->(player:Player),
      (from)-[:PART_OF*2]->(:Confederation {id: "conmebol"}),
      (to)-[:PART_OF*2]->(:Confederation {id: "uefa"})
RETURN player.name, from.name, to.name, t.numericFee, t.season
ORDER BY t.numericFee DESC
LIMIT 10;

// money flow
MATCH (to:Club)<-[:TO_CLUB]-(t:Transfer)-[:FROM_CLUB]-(from:Club), (t)-[:OF_PLAYER]->(player:Player),
      (from)-[:PART_OF*2]->(conf1:Confederation),
      (to)-[:PART_OF*2]->(conf2:Confederation)
WHERE conf1 <> conf2
RETURN conf1.id, conf2.id, sum(t.numericFee) AS moneyFlow
ORDER BY moneyFlow DESC;
