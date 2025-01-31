package cmd

import (
	"github.com/manifoldco/promptui"
	"github.com/spf13/cobra"
)

var createPostTemplate = &cobra.Command{
	Use:   "blog",
	Short: "Create a new post template populated with frontmatter fields as per Hugo standards.",
	Long: `This command starts an interactive prompt asking all the frontmatter fields which are used to populate the template file.

	You can also specify custom fields through a simple YAML config file.

	`,
}

func postTemplate() {
	prompt := promptui.Prompt{}
}
