storage "raft" {
  path    = "./vault/data"
  node_id = "node1"
}

listener "tcp" {
  address     = "localhost:8200"
  tls_disable = true
}

api_addr = "http://localhost:8200"
cluster_addr = "https://localhost:8201"
disable_mlock = true
ui = true