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
var client = new pg.Client(connectionString);
var bodyParser = require('body-parser');
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies

client.connect();
const results=[];

//for create group, insert into groupchat
app.post("/studybuddies/groupchat/insert", function(req,res){
	var gname = req.body.gname
	var uid = req.body.uid
	var password = req.body.password
	client.query("insert into groupchat(groupname, password) values ('"+gname+"','"+password+"');");

	var data = gname + "\n" + "*******************************************";
	fs.writeFile("C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/messages/"+gname+".txt", data, function (err) {
    if (err) 
        return console.log(err);
    console.log('file created');
	});
	//insert in junctable
	var groupid = client.query("select groupid from groupchat where groupname = '" + gname+ "';", function (err, result){
		console.log(result.rows[0].groupid);
		client.query("insert into junctable (userid, groupid) values (" + uid + "," + result.rows[0].groupid +");");
	});

	console.log('Insert groupname in groupchat');
	res.send('Inserted '+req.body.gname+' into groupchat');
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
    console.log("viewing groupnames..");
});

// check if the groupname entered is valid(in junctable or not) or invalid
app.get("/studybuddies/groupchat/join/:gname/:uid", function(req,res){
	client.query("select groupid from groupchat where groupname = '" + req.params.gname+ "';", function (err, result){
		console.log(result.rows);
		if(result.rows == ""){
			console.log("Here")
			var reply = {
				'callback' : "invalid"
			}
			res.send(reply);
			console.log("Groupchat does not exist");
		}
		else{
			var gid = result.rows[0].groupid;
			console.log("groupid = " + gid);
			client.query("select userid from junctable where groupid = '" + gid + "';", function (err, result){
				var bool = true;
				for(var i = 0; i < result.rows.length; i++){
					if(result.rows[i].userid == req.params.uid)
						bool = false;
				}
				if (bool) {
					var reply = {
						'callback' : "valid1",
						'gid' : gid
					}
					res.send(reply);
				}
				else{
					var reply = {
						'callback' : "valid2",
						'gid' : gid
					}
					res.send(reply);
				}
			});
		}
	});
});

// verify the user in joining a group
app.get("/studybuddies/groupchat/joinvalid/:gid/:uid/:password",function(req,res){
	
	var password = req.params.password;
	var gid = req.params.gid;
	var uid = req.params.uid;

	client.query("select groupname from groupchat where password='"+password+"' and groupid="+gid+";",function(err,result){
		console.log(result.rows);
		if(result.rows == ""){
			console.log("Here")
			var reply = {
				'callback' : "invalid"
			}
			res.send(reply);
			console.log("Groupchat does not exist");
		}
		else{
			client.query("insert into junctable (userid, groupid) values (" + req.params.uid + "," + gid +");");
			console.log("Inserted into junctable");
			var reply = {
				'callback' : "valid",
			}
			res.send(reply);
		}
	});
});


//load messages
app.get("/studybuddies/groupchat/loadmessage/:gname",function(req,res){
	var buf = new Buffer(1024);
	var gname = req.params.gname;
	var results = [];

	fs.open("C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/messages/"+req.params.gname+".txt", 'r+', function(err, fd) {
		if (err) {
			return console.error(err);
		}
		console.log("Reading File");
		fs.read(fd, buf, 0, buf.length, 0, function(err, bytes){
			if (err){
				console.log(err);
			}
			// Print only read bytes to avoid junk.
			if(bytes > 0){
				json = buf.slice(0, bytes).toString();
				var index = json.split("\n").length;
				jsonstr = {
					"message" : json,
					"lines" : index
				}
				return res.send(jsonstr);
			}
			// Close the opened file.
			fs.close(fd, function(err){
				if (err){
					console.log(err);
				}
				console.log("File closed successfully.");
			});
		});
	});
});

//write messages
app.post("/studybuddies/groupchat/writemessage", function(req,res){
	console.log("Opening file");
	var gname = req.body.groupnamesent
	var uname = req.body.usernamesent
	var message = req.body.messagesent
	fs.appendFile("C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/messages/"+gname+".txt","\n"+uname+": "+message , function(err, fd){
		var reps = {
			"message" : "Message written",
			"validation" : "Good"
		}
		return res.send(reps);
	});
});

//post question
app.post("/studybuddies/groupchat/postquestion",function(req,res){
	console.log("Creating file for questions");
	var gid = req.body.gid;
	var question = req.body.question;
	var subject =req.body.subject;
	var answer = req.body.answer;
	var username = req.body.username;

	client.query("insert into group_questions(groupid, subject, answer, username) values ('"+gid+"','"+subject+"','"+answer+"','"+username+"');");
	console.log("Inserted question");
	var data = question + " by: "+username+"\n"+"*******************************************";
	fs.writeFile("C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/questions/"+subject+".txt", data, function(err, fd){
		return res.send("Question written");
	});
});

//load questions
app.get("/studybuddies/groupchat/loadquestion/:subject",function(req,res){
	var buf = new Buffer(1024);
	var subject = req.params.subject;
	var results = [];

	fs.open("C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/questions/"+subject+".txt", 'r+', function(err, fd) {
		if (err) {
			return console.error(err);
		}
		console.log("Reading question");
		fs.read(fd, buf, 0, buf.length, 0, function(err, bytes){
			if (err){
				console.log(err);
			}
			// Print only read bytes to avoid junk.
			if(bytes > 0){
				json = buf.slice(0, bytes).toString();
				var index = json.split("\n").length;
				jsonstr = {
					"answers" : json,
					"lines" : index
				}
				return res.send(jsonstr);
			}
			// Close the opened file.
			fs.close(fd, function(err){
				if (err){
					console.log(err);
				}
				console.log("File closed successfully.");
			});
		});
	});
});

//view questions
app.get("/studybuddies/groupchat/viewquestions/:gid",function(req,res){
	var results = [];
	var gid = req.params.gid;
	var query = client.query("SELECT subject from group_questions where groupid = " + gid + ";");
	query.on('row', (row) => {
    results.push(row);
    });
    query.on('end', () => {
      return res.send({'chat':results});
      done();
    });   
	console.log("viewing questions..");
});

//write answer
app.post("/studybuddies/groupchat/writeanswer", function(req,res){
	console.log("Opening file");
	var subject = req.body.subjectsent
	var uname = req.body.usernamesent
	var answer = req.body.answersent
	fs.appendFile("C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/questions/"+subject+".txt","\n"+uname+": "+answer , function(err, fd){
		var reps = {
			"message" : "Message written",
			"validation" : "Good"
		}
		return res.send(reps);
	});
});

//post notes
app.post("/studybuddies/postnotes", function(req,res){
	console.log("Creating file for notes");
	var gid = req.body.gid;
	var notes = req.body.notes;
	var title =req.body.titlee;
	var username = req.body.username;
	var currIndex = req.body.currIndex;

	if(notes=="" || title==""){
		var reps = {
			"message": "Enter the correct value for notes and title.",
			"validation": "invalid"
		}
		return res.send(reps);
	}
	else{
		client.query("insert into group_notes(groupid, title, notes, username,rowIndex) values ("+gid+",'"+title+"','"+notes+"','"+username+"','"+currIndex+"');",function(err,result){
			var reps = {
				"message": "Successfully created notes.",
				"validation":"valid"
			}
			return res.send(reps);
		});
	}

	console.log("Inserted notes");
});

//view notes
app.get("/studybuddies/groupchat/viewnotes/:gid/:rowIndex",function(req,res){
	var results = [];
	var gid = req.params.gid;
	var rowIndex = req.params.rowIndex;
	console.log(gid + "  " + rowIndex)
	var query = client.query("SELECT notes from group_notes where groupid = " + gid +" and rowIndex = "+rowIndex+";");
	query.on('row', (row) => {
    results.push(row);
    });
    query.on('end', () => {
      return res.send({'notes':results});
      done();
    });   
	console.log("viewing notes...");
});

//view list of notes
app.get("/studybuddies/groupchat/viewlistnotes/:gid",function(req,res){
	var results = [];
	var gid = req.params.gid;
	var query = client.query("SELECT title from group_notes;");
	query.on('row', (row) => {
    results.push(row);
    });
    query.on('end', () => {
      return res.send({'title':results});
      done();
    });   
	console.log("viewing list of notes..");
});

app.listen(8080, function(){
	console.log("Server at port 8080");
});