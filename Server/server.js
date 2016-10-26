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


var client = new pg.Client(connectionString);
client.connect();

//for create group, insert into groupchat
app.get("/studybuddies/groupchat/insert/:gname/:uid", function(req,res){
	client.query("insert into groupchat(groupname) values ('"+req.params.gname+"');");

	var data = "Halloo!!"
	fs.writeFile("C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/testing/"+req.params.gname+".txt", data, function (err) {
    if (err) 
        return console.log(err);
    console.log('file created');
	});

	var groupid = client.query("select groupid from groupchat where groupname = '" + req.params.gname+ "';", function (err, result){
		console.log(result.rows[0].groupid);
		client.query("insert into junctable (userid, groupid) values (" + req.params.uid + "," + result.rows[0].groupid +");");
	});

	console.log('Insert groupname in groupchat');
	res.send('Inserted '+req.params.gname+' into groupchat');
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

//view groupnames
app.get("/studybuddies/groupchat/select",function(req,res){

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

//join groupchat, if .. insert into junctable
app.get("/studybuddies/groupchat/join/:gname/:uid", function(req,res){
	client.query("select groupid from groupchat where groupname = '" + req.params.gname+ "';", function (err, result){
		if(result.rows[0].groupid != null){
			var gid = result.rows[0].groupid;
			console.log("groupid = " + gid);
			client.query("select userid from junctable where groupid = '" + gid + "';", function (err, result){
				var bool = true;
				for(var i = 0; i < result.rows.length; i++){
					if(result.rows[i].userid == req.params.uid)
						bool = false;
				}
				if (bool) {
					client.query("insert into junctable (userid, groupid) values (" + req.params.uid + "," + gid +");");
					console.log("Inserted into junctable");
					res.send("Inserted into junctable");
				}
				else{
					res.send("In group already");
				}
			});
		}
		else{
			res.send("Groupchat does not exist");
			console.log("Groupchat does not exist");
		}
	});
});

//load messages


app.listen(8080, function(){
	console.log("Server at port 8080");
});