options(digits = 22)

Md<-function(L0, L1, n, FgroupBefore, fThisGroup) {
  result<-(n/2 - FgroupBefore)/fThisGroup
  result<-result * (L1 - L0)
  result<-result + L0
  print(result)
}

Ck<-function(L0, L1, n, FgroupBefore, fThisGroup, k) {
  result<-( (n*k)/100 - FgroupBefore)/fThisGroup
  #print(result)
  result<-result * (L1 - L0)
  #print(result)
  result<-result + L0
  print(result)
}

K<-function(L0, L1, n, FgroupBefore, fThisGroup, Ck) {
  result<-(Ck - L0) / (L1 - L0)
  print(result)
  result<-result * fThisGroup
  print(result)
  result<-result + FgroupBefore
  print(result)
  result<-result * (100/n)
  print(result)
}


Md(L0 = 8, L1 = 12, n = 80, FgroupBefore = 38, fThisGroup = 20)

c<-Ck(L0 = 8, L1 = 12, n = 80, FgroupBefore = 38, fThisGroup = 20, k = 50)

K(L0 = 8, L1 = 12, FgroupBefore = 38, fThisGroup = 20, n = 80, Ck = 11)

K(L0 = 5, L1 = 10, FgroupBefore = 20, fThisGroup = 30, n = 100, Ck = 8)
