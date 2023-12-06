package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Race struct {
	time     int
	distance int
}

func Load(path string) (races []Race) {
	file, _ := os.Open(path)
	defer file.Close()

	scanner := bufio.NewScanner(file)
	lines := make([][]string, 0)

	for scanner.Scan() {
		lines = append(lines, strings.Fields(scanner.Text()))
	}

	time := ""
	distance := ""

	for race := 1; race < len(lines[0]); race++ {
		time += lines[0][race]
		distance += lines[1][race]
	}

	t, time_err := strconv.Atoi(time)
	d, dist_err := strconv.Atoi(distance)
	if time_err == nil && dist_err == nil {
		races = append(races, Race{t, d})
	}

	return
}

func Solve(races []Race) (result int) {
	result = 1
	records := make([]int, len(races))

	for i := range races {
		race := races[i]
		for time := 0; time <= race.time; time++ {
			distance := (race.time - time) * time
			if distance > race.distance {
				records[i]++
			}
		}
	}

	for i := range records {
		result = result * records[i]
	}

	return
}

func main() {
	path := os.Args[1]

	races := Load(path)

	result := Solve(races)

	fmt.Println(result)
}
