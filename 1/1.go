package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func read_input() []int {
	input, err := os.Open("1-input")
	var numbers []int

	if err != nil {
		log.Fatal(err)
	}

	scanner := bufio.NewScanner(input)

	for scanner.Scan() {
		x, err := strconv.Atoi(scanner.Text())
		if err != nil {
			log.Fatal(err)
		}
		numbers = append(numbers, x)
	}

	return numbers
}

func First(input []int) int {
	sum := 0

	for _, element := range input {
		sum += element/3 - 2
	}

	return sum
}

func Second(input []int) int {
	sum := 0

	for _, element := range input {
		for element > 0 {
			fuel := element/3 - 2

			if fuel > 0 {
				sum += fuel
			}

			element = fuel
		}
	}

	return sum
}

func main() {
	input := read_input()

	fmt.Println(First(input))
	fmt.Println(Second(input))
}
