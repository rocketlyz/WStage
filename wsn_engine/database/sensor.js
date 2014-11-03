var sqlmanager = require('./sqlmanager.js');
var TABLE = 'sensor';
var SENSOR = {};
var connection = sqlmanager.connection;
var DATABASE = sqlmanager.DATABASE;
/*ph是这样的对象[uid:,nid:,sid:,value:,time]
*uid表示用户id,nid表示节点id,sid表示传感器id,value是传感器检测的数据值,time表示检测数据的时间*/
SENSOR.insert = function(sensor,func){
	console.log('begin insert sensor');
	connection.query('use '+DATABASE);
	connection.query( 'INSERT INTO '+TABLE+' '+ 'SET uid = ?, nid = ?,sid =?, tid = ?,name = ? ;',  
		[sensor.uid,sensor.nid,sensor.sid,sensor.tid,sensor.name],
		function(err,rows,fields){
			console.log('end insert sensor');
			if(err)
				console.log('sensor insert :'+err);
			if(rows&&rows.length>0){
				if(func)
					func(true);
			}
		});
};

SENSOR.clear = function(){
	connection.query('use '+DATABASE);
	connection.query('truncate table '+ TABLE + ';');
}

SENSOR.select = function(sensor,func){
	console.log('begin select sensor');
	connection.query('use '+DATABASE);
	connection.query('select * from '+TABLE+ ' where sid = ? and nid = ? and uid = ? ;',
		[sensor.sid,sensor.nid,sensor.uid],
		function(err,rows,fields){
			console.log('end select sensor');
			if(err)
				console.log('sensor select :'+err);
			if(rows&&rows.length>0){
				// console.log(fields);	
				if(func)
					func(true);
			}
			else{
				if(func)
					func(false);
			}
		});

}

module.exports = SENSOR;