package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
)

const (
	word    = "XMAS"
	wordLen = len(word)
)

var directions = [8][2]int{
	{0, 1},
	{0, -1},
	{1, 0},
	{-1, 0},
	{1, 1},
	{-1, -1},
	{1, -1},
	{-1, 1},
}

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

	var grid []string
	sc := bufio.NewScanner(file)
	for sc.Scan() {
		grid = append(grid, sc.Text())
	}

	if err := sc.Err(); err != nil {
		fmt.Println("[ERROR] reading file failed:", err)
		os.Exit(1)
	}

	count := firstPartSearch(grid)

	fmt.Println("Total occurrences of XMAS:", count)
}

func firstPartSearch(grid []string) (count int) {
	rows := len(grid)
	cols := len(grid[0])

	canWordFit := func(row, col int, dy, dx int) bool {
		endRow := row + dy*(wordLen-1)
		endCol := col + dx*(wordLen-1)

		return endRow >= 0 && endRow < rows && endCol >= 0 && endCol < cols
	}

	// Checks if the word exists starting at a given position in a given direction
	checkWord := func(startRow, startCol int, dy, dx int) bool {
		for i := 0; i < wordLen; i++ {
			y := startRow + i*dy
			x := startCol + i*dx

			if grid[y][x] != word[i] {
				return false
			}
		}

		return true
	}

	for row := 0; row < rows; row++ {
		for col := 0; col < cols; col++ {
			for _, dir := range directions {
				dy, dx := dir[0], dir[1]

				if canWordFit(row, col, dy, dx) && checkWord(row, col, dy, dx) {
					count++
				}
			}
		}
	}

	return
}
