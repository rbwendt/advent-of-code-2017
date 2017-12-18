import java.io.File
import java.io.InputStream

open class Input{
    open fun swap(inp: String): String {
        return inp
    }
}

class Spin(val spinBy: Int) : Input() {
    override fun swap(inp: String): String{
        val first = inp.substring(inp.length - spinBy, inp.length)
        val second = inp.substring(0, inp.length - spinBy)

        return first + second
    }
}
class XSwap(val from: Int, val to: Int) : Input() {
    override fun swap(inp: String): String{
        val startS = inp.substring(0, from)
        val fromS = inp.substring(from, from + 1)
        val middleS = inp.substring(from + 1, to)
        val toS = inp.substring(to, to + 1)
        var endS = inp.substring(to + 1, inp.length)
        
        return startS +
               toS + 
               middleS +
               fromS + 
               endS
    }    
}
class PSwap(val from: String, val to: String) : Input() {
    override fun swap(inp: String): String{
        return inp.replace(from, "-")
                  .replace(to, from)
                  .replace("-", to)
    }    
}

fun buildPrograms(num: Int): String {
    val alph = "abcdefghijklmnopqrstuvwxyz"
    return alph.substring(0, num)
}

fun parseLine(line: String): Input {
    when (line.substring(0, 1)) {
        "s" -> return Spin(line.substring(1).toInt())
        "x" -> {
            val parts = line.substring(1).split("/")
            val from = parts[0].toInt()
            val to = parts[1].toInt()
            if (to < from) {
                return XSwap(to, from)
            } else {
                return XSwap(from, to)
            }
        }
        "p" -> {
            val parts = line.substring(1).split("/")
            val from = parts[0]
            val to = parts[1]
            return PSwap(from, to)
        }
    }
    return Input()
}

fun getInputs(path: String): ArrayList<Input> {

    val a = ArrayList<Input>()

    var inputStream: InputStream = File(path).inputStream()
    val lineList = mutableListOf<String>()

    inputStream.bufferedReader().useLines { lines -> lines.forEach { lineList.add(it)} }
    var i = 0
	lineList.forEach{
        a.add(parseLine(it))
        i++
    }

    return a
}

fun runItAll(programs: String, inputs: ArrayList<Input>): String {
    var lol = programs
    inputs.forEach{
        lol = it.swap(lol)
    }
    return lol
}

fun getRemainder(startStr: String, n: Int, inputs: ArrayList<Input>): Int {
    var str = startStr
    var i = 0
    var cycleLength: Int
    while (i < n) {
        str = runItAll(str, inputs)
        
        if (i > 0 && str == startStr) {
            cycleLength = i + 1
            return n.rem(cycleLength)
            // println("cycle length is ${cycle_length} remainder is: ${rem}")
            // break
        }
        i ++
    }
    return -1
}
fun getNth(startStr: String, rem: Int, inputs: ArrayList<Input>): String {
    var str = startStr
    var i = 0
    while (i <= rem - 2) {
        str = runItAll(str, inputs)
        i ++
    }
    return str
}

fun partA() {
    val num = 16
    var programs = buildPrograms(num)
    val inputs = getInputs("data/day16.txt")
    val output = runItAll(programs, inputs)
    println("output from part a is: $output") // lgpkniodmjacfbeh   
}

fun partB() {
    val inputs = getInputs("data/day16.txt")
    val startStr = "lgpkniodmjacfbeh"

    val n = 1_000_000_000
    
    val rem = getRemainder(startStr, n, inputs)

    val str = getNth(startStr, rem, inputs)    
    println("output from part a is: $str") // hklecbpnjigoafmd
}

fun main(args: Array<String>) {

    partA()
    partB()

}
