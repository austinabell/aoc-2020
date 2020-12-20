const file = await Deno.readTextFile('input.txt');

let [rules, messages] = file.split('\n\n');
rules = rules.replace('8: 42', '8: 42 | 42 8');
rules = rules.replace('11: 42 31', '11: 42 31 | 42 11 31');
rules = Object.fromEntries(rules.split('\n').map(rule => rule.split(': ')));

const getRulesRecursive = (i, n8, n11) => {
    const rule = rules[i];
    if (i === '8' && n8 == 10) {
        return '(' + getRulesRecursive(42, n8, n11) + ')';
    }
    if (i === '11' && n11 == 10) {
        return '(' + getRulesRecursive(42, n8, n11) + getRulesRecursive(31, n8, n11) + ')';
    }
    n8 += i === '8';
    n11 += i === '11';
    if (rule[0] == '"') {
        return rule[1];
    } else {
        const parts = rule
            .split(' ')
            .map((p) => p == '|' ? '|' : getRulesRecursive(p, n8, n11))
            .join('');
        return '(' + parts + ')';
    }
}

let rule = new RegExp('^' + getRulesRecursive(0, 0, 0) + '$', 'gm');
let matches = messages.match(rule).length;
console.log('P2: ' + matches);

