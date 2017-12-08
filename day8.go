package main

import (
	"bufio"
	"errors"
    "fmt"
	"os"
	"strconv"
	"strings"
)

type Operation int

const (
	noop Operation = iota
	inc
	dec
)

type Comparison int

const (
	na Comparison = iota
	gt
	lt
	gte
	lte
	e
	ne
)

type Instruction struct {
	register string
	operation Operation
	changeValue int
	comparee string
	comparison Comparison
	compareValue int
}

func getMemory() (map[string]int) {
	return make(map[string]int)
}

func parseLine(line string) (instruction Instruction, err error) {
	parts := strings.Split(line, " ")
	instruction.register = parts[0]
	if parts[1] == "inc" {
		instruction.operation = inc
	} else if parts[1] == "dec" {
		instruction.operation = dec
	}
	v, err := strconv.ParseInt(parts[2], 10, 32)
	if err != nil {
		return instruction, err
	}
	instruction.changeValue = int(v)
	instruction.comparee = parts[4]
	switch parts[5] {
	case "<":
		instruction.comparison = lt
	case ">":
		instruction.comparison = gt
	case "<=":
		instruction.comparison = lte
	case ">=":
		instruction.comparison = gte
	case "==":
		instruction.comparison = e
	case "!=":
		instruction.comparison = ne
	default:
		return instruction, errors.New("error: bad comparison encountered" + parts[5])
	}
	v, err = strconv.ParseInt(parts[6], 10, 32)
	if err != nil {
		return instruction, err
	}
	instruction.compareValue = int(v)

	return instruction, nil
}

func getInstructions(fileName string) (instructions []Instruction, err error) {
	file, err := os.Open(fileName)
	if err != nil {
		return instructions, err
	}
	defer file.Close()

	reader := bufio.NewReader(file)

	for {
		line, err := reader.ReadString('\n')
		if err != nil {
			break
		}
		if line == "" {
			continue
		}
		line = strings.TrimSpace(line)
		instruction, err := parseLine(line)
		if err != nil {
			return instructions, err
		}
		instructions = append(instructions, instruction)
	}

	return instructions, err
}

func followInstruction(memory map[string]int, instruction Instruction) map[string]int {

	var comp func(a string, b int) bool
	switch instruction.comparison {
	case gt:
		comp = func(a string, b int) bool { return memory[a] > b }
	case lt:
		comp = func(a string, b int) bool { return memory[a] < b }
	case gte:
		comp = func(a string, b int) bool { return memory[a] >= b }
	case lte:
		comp = func(a string, b int) bool { return memory[a] <= b }
	case e:
		comp = func(a string, b int) bool { return memory[a] == b }
	case ne:
		comp = func(a string, b int) bool { return memory[a] != b }
	}

	if comp(instruction.comparee, instruction.compareValue) == true {
		if instruction.operation == inc {
			memory[instruction.register] += instruction.changeValue
		} else if instruction.operation == dec {
			memory[instruction.register] -= instruction.changeValue
		}
	}

	return memory
}

func followInstructions(memory map[string]int, instructions []Instruction) (map[string]int, int) {
	highestEver := -32000
	for i := range instructions {
		memory = followInstruction(memory, instructions[i])
		max := maxInMap(memory)
		if max > highestEver {
			highestEver = max
		}
	}
	return memory, highestEver
}

func maxInMap(memory map[string]int) int {
	max := -32000
	for i := range memory {
		if memory[i] > max {
			max = memory[i]
		}
	}
	return max
}

func main() {
	memory := getMemory()
	instructions, err := getInstructions("data/day8.txt")
	if err != nil {
		fmt.Println("error occured", err)
		return
	}
	var highest int
	memory, highest = followInstructions(memory, instructions)

	fmt.Println(memory)
	max := maxInMap(memory)
	println("max:", max)
	println("highest ever", highest)
}