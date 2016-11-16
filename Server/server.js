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
	client.query("insert into groupchat(groupname) values ('"+gname+"');");

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

//join groupchat, if .. insert into junctable
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
					client.query("insert into junctable (userid, groupid) values (" + req.params.uid + "," + gid +");");
					console.log("Inserted into junctable");
					var reply = {
						'callback' : "valid",
						'gid' : gid
					}
					res.send(reply);
				}
				else{
					var reply = {
						'callback' : "valid",
						'gid' : gid
					}
					res.send(reply);
				}
			});
		}
	});
});

//load messages
app.get("/studybuddies/groupchat/loadmessage/:gname",function(req,res){
	var buf = new Buffer(1024);
	var gname = req.params.gname;
	var results = [];

	console.log("Going to open an existing file");
	fs.open("C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/messages/"+req.params.gname+".txt", 'r+', function(err, fd) {
		if (err) {
			return console.error(err);
		}
		
		console.log("File opened successfully!");
		console.log("Going to read the file");

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

<<<<<<< HEAD
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
		res.send("Question written");
=======
//post questions
app.post("/studybuddies/groupchat/postquestions", function(req,res){
	console.log("Opening file");
	var gname = req.body.groupnamesent
	var uname = req.body.usernamesent
	var questions = req.body.questionsent
	fs.appendFile("C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/questions/"+gname+".txt","\n"+uname+": "+questions , function(err, fd){
		var reps = {
			"questions" : "Questions written",
			"validation" : "Good"
		}
		return res.send(reps);
>>>>>>> origin/EditForFileWriting
	});
});

//load questions
<<<<<<< HEAD
app.get("/studybuddies/groupchat/loadquestion/:subject",function(req,res){
=======
app.get("/studybuddies/groupchat/loadquestions/:gname",function(req,res){
>>>>>>> origin/EditForFileWriting
	var buf = new Buffer(1024);
	var subject = req.params.subject;
	var results = [];

	console.log("Going to open an existing file");
	fs.open("C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/questions/"+subject+".txt", 'r+', function(err, fd) {
		if (err) {
			return console.error(err);
		}
		
		console.log("File opened successfully!");
		console.log("Going to read the file");

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
<<<<<<< HEAD

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
=======
// write answer
app.post("/studybuddies/groupchat/writeanswer", function(req,res){
	console.log("Opening file");
	var gname = req.body.groupnamesent
	var uname = req.body.usernamesent
	var answer = req.body.answersent
	fs.appendFile("C:/Users/Pauline Sarana/Desktop/studybuddies/StudyBuddies/Server/messages/"+gname+".txt","\n"+uname+": "+answer , function(err, fd){
		var reps = {
			"answer" : "Message written",
>>>>>>> origin/EditForFileWriting
			"validation" : "Good"
		}
		return res.send(reps);
	});
});

app.listen(8080, function(){
	console.log("Server at port 8080");
});