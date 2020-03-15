# Host your file
http.Handle("/assets", http.StripPrefix("/assets", http.FileServer(http.Dir("/path/to/assets/")))
