export let User = {
    name: '坤坤',
    age: 18,
    print() {
        alert(`${this.name}练习专场即将开始，请做好准备~`);
    }
}

let boy = {
    realName: '背带裤',
    hair: '中分'
}
let girl = {
    realName: '迪丽热巴',
    cup: 'E'
}
let tidy = {
    realName: '泰迪',
    alias: '日天'
}
export {boy, girl, tidy}

/* 如果默认的组件是一个 函数，则可以给函数起名字
   不过在模块外func1函数名无效，并且视为匿名函数
*/
// export default function func1() {
//     console.info("默认函数~");
// }

/* 如果默认的组件是一个 对象，需要在导出前定义变量名
   不能在 export default 之后 给变量名赋值
*/
// let jini = {
//     name: '吉尼',
//     feature: '钛镁',
//     age: 21,
//     print() {
//         console.info(`姓名: ${this.name}, 外貌: ${this.feature}, 年龄:${this.age}`);
//     }
// };
// export default jini;
/* 好像也可以 */
export default {
    name: '吉尼',
    feature: '钛镁',
    age: 21,
    print() {
        console.info(`姓名: ${this.name}, 外貌: ${this.feature}, 年龄:${this.age}`);
    }
};

/* 需要先导出，才能被导入

   导出 -> export 语法
   1. 直接写组件上面
        export 变量符号 变量名 = 对象/函数...
   2. 批量导出
        export {变量名1, 变量名2, ...}
   3. 导出默认组件
        export default (变量名省略) 对象/函数...

   导入 -> import 语法
   1. import {组件名} from js文件路径
             {} 内的多个组件，用 , 分割
             导入所有组件，用 * 号，但是还要使用 as 取别名
   2. 非默认组件必须写在 {} 内，默认组件不能写在 {} 内
*/