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

	// s := partOneRegexSearch(input)
	s := partOneCustomSearch(input)

	fmt.Println("Sum of multiplications:", s)
}

func partOneRegexSearch(input string) (sum int) {
	re, err := regexp.Compile(`mul\((\d{1,3}),(\d{1,3})\)`)
	if err != nil {
		fmt.Println("[ERROR] compiling regex failed:", err)
		os.Exit(1)
	}

	matches := re.FindAllStringSubmatch(input, -1)

	for _, match := range matches {
		num1, _ := strconv.Atoi(match[1])
		num2, _ := strconv.Atoi(match[2])

		sum += num1 * num2
	}

	return
}

func partOneCustomSearch(input string) (sum int) {
	i, n := 0, len(input)

	for i < n {
		if i+3 < n && input[i:i+4] == "mul(" {
			// Skip it
			i += 4

			num1, newIndex := parseNum(input, i)
			if newIndex == -1 || newIndex >= n || input[newIndex] != ',' {
				continue
			}

			// Skip `,`
			i = newIndex + 1

			num2, newIndex := parseNum(input, i)
			if newIndex == -1 || newIndex >= n || input[newIndex] != ')' {
				continue
			}

			// Skip `)`
			i = newIndex + 1

			sum += num1 * num2
		} else {
			i++
		}
	}

	return
}

func parseNum(input string, startIndex int) (int, int) {
	i, n := startIndex, len(input)

	for i < n && input[i] >= '0' && input[i] <= '9' {
		i++
	}

	if i == startIndex {
		return 0, -1
	}

	num, _ := strconv.Atoi(input[startIndex:i])
	return num, i
}
