package api

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"time"
)

func UploadPhotoHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")

	if err := r.ParseMultipartForm(10 << 20); err != nil {
		http.Error(w, "file too large", http.StatusBadRequest)
		return
	}

	file, header, err := r.FormFile("photo")
	if err != nil {
		http.Error(w, "missing 'photo' field", http.StatusBadRequest)
		return
	}
	defer file.Close()

	// Make sure ./photos/ directory exists
	if err := os.MkdirAll("./photos", os.ModePerm); err != nil {
		http.Error(w, "could not create photos dir", http.StatusInternalServerError)
		return
	}

	ext := filepath.Ext(header.Filename)
	filename := fmt.Sprintf("%d%s", time.Now().UnixNano(), ext)
	dst, err := os.Create("./photos/" + filename)
	if err != nil {
		http.Error(w, "could not save file", http.StatusInternalServerError)
		return
	}
	defer dst.Close()

	if _, err := io.Copy(dst, file); err != nil {
		http.Error(w, "could not write file", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{
		"url": "/photos/" + filename,
	})
}
