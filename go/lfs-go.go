package main

import (
    "fmt"
    "os"
	"path/filepath"
)

func usage() {
	fmt.Println("USAGE: lfs [directory]")
	fmt.Println("       e.g. lfs /tmp/")
	os.Exit(1)
}

func raise(errorType string) {
	fmt.Printf("ERROR: %s\n", errorType)
	os.Exit(1)
}

func exists(fileSystem string) bool {
	if _, err := os.Stat(fileSystem); err != nil {
		if os.IsNotExist(err) {
			return false
		} else {
			raise("stat filesystem exception")
		}
	}
	return true
}

func main() {
	argsCount := len(os.Args)
	if argsCount != 2 {
		usage()
	} else if exists(os.Args[1]) == false {
		raise(os.Args[1] + " not found.")
	} else {
		fmt.Printf("{\n\"files\":\n  [    \n")
		var firstElem bool = true
		filepath.Walk(os.Args[1],
		func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if ! info.IsDir(){
			if ! firstElem {
				fmt.Printf("\n      ,\n")
			} 
			fmt.Printf("      {\"name\":\"" + path + "\",\"size\":%v}", info.Size())
			firstElem = false
		}
		return nil
		})
		fmt.Println("\n    ]\n}")
	}

}

