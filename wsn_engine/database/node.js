var sqlmanager = require('./sqlmanager.js');
var TABLE = 'node';
var NODE = {};
var connection = sqlmanager.connection;
var DATABASE = sqlmanager.DATABASE;
/*ph是这样的对象[uid:,nid:,sid:,value:,time]
*uid表示用户id,nid表示节点id,sid表示传感器id,value是传感器检测的数据值,time表示检测数据的时间*/
NODE.insert = function(node,func){
	console.log('begin insert node');
	connection.query('use '+DATABASE);
	connection.query('INSERT INTO '+TABLE+' '+ 'SET nid = ?,uid = ?, name = ? ;', 
		[node.nid,node.uid,node.name] ,
		function(err,rows,fields){
			console.log('end insert node');
			if(err)
				console.log('node insert:'+err);
			if(rows&&rows.length>0){
				if(func)
					func();
			}
		});
};

NODE.clear = function(){
	connection.query('use '+DATABASE);
	connection.query('truncate table '+ TABLE + ';');
};

NODE.select = function(node,func){
	console.log('begin select node');
	connection.query('use '+DATABASE);
	connection.query('select * from '+TABLE+ ' where nid = ? and uid = ? ;',
		[node.nid,node.uid],
		function(err,rows,fields){
			console.log('end select node');
			if(err){
				console.log('node select :'+err);
			}
			if(rows&&rows.length > 0){
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

module.exports = NODE;