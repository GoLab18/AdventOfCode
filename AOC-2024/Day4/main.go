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
	{-1, -1},
	{1, 1},
	{-1, 1},
	{1, -1},
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

	c1 := firstPartSearch(grid)
	c2 := secondPartSearch(grid)

	fmt.Println("Total occurrences of XMAS part 1 ->", c1)
	fmt.Println("Total occurrences of XMAS part 2 ->", c2)
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

func secondPartSearch(grid []string) (count int) {
	rows := len(grid)
	cols := len(grid[0])

	for row := 0; row < rows; row++ {
		for col := 0; col < cols; col++ {
			if isXMASCell(grid, row, col) {
				count++
			}
		}
	}

	return
}

func isXMASCell(grid []string, row, col int) bool {
	rows := len(grid)
	cols := len(grid[0])

	if grid[row][col] != 'A' || row == 0 || col == 0 || row == rows-1 || col == cols-1 {
		return false
	}

	var state rune
	for i := 4; i < len(directions); i++ {
		dy, dx := directions[i][0], directions[i][1]
		newRow := row + dy
		newCol := col + dx

		r := rune(grid[newRow][newCol])

		if r != 'M' && r != 'S' {
			return false
		}

		if (i == 5 || i == 7) && state == r {
			return false
		}

		state = r
	}

	return true
}
