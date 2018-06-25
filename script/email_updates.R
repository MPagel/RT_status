library(gmailr)


body <- "Sending you an email with gmailr!" # funny work around, otherwise the attachemtn overwrites the body of the email

mime() %>%
  to("gabrielpsinger@gmail.com") %>%
  from("gsinger@ucdavis.edu") %>%
  html_body(body)%>% 
  attach_part(body) %>% 
  subject("Testing Testing") %>%
  attach_file("data/187027_2018_06_25__20_52_33.txt") -> file_attachment

send_message(file_attachment)
