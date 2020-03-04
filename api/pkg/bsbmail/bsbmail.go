package bsbmail

import (
	"log"
	"net/smtp"
	"strings"
)

type MailHanlder struct {
	logger *log.Logger
}

func (h *MailHanlder) SendMail(to []string) {
	senderName := "haphantestmail@gmail.com"
	senderPass := "Talavua1996"

	subject := "From: " + senderName + "\n" +
		"To: " + strings.Join(to, ",") + "\n" +
		"Subject: Sign up successfully\n"

	msg := "MIME-version: 1.0;\nContent-Type: text/html; charset=\"UTF-8\";\n\n" +
		"<html><body><h1>Congrats, you're a member in our familly now</h1></body></html>"

	err := smtp.SendMail("smtp.gmail.com:587",
		smtp.PlainAuth("", senderName, senderPass, "smtp.gmail.com"),
		senderName, to, []byte(subject+msg))

	if err != nil {
		h.logger.Println("smtp error: ", err)
		return
	}
}

func NewHandler(logger *log.Logger) *MailHanlder {
	return &MailHanlder{
		logger: logger,
	}
}
