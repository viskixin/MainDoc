function doSomething(u, b, g, t, x) {
    u.print();
    $('div>p:eq(0)').text(u.name + " → " + u.age);
    $('div>p:eq(1)').text(b.realName + " → " + b.hair);
    $('div>p:eq(2)').text(g.realName + " → " + g.cup);
    $('div>p:eq(3)').text(t.tidy.realName + " → " + t.tidy.alias);
    $('div>p:eq(4)').text(x.name + " → " + x.feature + " → " + x.age);
}