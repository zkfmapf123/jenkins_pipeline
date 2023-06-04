package utils

import (
	"bufio"
	"log"
	"os"
	"os/exec"
	"strings"
)

func GetDirnames(folderpath string) []string {
	dirs, err := os.ReadDir(folderpath)
	if err != nil {
		log.Fatalln(err)
	}

	dirnames := make([]string, len(dirs))
	for i, dir := range dirs {
		if !strings.Contains(dir.Name(), "tf.tfvars") {
			dirnames[i] = dir.Name()
		}

	}

	return dirnames
}

func Input() string {
	sc := bufio.NewScanner(os.Stdin)
	sc.Scan()
	return sc.Text()
}

func CmdClear() {
	c := exec.Command("clear")
	c.Stdout = os.Stdout
	c.Run()
}
