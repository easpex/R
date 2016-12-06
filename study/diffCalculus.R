options(digits = 22)

# calculate quadratic equation roots

q2roots<-function(a, b, c) {
  discriminant<- b^2 - (4 * a * c)
  if(discriminant > 0) {
    x1<- (-b + sqrt(discriminant) ) / (2 * a) 
    x2<- (-b - sqrt(discriminant) )/ (2 * a)
    print(paste("x1 = ", x1, " | ", "x2 = ", x2, sep = ""))
  } else if(discriminant == 0) {
    x <- -(b / (2*a) )
    print(paste("x = ", x))
  } else {
    print("There're no real roots!")
  }
} # end of function


q2roots(a = -2, b = -4, c = 2)

for(i in 2:100) {
  a <- -i
  b <- i
  # power <- 2/3
  a <- a^3/5
  b <- b^3/5
  print(sprintf("a = %s | b = %s", a, b))
  if(a < b) {
    print("a < b")
  } else if(a == b){
    print("a == b")
  } else {
    print("a > a")
  }
}

for(i in -50:50) {
  if(i < -1) {
    print(-i-1)
  } else {
    print(i+1)
  }
}

(function(x) print(sprintf("sin = %s | cos = %s", sin(x), cos(x))))(-pi)
