package main

import "testing"

func TestFirst(t *testing.T) {
	cases := []struct {
		input    []int
		expected int
	}{
		{[]int{12}, 2},
		{[]int{14}, 2},
		{[]int{1969}, 654},
		{[]int{100756}, 33583},
	}

	for _, a_case := range cases {
		result := First(a_case.input)
		if result != a_case.expected {
			t.Errorf("Result for %d incorrect: expected %d, got %d", a_case.input, a_case.expected, result)
		}
	}
}

func TestSecond(t *testing.T) {
	cases := []struct {
		input    []int
		expected int
	}{
		{[]int{14}, 2},
		{[]int{1969}, 966},
		{[]int{100756}, 50346},
	}

	for _, a_case := range cases {
		result := Second(a_case.input)
		if result != a_case.expected {
			t.Errorf("Result for %d incorrect: expected %d, got %d", a_case.input, a_case.expected, result)
		}
	}
}
