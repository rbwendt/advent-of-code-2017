const fs = require('fs');

function follower(str) {
    const LINE_ENDING = "\n"
    const START = '|'
    this.dy = 1
    this.dx = 0
    this.stepsTaken = 0
    this.str = str
    this.encounters = []
    this.w = str.indexOf(LINE_ENDING) + 1
    this.h = str.split(LINE_ENDING).count - 1
    this.findStart = () => {
        this.y = 0
        this.x = this.str.indexOf(START)
    }
    this.progress = () => {
        this.x += this.dx
        this.y += this.dy
    }
    this.backtrack = () => {
        this.x -= this.dx
        this.y -= this.dy
    }
    this.charAt = (x, y) => {
        if (x < 0 || y < 0 || x > this.w || y > this.h) {
            return ' '
        }
        let p = this.w * y + x
        return this.str[p]
    }
    this.currentChar = () => {
        return this.charAt(this.x, this.y)
    }

    this.travel = () => {
        let done = false
        while (!done) {
            let char = this.currentChar()
            if (char == ' ') {
                console.log('backtracking!')
                this.backtrack()
                done = true
            }
            this.stepsTaken ++
            // console.log('current char >', char, ';', this.x, this.y, ' d', this.dx, this.dy)
            
            switch(char) {
                case '-':
                    break
                case '|':
                    break
                case '+':
                    if (this.dx == 0) {
                        if (this.charAt(this.x - 1, this.y) != ' ') {
                            this.dx = -1
                        } else if (this.charAt(this.x + 1, this.y) != ' ') {
                            this.dx = 1                     
                        } else {
                            done = true
                        }
                        this.dy = 0
                    } else {
                        if (this.charAt(this.x, this.y - 1) != ' ') {
                            this.dy = -1
                        } else if (this.charAt(this.x, this.y + 1) != ' ') {
                            this.dy = 1                     
                        } else {
                            done = true
                        }
                        this.dx = 0
                    }
                    break
                default:
                    this.encounters.push(char)
                    break
            }
            this.progress()
            if (this.x < 0 || this.x > this.w || this.y < 0 || this.y > this.h) {
                done = true
            }
        }
    }
    this.getEncounters = () => {
        return this.encounters.join('')
    }
    this.run = () => {
        this.findStart()
        this.travel()
    }
    return this
}

let contents = fs.readFileSync('data/day19.txt').toString();

f = new follower(contents)
f.run()
console.log(f.getEncounters()) // PVBSCMEQHY
console.log(f.stepsTaken - 1) // 17736