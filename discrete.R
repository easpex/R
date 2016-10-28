options(digits = 22)


### P functions computes P(n, k); P(5, 4) = 120

P<-function(n, k){
  if(k==0) {return(1)}
  if(n == (n - k +1)) {
    return(n)
  } else {
    n * P(n - 1, k-1)
    
  }}

##### factorial wrapper

f<-function(x) {
  
  factorial(x)
}


##### built-in combination functions:

ncol(combn(5,3))

require(combinat)

#combinations
combinat::nCm(5,3)

############ my combination function based on my permutation function
C<- function(n, k) {
  P(n,k) / P(k,k)
  
}
############ my combination with repetitions function based on my combination function
D<- function(n,k) {
  C(n - 1 + k, k)
  
}


f(13)/(f(3)^3*f(4)) - 3*f(11)/(f(3)^2*f(4)) - f(10)/f(3)^3 +3*f(9)/(f(3)*f(4)) +
  3*f(8)/f(3)^2 - f(7)/f(4) - 3*f(6)/f(3)+f(4)

D(3,14)-D(3,4)
C(16,14)
4*( f(5)/f(2) )

sum(sapply(1:5, function(x) C(5,x)))

require(numbers)
numbers::primeFactors(1001)
numbers::eulersPhi(120)

numbers::isPrime(4)

############fibonacci explicit formula

fibo<-function(x) {
  if(x==0) {return(0)} 
  else if(x==1) {return(1)} 
  else {
    
    return(fibo(x-1)+fibo(x-2))
  }
  }
  fibo(6)
numbers::fibonacci(8)
fiboExp<-function(n) {
  
  (((1+sqrt(5))/2)^(n+1) - ((1-sqrt(5))/2)^(n+1))/sqrt(5)
}

fiboExp(7)


(((1+sqrt(5))/2)^(n+1) - ((1-sqrt(5))/2)^(n+1))/sqrt(5)

sapply(c(1:15), fibo)
sapply(c(0:15), fiboExp)


b<-2^62-62-1-(26*26)-2*(26*10)

a<-2^62-( 2*2^36 + 2^52) + ( 2*2^26 + 2^10) -1
a-b


# ???????? 20476 ?????????? 2014 ?? ????????87
q<-3
1+sum(sapply(1:q, function(x) C(q,x)))

2^6-2^5-2^4-2^3
2^8-2^7-2^6-2^5
2^9-2^8-2^7-2^6
2^10-2^9-2^8-2^7
### the function checks if there're any duplicates in a data frame/matrix
### if we concatenate the values of all columns of a given row into a single string

uniqueCheck<-function(m) {  # m is a matrix/data frame
  mUnique<-data.frame()
  for(i in 1:nrow(m)) {
    tmp<-""
    
    # this loop concats the values of all columns within a single row into a single string
    for(j in 1: ncol(m)) {
      tmp<-sprintf("%s%s", tmp, m[i,j])
      
    }
    # assign the value to the corresponding row within mUnique dataframe
    mUnique[i,1]<-tmp
    
    
  }
  
  # check uniqueness: if the number of rows in the result data frame equals
  # the number of rows in the original data frame then we're good
  if(nrow(unique(mUnique))==nrow(m)) {
    
    print("No Duplicates Found")
  } else {
    print("Duplicates Found!")
  }
}

### the function builds a table of permutations with repetitions based on the numbers of
### seats (columns in the resulting table) and variables (unique values)

printPermsWithReps<-function(seats, variables) {
rows<-variables^seats  #calculates the numbber of rows
m<-matrix(0, nrow = rows, ncol = seats) #create an empty matrix

for(j in 1:seats) { # this loop assigns a new column to the table
                    # as well as decreases the alternation and
                    # initiates an empty vector
  
  vec<-vector()
  alt<-rows/variables  #alternation: after how many rows should we print new variable
  
  for(i in 1:variables) { #this loop builds a single column based on the alternation
    vec<-c(vec,rep(i,alt))  
    
  }

  m[,j]<-vec
  rows<-rows/variables
}
print(m)
cat("\n")
uniqueCheck(m)  #checks if all permutations are indeed unique
}


printPermsWithReps(seats = 3, variables = 2)
  

printPermsWithReps(seats = 7, variables = 1)


sapply(c(71, 52, 33, 14), function(x) D(4,x))
floor(5.9)
ceiling(5.1)
P(3,3)
y<-1
(function(x) 1/(x+1))(y)

(function(x) {if(abs(x)>=1){return(1/x-1)}else{return(x)}})(y)


x<-314
y<-""
for(i in 1:nchar(x)) {
  unit<-substr(x = x, start = 0, stop = 1)
  unit<-as.numeric(unit)
  x<-substr(x = x, start = 2, stop = nchar(x))
  
  for(i in 1:unit) {
    y<-paste(y, "1")
    
  }
  y<-paste(y, "0")
}
y<-paste("0,", y, sep = "")

a<-1:10
sapply(a, function(x) abs(1-x)/3)
