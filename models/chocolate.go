package models

type Chocolate struct {
	ID          int      `json:"id"`
	Name        string   `json:"name"`
	Ingredients string   `json:"ingredients"` // ✅ correct
	PhotoUrls   []string `json:"photo_urls"`  // ✅ change to slice

}
type Variants struct {
	ID          int     `json:"id"`
	ChocolateID int     `json:"chocolate_id"`
	Size        string  `json:"size"`
	Weight      float64 `json:"weight"`
	Price       float64 `json:"price"`
}
