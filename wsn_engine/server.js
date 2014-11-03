/*日期格式化
*例子：var nowStr = now.format("yyyy-MM-dd hh:mm:ss"); */
Date.prototype.format = function(format){ 
	var o = { 
		"M+" : this.getMonth()+1, //month 
		"d+" : this.getDate(), //day 
		"h+" : this.getHours(), //hour 
		"m+" : this.getMinutes(), //minute 
		"s+" : this.getSeconds(), //second 
		"q+" : Math.floor((this.getMonth()+3)/3), //quarter 
		"S" : this.getMilliseconds() //millisecond 
	} 

	if(/(y+)/.test(format)) { 
		format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
	} 

	for(var k in o) { 
		if(new RegExp("("+ k +")").test(format)) { 
			format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
		} 
	} 
	return format; 
};
/*去除字符串首尾空格*/
String.prototype.Trim = function()  
{  
	return this.replace(/(^\s*)|(\s*$)/g, "");  
};  

var net = require('net');
// var xmlparser = require('./xml-parser');
var xmlparser = require('xml-parser');
// var xmlbuilder = require('./xmlbuilder');
var xmlbuilder = require('xmlbuilder');

var PHTable = require('./database/ph.js');
var NodeTable = require('./database/node.js');
var SensorTable = require('./database/sensor.js');

var ip = require('./configure.js');
var HOST = ip.host;
var PORT = ip.port;

/*注册一个socket端口*/
var server = net.createServer();
server.listen(PORT,HOST);
// console.log(server);
console.log('--------------Server Start----------------');
console.log('Server listening on '+HOST +':'+PORT);

var count = 0;
// var message = '';

server.on('connection',function(socket){
	console.log('CONNECTED: '+socket.remoteAddress+':'+socket.remotePort);

	// 为这个socket实例添加一个"data"事件处理函数  
	socket.on('data', function(data) { 
		console.log('DATA'+": "+data); 
		// socket.write('success!');

		// message += data.toString();
		var ss = data.toString().split("<?xml");

		for(var i in ss){
			if(i == 0)
					continue;
			(function(i){
				var ret = parser("<?xml"+ss[i]);
				console.log('回应：'+ret);
				if(ret){
					socket.write(ret.toString() );
				}
			})(i);
		}
    });  

    // 为这个socket实例添加一个"close"事件处理函数  
    socket.on('close', function(data) {  
    	// console.log('CLOSED: ' + socket.remoteAddress + ' ' + socket.remotePort); 
    	/*分割接受到的一批数据*/
  //   	var ss = message.toString().split("<?xml");

		// for(var i in ss){
		// 	if(i == 0)
		// 			continue;
		// 	(function(i){
		// 		var ret = parser("<?xml"+ss[i]);
		// 		if(ret){
		// 			socket.write(ret);
		// 		}
		// 	})(i);
		// }
    	console.log('CLOSED: '+data) 
    });  
});

/*解析xml*/
function parser(xml){
	console.log('解析：'+xml)
	xml = xml+'';
	var obj = xmlparser(xml);

	try{
		if(obj&&obj.root){
			/*接受注册数据*/
			if(obj.root.name == 'GateProtocol'){
				console.log('------------注册信息--------------');
				var sensors = obj.root.children[5].children[0].children;
				var node = obj.root.children[5].children[1].children[0];
				var nodedata = {uid:1,nid:node.attributes.id,name:node.content};

				/*插入传感器信息的函数*/
				var insertSensor = function(){
					console.log('test -- ss:'+sensors.length);
					for(var k in sensors){
						(function(k){
							var sdata = {
								sid:sensors[k].attributes.id,
								nid:nodedata.nid,
								uid:nodedata.uid,
								tid:2,
								name:sensors[k].content
							};
							SensorTable.select(sdata,function(){
								// console.log('k:'+k);
								SensorTable.insert(sdata);
							});
						})(k);

					}
				};
				/*插入数据库*/
				NodeTable.select(nodedata,function(flag){
					//flag表示指定的node不在数据库中
					if(!flag){
						NodeTable.insert(nodedata,insertSensor); 
					}
					else{
						insertSensor();
					}
					
				});

				/*编辑回应node的xml格式的信息*/
				var date = new Date();
				date = date.format('yyyyMMddhhmmss');
				/*发送应答*/
				var response = {GateProtocol:{
					'@version':'1.0',
					cmd:{
						'#text':'GateRegisterResponse'
					},
					timestamp:{
						'#text':date
					},
					success:{
						'#text':'true'
					}
				}};
				var rxml = xmlbuilder.create(response);
				return rxml;

			}
			/*接受检测数据*/
			if(obj.root.name == 'DataFrame'){
				console.log('------------接受检测数据--------------');
				var timestamp = obj.root.children[0];
				var values = obj.root.children[1].children;

				for(var i in values){
					var ph = {};
					ph.value = values[i].content;
					ph.nid = values[i].attributes.oid;
					ph.time = timestamp.content;
					ph.sid = values[i].attributes.mid;
					ph.uid = 1;

					PHTable.insert(ph); 
				}
			}
		}
	}catch(e){
		console.log("err:"+obj.root.children);
	}
};

