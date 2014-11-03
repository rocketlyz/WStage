var sqlmanager = require('./sqlmanager.js');
var TABLE = 'ph';
var PH = {};
var connection = sqlmanager.connection;
var DATABASE = sqlmanager.DATABASE;
/*ph是这样的对象[uid:,nid:,sid:,value:,time]
*uid表示用户id,nid表示节点id,sid表示传感器id,value是传感器检测的数据值,time表示检测数据的时间*/
PH.insert = function(ph,func){
	connection.query('use '+ DATABASE);
	connection.query('INSERT INTO '+TABLE+' '+ 'SET uid = ?, nid = ?, sid =?, value = ?, time = ? ;',  
		[ph.uid, ph.nid, ph.sid, ph.value,ph.time],
		function(err,rows,fields){
			if(err)
				console.log('ph insert:'+err);
			if(rows&&rows.length >0){
				if(func)
					func();
			}
		});
};

PH.clear = function(){
	connection.query('use '+ DATABASE);
	connection.query('truncate table '+ TABLE + ';');
}

module.exports = PH;