package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func read_input() []int {
	raw_data, err := ioutil.ReadFile("2-input")
	check(err)

	prepared_data := strings.TrimSuffix(string(raw_data), "\n")
	data := strings.Split(prepared_data, ",")

	numbers := []int{}

	for _, i := range data {
		number, err := strconv.Atoi(i)
		check(err)

		numbers = append(numbers, number)
	}

	return numbers
}

func run_with_inputs(input []int, first, second int) int {
	operator_index := 0
	running := true
	input[1] = first
	input[2] = second

	for running {
		opcode := input[operator_index]
		target := input[operator_index+3]

		switch opcode {
		case 1:
			i1 := input[input[operator_index+1]]
			i2 := input[input[operator_index+2]]
			sum := i1 + i2

			input[target] = sum
		case 2:
			i1 := input[input[operator_index+1]]
			i2 := input[input[operator_index+2]]
			product := i1 * i2

			input[target] = product
		case 99:
			running = false
		}

		operator_index += 4
	}

	return input[0]
}

func First(input []int, first, second int) int {
	return run_with_inputs(input, first, second)
}

func Second(input []int) int {
	var res int

out:
	for i := 1; i < 100; i++ {
		for j := 1; j < 100; j++ {
			dup_input := make([]int, len(input))
			copy(dup_input, input)

			result := run_with_inputs(dup_input, i, j)

			if result == 19690720 {
				res = 100*i + j
				break out
			}
		}
	}

	return res
}

func main() {
	fmt.Println(First(read_input(), 12, 2))
	fmt.Println(Second(read_input()))
}
