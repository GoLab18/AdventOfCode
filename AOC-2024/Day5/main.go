package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Rule [2]int
type Update []int

func main() {
	var filepath string
	flag.StringVar(&filepath, "p", "test.txt", "Path of the file to read, defaults to `test.txt`")
	flag.Parse()

	file, err := os.Open(filepath)
	if err != nil {
		fmt.Println("[ERROR] can't open the file:", err)
		os.Exit(1)
	}

	defer file.Close()

	var (
		rules   []Rule
		updates []Update
	)
	sc := bufio.NewScanner(file)

	isRules := true
	for sc.Scan() {
		line := sc.Text()

		if line == "" {
			isRules = false
		}

		if isRules {
			l := strings.Split(line, "|")

			v1, _ := strconv.Atoi(l[0])
			v2, _ := strconv.Atoi(l[1])

			rules = append(rules, [2]int{v1, v2})

			continue
		}

		var update []int
		r := strings.Split(line, ",")

		for _, v := range r {
			val, _ := strconv.Atoi(v)
			update = append(update, val)
		}

		updates = append(updates, update)
	}

	if err := sc.Err(); err != nil {
		fmt.Println("[ERROR] reading file failed:", err)
		os.Exit(1)
	}

	// Part 1
	fmt.Println("Sum of middle page numbers ->", correctOrderSum(rules, updates))
}

func correctOrderSum(rules []Rule, updates []Update) int {
	sum := 0
	for _, u := range updates {
		if isValid(u, rules) {
			sum += getMiddlePage(u)
		}
	}

	return sum
}

func isValid(u Update, rules []Rule) bool {
	for i := 0; i < len(u)-1; i++ {
		prev, next := u[i], u[i+1]
		for _, rule := range rules {
			if prev == rule[1] && next == rule[0] {
				return false
			}
		}
	}

	return true
}

func getMiddlePage(s []int) int {
	return s[len(s)/2]
}
