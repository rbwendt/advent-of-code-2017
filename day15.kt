class Generator(val start: Long, val multiplier: Long, val modulus: Long) {

    var value = start

    fun next(): Long {
        value = (value * multiplier).rem(modulus)
        return value
    }

    fun nextMatching(mustMod: Long): Long {
        val zero: Long = 0
        while (true) {
            next()
            if (value.rem(mustMod) == zero) {
                break
            }
        }
        return value
    }
}

class Judge(val iterations: Long) {
    val modulus = 65536

    fun compare(generatorA: Generator, generatorB: Generator):Long {
        var matching: Long = 0
        for (i in 1..iterations) {
            val vA = generatorA.next().rem(modulus)
            val vB = generatorB.next().rem(modulus)
            
            if (vA == vB) {
                matching ++;
            }
        }
        return matching
    }

    fun compareMatching(generatorA: Generator, mustA: Long, generatorB: Generator, mustB: Long):Long {
        var matching: Long = 0
        for (i in 1..iterations) {
            val vA = generatorA.nextMatching(mustA).rem(modulus)
            val vB = generatorB.nextMatching(mustB).rem(modulus)
            
            if (vA == vB) {
                matching ++;
            }
        }
        return matching
    }
}

fun partA() {
    val modulus: Long = 2_147_483_647

    val generatorA = Generator(873, 16807, modulus)
    val generatorB = Generator(583, 48271, modulus)
    
    val judge = Judge(40_000_000)
    val compared = judge.compare(generatorA,  generatorB)
    println("Part A count: $compared") // 631
}

fun partB() {
    val modulus: Long = 2_147_483_647

    val generatorA = Generator(873, 16807, modulus)
    val generatorB = Generator(583, 48271, modulus)
    
    val judge = Judge(5_000_000)
    val compared = judge.compareMatching(generatorA, 4, generatorB, 8)
    println("Part B count: $compared")     
}

fun main(args: Array<String>) {
    
    partA()
    partB()

}
