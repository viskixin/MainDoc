import {User} from './js/exp.js';
import {boy, girl} from './js/exp.js';
import * as totalFunc from './js/exp.js';
console.info(User);
console.info(boy);
console.info(totalFunc.girl);

import xxx, {tidy} from './js/exp.js';
console.info(tidy);
// console.info(xxx());
console.info(Object.keys(xxx));
xxx.print();

/*
  模块代码只会在加载的时候调用一次
  不export的函数，只能在本模块调用，连其他module都获取不到
  但export的方法不是全局方法，所以html页面获取不到 而且 html页面也没有import导入功能
*/
let impPrint = function () {
    alert("这是模块函数");
}
export default impPrint;

// 在模块中，可以直接使用普通js文件的方法(前提：html引入)
doSomething(User, boy, girl, totalFunc, xxx);