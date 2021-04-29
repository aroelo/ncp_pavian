to debug in Rshiny on http://rstudio.naktuinbouw.cloud/
```R
library(devtools)
remotes::install_github('git@github.com:aroelo/ncp_pavian.git', ref='dev')
install_github('git@github.com:aroelo/ncp_pavian.git', ref='dev')
pavian::runApp(server_dir = "/6_db_ssd/pavian_input",
db_type = "Postgresql",
domain_suffix = "-dev.naktuinbouw.cloud",
db_host = "172.22.0.3",
db_user = 'hello_flask', 
db_passwd = 'hello_flask',
db_name = 'hello_flask_prod')
```