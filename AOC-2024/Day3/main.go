package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

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

	var input string
	sc := bufio.NewScanner(file)
	for sc.Scan() {
		input += sc.Text()
	}

	if err := sc.Err(); err != nil {
		fmt.Println("[ERROR] reading file failed:", err)
		os.Exit(1)
	}

	regexSearch(input)
}

func regexSearch(input string) {
	re, err := regexp.Compile(`mul\((\d{1,3}),(\d{1,3})\)`)
	if err != nil {
		fmt.Println("[ERROR] compiling regex failed:", err)
		os.Exit(1)
	}

	matches := re.FindAllStringSubmatch(input, -1)

	sum := 0
	for _, match := range matches {
		num1, _ := strconv.Atoi(match[1])
		num2, _ := strconv.Atoi(match[2])

		sum += num1 * num2
	}

	fmt.Println("Sum of multiplications:", sum)
}
