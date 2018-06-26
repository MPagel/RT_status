library(gmailr)


body <- paste("Realtime update for", Sys.Date()) # funny work around, otherwise the attachemtn overwrites the body of the email

mime() %>%
  to("mjthomas@ucdavis.edu") %>%
  from("gsinger@ucdavis.edu") %>%
  html_body(body)%>% 
  attach_part(body) %>% 
  subject("RealTime Update") %>%
  attach_file(paste0("data_output/", Sys.Date(), "_RealTimeReport.csv")) -> file_attachment

send_message(file_attachment)
