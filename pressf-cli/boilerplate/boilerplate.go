package boilerplate

import (
	"context"
	"embed"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
)

const contentRootDirName = "content"

//go:embed content/*
var content embed.FS

var (
	fileRWPerm     fs.FileMode = 0o644
	dirDefaultPerm fs.FileMode = 0o744
)

func ExtactContentToDir(_ context.Context, dstDir string) error {
	contentDir, err := content.ReadDir(contentRootDirName)
	if err != nil {
		err = fmt.Errorf("error while reading file from boilerplate; file: %s; err: %w", content, err)

		return err
	}

	for i := range contentDir {
		extractFile(contentRootDirName, dstDir, contentDir[i])
	}

	return nil
}

func extractFile(srcDir, dstDir string, entry fs.DirEntry) (err error) {
	srcPath := filepath.Join(srcDir, entry.Name())
	dstPath := filepath.Join(dstDir, entry.Name())

	if entry.IsDir() {
		if err = os.MkdirAll(dstPath, dirDefaultPerm); err != nil {
			return
		}

		var contentDir []fs.DirEntry
		contentDir, err = content.ReadDir(srcPath)
		if err != nil {
			return
		}

		for i := range contentDir {
			if err = extractFile(srcPath, dstPath, contentDir[i]); err != nil {
				return
			}
		}

		return
	}

	fmt.Printf("extract '%s' -> '%s'... ", srcPath, dstPath)

	defer func() {
		if err != nil {
			fmt.Printf("ERR: %v \n", err)
		}

		fmt.Print("OK\n")
	}()

	var srcFileBuf []byte
	srcFileBuf, err = content.ReadFile(srcPath)
	if err != nil {
		return
	}

	if err = os.WriteFile(dstPath, srcFileBuf, fileRWPerm); err != nil {
		return
	}

	return
}
