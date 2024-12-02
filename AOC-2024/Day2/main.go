package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	var filepath string
	flag.StringVar(&filepath, "p", "test.txt", "Path of the file to read, defaults to `test.txt`")
	flag.Parse()

	f, err := os.Open(filepath)
	if err != nil {
		fmt.Println("[ERROR] can't open the file:", err)
		os.Exit(1)
	}

	defer f.Close()

	sc := bufio.NewScanner(f)

	var reports [][]int

	for sc.Scan() {
		line := sc.Text()
		prts := strings.Fields(line)

		var levels []int
		for _, v := range prts {
			num, _ := strconv.Atoi(v)

			levels = append(levels, num)
		}

		reports = append(reports, levels)
	}

	if err := sc.Err(); err != nil {
		fmt.Println("[ERROR] reading file failed:", err)
		os.Exit(1)
	}

	// Part 1

	safeCount := 0
	for _, r := range reports {
		if isSafe(r) {
			safeCount++
		}
	}

	fmt.Println("Safe reports ->", safeCount)
}

func isSafe(rp []int) bool {
	if len(rp) < 2 {
		return true
	}

	var isOrderSet, isAscending bool

	for i := 1; i < len(rp); i++ {
		diff := rp[i] - rp[i-1]

		currOrder := diff > 0

		if (currOrder && (diff < 1 || diff > 3)) || (!currOrder && (diff > -1 || diff < -3)) {
			return false
		}

		if !isOrderSet {
			isOrderSet = true
			isAscending = currOrder

			continue
		}

		if currOrder != isAscending {
			return false
		}
	}

	return true
}
