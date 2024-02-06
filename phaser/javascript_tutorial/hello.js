let a = [1,2,'a',true]

a.forEach(element => {
    console.log(element + ' is of type ' + typeof(element))
});

console.log(JSON.stringify(a))