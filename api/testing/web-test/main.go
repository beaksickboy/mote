package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

type Page struct {
	Title string
	Body  []byte
}

func (p *Page) save() error {
	fileName := p.Title + ".txt"
	// 0600: indicates that the file should be created with read-write permissions for the current user only. (See the Unix man page open(2) for details.)
	return ioutil.WriteFile(fileName, p.Body, 0600)
}

func loadPage(fileName string) (*Page, error) {
	body, err := ioutil.ReadFile(fileName)

	if err != nil {
		return nil, err
	}

	return &Page{Title: fileName, Body: body}, nil
}

func viewHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Println(r.URL.Path)
}

func main() {
	http.HandleFunc("/view/", viewHandler)

	http.ListenAndServe(":8080", nil)
}
