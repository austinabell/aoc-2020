import java.io.File
import java.util.*
import java.util.regex.Pattern

open class Passport() {
    open var fields: MutableMap<String, String> = mutableMapOf()
}

fun numFullValidated(passports: List<Passport>): Int {
    var valid = 0
    outer@ for (passport in passports) {
        if (passport.fields.size == 7) {
            for ((key, value) in passport.fields.entries) {
                when (key) {
                    "byr" -> {
                        if (!value.matches("(19[2-9][0-9]|200[0-2])".toRegex()))
                            continue@outer
                    }
                    "iyr" -> {
                        if (!value.matches("(201[0-9]|2020)".toRegex()))
                            continue@outer
                    }
                    "eyr" -> {
                        if (!value.matches("(202[0-9]|2030)".toRegex()))
                            continue@outer
                    }
                    "hgt" -> {
                        if (!value.matches("((1([5-8][0-9]|9[0-3])cm)|((59|6[0-9]|7[0-6])in))".toRegex()))
                            continue@outer
                    }
                    "hcl" -> {
                        if (!value.matches("#[0-9a-f]{6}".toRegex()))
                            continue@outer
                    }
                    "ecl" -> {
                        if (!value.matches("(amb|blu|brn|gry|grn|hzl|oth)".toRegex()))
                            continue@outer
                    }
                    "pid" -> {
                        if (!value.matches("[0-9]{9}".toRegex()))
                            continue@outer
                    }
                    else -> {
                        // don't care
                    }
                }
            }
            valid += 1
        }
    }

    return valid
}

fun numValidated(passports: List<Passport>): Int {
    var valid = 0
    for (passport in passports) {
        if (passport.fields.size >= 7) {
            
            valid += 1
        }
    }

    return valid
}

fun buildPassports(input: List<String>): List<Passport> {
    var passports: MutableList<Passport> = mutableListOf()

    var currPassport = Passport()

    for (item in input) {
        item.split(' ')
            .map { it.split(':') }
            .map { when (it[0]) {
                "byr" -> currPassport.fields.put(it[0], it[1])
                "iyr" -> currPassport.fields.put(it[0], it[1])
                "eyr" -> currPassport.fields.put(it[0], it[1])
                "hgt" -> currPassport.fields.put(it[0], it[1])
                "hcl" -> currPassport.fields.put(it[0], it[1])
                "ecl" -> currPassport.fields.put(it[0], it[1])
                "pid" -> currPassport.fields.put(it[0], it[1])
                // Ignore for simplicity
                // "cid" -> currPassport.fields.put(it[0], it[1])
                else -> {
                    // don't care
                }
            } }
    
        if (item.isBlank()) {
            passports.add(currPassport)
            currPassport = Passport()
        }

    }

    passports.add(currPassport)
    return passports 
}

fun main() {
    val input: List<String> = File("input.txt").readLines()
    val passports = buildPassports(input)
    println(numValidated(passports))
    println(numFullValidated(passports))
}
