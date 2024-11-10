console.time('JavaScript');

let sum = 0;
for (let i = 1; i <= 100000000; i++) {
    sum += i;
}

console.timeEnd('JavaScript');
console.log('Sum =', sum);
