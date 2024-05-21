const express = require('express');
const router = express.Router();

const db = require('../database');
// results contains rows returned by server, fields contains extra meta data about results, if available

router.get('/', async function (req, res, next) {
    var query1,query2,query3,query4,query5;
    query1 = await db.execute( // how many dead in total
        'SELECT a.Injury_Result, COUNT(Victim_ID) AS TOTAL FROM accident a '+
        'INNER JOIN routes r ON a.Route_ID = r.Route_ID '+
        'WHERE a.Injury_Result = "Fatal" ' +
        'GROUP BY a.Injury_Result, a.Injury_Result ' +
        'ORDER BY COUNT(Victim_ID) DESC;');
    query2 = await db.execute( // which route has more accidents
        'SELECT r.Route_Code, COUNT(Victim_ID) AS TOTAL FROM accident a ' +
        'INNER JOIN routes r ON a.Route_ID = r.Route_ID ' +
        'GROUP BY Route_Code, a.Injury_Result ' +
        'ORDER BY COUNT(Victim_ID) DESC;');
    query3 = await db.execute( // which operator has more accidents
        'SELECT r.Operator, COUNT(Victim_ID) AS TOTAL FROM accident a '+
        'INNER JOIN routes r ON a.Route_ID = r.Route_ID '+
        'GROUP BY r.Operator '+
        'ORDER BY COUNT(Victim_ID) DESC;');
    query4 = await db.execute( // month with more accidents
        'SELECT MONTH(a.Date_Of_Incident), COUNT(v.Victim_ID) AS TOTAL FROM victim v '+
        'INNER JOIN accident a ON a.Victim_ID = v.Victim_ID '+
        'GROUP BY MONTH(a.Date_Of_Incident) '+
        'ORDER BY COUNT(Victim_Age) DESC;');
    query5 = await db.execute( // Type of person that is more involved in accidents
        'SELECT a.Year, v.Victim_Age, COUNT(Victim_Age) AS TOTAL FROM victim v '+
        'INNER JOIN accident a ON a.Victim_ID = v.Victim_ID '+
        'GROUP BY a.Year, v.Victim_Age '+
        'ORDER BY COUNT(Victim_Age) DESC;');
    res.render('index.mustache', {query1: query1[0][0].TOTAL,route2:query2[0][1].Route_Code, route3:query2[0][2].Route_Code ,query21:query2[0][0].TOTAL, query22:query2[0][1].TOTAL, query23:query2[0][2].TOTAL, q3operator: query3[0][0].Operator,query3:query3[0][0].TOTAL,q4month:query4[0][0]["MONTH(a.Date_Of_Incident)"], query4:query4[0][0].TOTAL, q5vicage:query5[0][0].Victim_Age, query5:query5[0][0].TOTAL});
});

module.exports = router;



/* WORKING
router.get('/', async function (req, res, next) {
    var test = 0;
    let sql = 'SELECT * FROM accident';
    test = await db.query(sql);
    res.send("hello" + test);
});
*/

// app.post('/', function(req, res) {
// });
// function addIndex(queryResults){
// 	// Number the results (there are many alternative ways to do this)
// 	queryResults.forEach((el, index) => el.i = index);
// 	return queryResults;
// }
// function templateRenderer(response){
// 	// Return a renderer function with the res object built in
// 	return function(error, results, fields){
// 		if(error){
// 			throw error;
// 		}
// 		response.render('actorForm', { data: addIndex(results)} );
// 	}
// }
// function insertCallback(response){
// 	// Return a function with res in it, then make the input form
// 	return function(error, results, fields){
// 		if(error){
// 			throw error;
// 		}
// 		makeForm(response);
// 	}
// }
// function makeForm(response){
// 	// Run a query to get unmatched actors
// 	var query = `SELECT DISTINCT Actor1
//                  FROM Locations LEFT JOIN Actors ON Actor1=ENName
//                  WHERE ENName IS NULL
//                  LIMIT 10;`;
// 	db.query(query, templateRenderer(response));
// }
// function updateDBthenRequery(updates, response){
// 	// If we've received any data, add it to the database, then
// 	// redisplay the table
// 	if(updates.length){
// 		var query = "INSERT INTO Actors VALUES "+updates.toString();
// 		db.query(query, (error, insertCallback(response)));
// 	}
// }