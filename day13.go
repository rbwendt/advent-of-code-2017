package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Layer struct {
	depth int
}

type Firewall struct {
	layers map[int]Layer
	maxLayer int
}

func abs(i int) int {
	if i > 0 {
		return i
	} else {
		return -i
	}
}

func triangleWave(depth int, time int) int {
	if depth == 0 {
		return -1
	}
	
	return depth - abs(time % (2 * depth) - depth)
}

func (f Firewall) penalty(startTime int) int {
	penalty := 0
	for time := 0; time <= f.maxLayer; time++ {
		if layer, ok := f.layers[time]; ok {
			
			if layer.ScannerPosition(startTime + time) == 0 {
				penalty += (startTime + time) * layer.depth
			}
		}
	}
	return penalty
}

func (f Firewall) caught(startTime int) bool {
	
	for time := 0; time <= f.maxLayer; time++ {
		if layer, ok := f.layers[time]; ok {
			
			if layer.ScannerPosition(startTime + time) == 0 {
				return true
			}
		}
	}
	return false
}

func (f Firewall) getDelay() int {
	foundTime := -1
	
	for i := 0; i < 10000000; i++ {
		caught := f.caught(i)
		if !caught {
			foundTime = i
			break
		}
	}
	
	return foundTime;
}

func (l Layer) ScannerPosition(time int) int {
	return triangleWave(l.depth - 1, time)
}

func parseLine(line string) (position int, layer Layer, err error) {
	parts := strings.Split(line, ": ")
	
	v, err := strconv.ParseInt(parts[0], 10, 32)
	if err != nil {
		return 0, layer, err
	}
	position = int(v)

	v, err = strconv.ParseInt(parts[1], 10, 32)
	if err != nil {
		return 0, layer, err
	}
	layer.depth = int(v)

	return position, layer, nil
}

func getWall(fileName string) (wall Firewall, err error) {
	
	wall.layers = make(map[int]Layer)
	
	file, err := os.Open(fileName)
	if err != nil {
		return wall, err
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
		
		position, layer, err := parseLine(line)
		if err != nil {
			return wall, err
		}
		wall.layers[position] = layer
		if position > wall.maxLayer {
			wall.maxLayer = position
		}
	}

	return wall, err
}

func main() {
	wall, err := getWall("data/day13.txt")
	if err != nil {
		fmt.Println("error encountered", err)
		return
	}
	
	fmt.Println("penalty", wall.penalty(0)) //1588

	foundTime := wall.getDelay()
	fmt.Println("delay is", foundTime) // part b
}