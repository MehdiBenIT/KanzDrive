variable "rules" {
  type = list(object({
    port        = number
    proto       = string
    cidr_blocks = list(string)
  }))
  default = [ 
    {
    port = 80
    proto = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
    port = 22
    proto = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
    port = 443
    proto = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}