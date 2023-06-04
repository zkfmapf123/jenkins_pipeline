package main

import (
	"fmt"
	"log"
	"strconv"

	"github.com/spf13/cobra"
	"zkfmapf123.github.com/devops-tools/tasks"
	"zkfmapf123.github.com/devops-tools/utils"
)

var funcMapper = map[string]func(){
	"folder-maker.go": tasks.FolderMaker,
	"s3_cleaner.go":   tasks.S3Cleaner,
}

func main() {
	files := utils.GetDirnames("./tasks")

	rootCmd := &cobra.Command{
		Use:   "mycli",
		Short: "Correct use Cli Task",
		Run: func(cmd *cobra.Command, args []string) {

			for i, v := range files {
				fmt.Printf("%d. %s\n", i+1, v)
			}

			fmt.Printf("Select Taks Number >> ")
			num, _ := strconv.Atoi(utils.Input())

			if num < 1 || num > len(files) {
				log.Fatalln("invalid task number")
			}

			funcMapper[files[num-1]]()

		},
	}

	rootCmd.Execute()
}
