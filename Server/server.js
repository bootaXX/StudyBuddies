var express = require('express');
var router = express.Router();
var options = {promiseLib: Promise};
var pgp = require('pg-promise')(options);
var pg = require('pg');
var path = require('path');
var connectionString = 'postgres://postgres:12345@localhost:5432/studybuddies';
var app = express();
var fs = require('fs');
var URL = require('url-parse');
var url = require('url');
const results=[];
//var streamer = fs.createWriteStream("C:/Users/Pauline Sarana/Desktop/School/CMSC128/studybuddies/testing/test.txt");


var client = new pg.Client(connectionString);
client.connect();

//for create group
app.get("/studybuddies/groupchat/insert/:gname", function(req,res){
	client.query("insert into groupchat(groupname) values ('"+req.params.gname+"');");

	paths = "C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/testing/"+req.params.gname+".txt"; //change this path
	fs.writeFileSync(paths, data, "UTF-8", {'flags': 'a+'});

	console.log('Insert groupname in groupchat');
	res.send('Inserted '+req.params.gname+' into groupchat');
});
//for viewing of groups
app.get("/viewjoinedgroups/:userid",function(req,res){
	var results = [];
	var query = client.query("SELECT groupname from gc where userid="+req.params.userid+";");

	query.on('row', (row) => {
      results.push(row);
    });
    query.on('end', () => {
      return res.send({'groups':results});
      done();
    });    

    console.log("viewing joined groups..");
});
//for registration of user, insert into buddy
app.get("/studybuddies/buddy/insert/:username/:password/:fname/:lname", function(req,res){
	client.query("insert into buddy(username,password,fname,lname) values ('"+req.params.username+"','"+req.params.password+"','"+req.params.fname+"','"+req.params.lname+"');");
	console.log('Insert into buddy');
	res.send('Inserted '+req.params.username+' into buddy');
}); 
//for log-in
app.get("/studybuddies/buddy/login/:username/:password", function(req, res){
	var results = [];

	var queryString = client.query("SELECT * from buddy where username ='" + req.params.username + "' and password = '" + req.params.password+ "';");

	queryString.on('row', (row) => {
		results.push(row);
	});

	queryString.on('end', () => {
		return res.send(JSON.stringify(results));
		done();
	});
	console.log('Logging In');
});
//pag view sa mga groupname
app.get("/viewGroups",function(req,res){

	var results = [];
	var query = client.query("SELECT groupname from groupchat");

	query.on('row', (row) => {
      results.push(row);
    });
    query.on('end', () => {
      return res.send({'chat':results});
      done();
    });    

    console.log("viewing..");
});
//wala pa ni
app.get("/studybuddies/groupchat/select", function(req, res){
	client.query("select * from groupchat", function(err, rows, fields){
		if(!err){
			res.send("Selected");
			console.log(rows);
		}else{
			console.log('No results.');
		}
	});
});

app.listen(8080, function(){
	console.log("Server at port 8080");
});





// client.query("insert into buddy(username,password,fname,lname) values ('user3','pass3','fname3','lname3');");

// var peeps = [
// 	{name : 'name1', age : 1},
// 	{name : 'name2', age : 2},
// 	{name : 'name3', age : 3},
// 	{name : 'name4', age : 4}
// ];

// app.get("/peeps", function(req,res){
// 	res.json(peeps);
// 	console.log('List of Peeps');
// });

// app.get("/peeps/pickrand", function(req,res){
// 	var id = Math.floor(Math.random() * peeps.length);
//   	var q = peeps[id];
//   	res.json(q);
//   	console.log('Pick random peep');
// });

// app.get("/peeps/:peepid", function(req,res){
// 	if(peeps.length <= req.params.peepid || req.params.peepid < 0) {
//     res.statusCode = 404;
//     return res.send('Error 404: No quote found');
//   	}  
// 	var q = peeps[req.params.peepid];
//   	res.json(q);
//   	console.log('Pick a peep');
// });