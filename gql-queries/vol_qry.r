library(glue)

vol_qry <- function(id, from, to) {
  # Construct the GraphQL query using glue with custom delimiters
  query <- glue("
  {{
    trafficData(trafficRegistrationPointId: \"{{id}}\") {
      volume {
        byHour(from: \"{{from}}\", to: \"{{to}}\") {
          edges {
            node {
              from
              to
              total {
                volumeNumbers {
                  volume
                }
              }
            }
          }
        }
      }
    }
  }}",
                id = id, 
                from = from, 
                to = to,
                .open = "{{", 
                .close = "}}"
  )
  
  return(query)
}
