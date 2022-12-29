package scaffold

import (
	"fmt"
	"os"

	"github.com/pressfio/ci-cd/pressf-cli/boilerplate"
	"github.com/spf13/cobra"
)

func Execute() {
	scaffoldCmd := &cobra.Command{
		Use: "scaffold",
		Run: func(cmd *cobra.Command, _ []string) {
			curDir, err := os.Getwd()
			_ = err

			if err := boilerplate.ExtactContentToDir(cmd.Context(), curDir); err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
		},
	}

	if err := scaffoldCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
