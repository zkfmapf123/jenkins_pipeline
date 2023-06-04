package tasks

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"os/exec"

	"github.com/spf13/cobra"
	"zkfmapf123.github.com/devops-tools/utils"
)

func FolderMaker() {
	utils.CmdClear()
	dirnames := utils.GetDirnames("../infra")
	installNeedFiles := []string{
		"provider.tf",
		"main.tf",
		"backend.tf",
		"local.tf",
		"data.tf",
		"output.tf",
		"vars.tf",
	}

	rootCmd := &cobra.Command{
		Use:   "mycli",
		Short: "Select Add to Items Folder? ",
		Run: func(cmd *cobra.Command, args []string) {
			foldername, _ := selectItem(dirnames)
			utils.CmdClear()
			filename := writeToFilename()
			utils.CmdClear()
			installFileFromPath(fmt.Sprintf("../infra/%s/%s", foldername, filename), installNeedFiles)

			fmt.Println("Finish...")
		},
	}

	rootCmd.Execute()

}

func selectItem(dirnames []string) (string, error) {
	fmt.Println("Select to Folder Item")
	for i, dir := range dirnames {
		if dir != "" {
			fmt.Printf("%d. %s\n", i+1, dir)
		}
	}

	selectIndex := selectToItem()

	if selectIndex < 1 || selectIndex > len(dirnames) {
		log.Fatalf("Invalid number, valid number only 1 ~ %d", len(dirnames))
	}

	return dirnames[selectIndex-1], nil
}

func selectToItem() int {

	fmt.Print("설치할 폴더를 설정해주세요 >> ")
	var selectIndex int
	_, err := fmt.Scanln(&selectIndex)
	if err != nil {
		return -1
	}

	return selectIndex

}

func writeToFilename() string {
	fmt.Print("Write to Foldername : ")

	sc := bufio.NewScanner(os.Stdin)
	sc.Scan()
	filename := sc.Text()

	if err := sc.Err(); err != nil {
		log.Fatalln(err)
	}

	return filename

}

func installFileFromPath(path string, filenames []string) {

	cmd := exec.Command("mkdir", path)
	cmd.Output()

	for _, filename := range filenames {
		installPath := fmt.Sprintf("%s/%s", path, filename)

		cmd := exec.Command("touch", installPath)
		cmd.Output()
	}
}
