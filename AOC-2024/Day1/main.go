package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

func main() {

	// Part 1

	var filepath string
	flag.StringVar(&filepath, "p", "test.txt", "Path of the file to read, defaults to `test.txt`")
	flag.Parse()

	f, err := os.Open(filepath)
	if err != nil {
		fmt.Println("[ERROR] can't open the file:", err)
		os.Exit(1)
	}

	defer f.Close()

	// Slices for lists
	var l, r []int

	sc := bufio.NewScanner(f)
	for sc.Scan() {
		line := sc.Text()
		parts := strings.Fields(line)

		if len(parts) != 2 {
			fmt.Println("[ERROR] wrong file layout, data should be in two columns of integers")
			os.Exit(1)
		}

		n1, _ := strconv.Atoi(parts[0])
		n2, _ := strconv.Atoi(parts[1])

		l = append(l, n1)
		r = append(r, n2)
	}

	if err := sc.Err(); err != nil {
		fmt.Println("[ERROR] reading file failed:", err)
		os.Exit(1)
	}

	slices.Sort(l)
	slices.Sort(r)

	distance := 0
	for i := 0; i < len(l); i++ {
		if diff := l[i] - r[i]; diff < 0 {
			distance -= diff
		} else {
			distance += diff
		}
	}

	fmt.Println("Distance ->", distance)

	// Part two

	freqMap := make(map[int]int, len(l))
	for _, v := range r {
		freqMap[v]++
	}

	var simScore int
	for _, v := range l {
		simScore += v * freqMap[v]
	}

	fmt.Println("Similarity score ->", simScore)
}
