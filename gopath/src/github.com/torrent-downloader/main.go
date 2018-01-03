package main

import (
	"os"
	"encoding/json"
	"errors"
	"fmt"
	"html/template"
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"

	"github.com/PuerkitoBio/goquery"
)

var tvCalendarURL = "https://www.pogdesign.co.uk/cat/login"
var tvCalenderUsername = ""
var tvCalenderPassword = ""

var torrentAPIURL = "https://torrentapi.org/pubapi_v2.php"

var premiumizeAPIURL = "https://www.premiumize.me/api"
var premiumizeCustomerID = ""
var premiumizePIN = ""

func init(){
	tvCalenderUsername = os.Getenv("TV_CALENDAR_USERNAME")
	tvCalenderPassword = os.Getenv("TV_CALENDAR_PASSWORD")
	premiumizeCustomerID =	os.Getenv("PREMIUMIZE_CUSTOMER_ID")
	premiumizePIN = os.Getenv("PREMIUMIZE_PIN")
}

func main() {

	getSeries()

	//token, err := getToken()
	//handleError(err)

	//fmt.Printf("Token is %s\n", token)

	//torrentResults, err := searchTorrent("Handmaids 1080p AMZN", "41", token)
	//handleError(err)

	//fmt.Printf("%v", torrentResults)
	//for _, torrent := range torrentResults.TorrentResults {
	//addTorrent(torrent.Download, premiumizeCustomerID, premiumizePIN)
	//}
}

func getSeries() {

	param := url.Values{}
	param.Set("username", tvCalenderUsername)
	param.Add("password", tvCalenderPassword)
	param.Add("sub_login", "Account+Login")

	fmt.Printf("Calling url %s\n", tvCalendarURL)
	response, err := http.Post(tvCalendarURL, "application/x-www-form-urlencoded", strings.NewReader(param.Encode()))
	handleError(err)

	doc, err := goquery.NewDocumentFromResponse(response)
	handleError(err)

	days := doc.Find(".day")

	for _, node := range days.Nodes {
		fmt.Printf("%v\n", node)
	}	
}

func addTorrent(torrent string, customerID string, pin string) {

	query := "/transfer/create?type=torrent&src=" + torrent + "&customer_id=" + customerID + "&pin=" + pin

	url := premiumizeAPIURL + query

	fmt.Printf("Calling url %s\n", url)
	response, err := http.Get(url)
	handleError(err)

	data, err := ioutil.ReadAll(response.Body)
	handleError(err)

	fmt.Printf("data:%s", data)
}

/*
  categories: (semikolon seperated)
  * 18: TV Episodes
  * 41: TV HD Episodes
  * 49: TV UHD Episodes
*/
func searchTorrent(searchString string, category string, token string) (TorrentResults, error) {

	query := ""

	if category == "" {
		query = "?mode=search&search_string=" + template.URLQueryEscaper(searchString) + "&limit=100&token=" + token
	} else {
		query = "?mode=search&search_string=" + template.URLQueryEscaper(searchString) + "&category=" + category + "&limit=100&token=" + token
	}

	url := torrentAPIURL + query

	fmt.Printf("Calling url %s\n", url)
	response, err := http.Get(url)
	handleError(err)

	data, err := ioutil.ReadAll(response.Body)
	handleError(err)

	var torrentResults TorrentResults
	err = json.Unmarshal([]byte(data), &torrentResults)
	handleError(err)

	return torrentResults, nil
}

func getToken() (string, error) {

	url := torrentAPIURL + "?get_token=get_token"

	fmt.Printf("Calling url %s\n", url)
	response, err := http.Get(url)
	handleError(err)

	data, err := ioutil.ReadAll(response.Body)
	handleError(err)

	var parsedJSON map[string]interface{}
	err = json.Unmarshal([]byte(data), &parsedJSON)
	handleError(err)

	if token, ok := parsedJSON["token"]; ok {
		if tokenString, ok := token.(string); ok {
			return tokenString, nil
		}
	}

	return "", errors.New("No token returned")
}

func handleError(err error) {
	if err != nil {
		panic(err)
	}
}

type TorrentResults struct {
	TorrentResults []Torrent `json:"torrent_results"`
}

type Torrent struct {
	Filename string `json:"filename"`
	Category string `json:"category"`
	Download string `json:"download"`
}
