options(digits = 22)

# calculate quadratic equation roots

q2roots<-function(a, b, c) {
  discriminant<- b^2 - 4 * a * c
  if(discriminant > 0) {
    x1<- (-b + sqrt(discriminant) ) / (2 * a) 
    x2<- (-b - sqrt(discriminant) )/ (2 * a) 
  }
  
  
  
}