## Matrix inversion is usually a costly computation and there may be some
## benefit to caching the inverse of a matrix rather than compute it repeatedly
## (there are also alternatives to matrix inversion that we will not discuss
## here). Your assignment is to write a pair of functions that cache the inverse
## of a matrix.


makeCacheMatrix <- function(x = matrix()) {
  invertM <- NULL
  set <- function(y) {
    x <<- y
    invertM <<- NULL
  }
  get <- function() x
  setInvert <- function(invertedMatrx) invertM <<- invertedMatrx
  getInvert <- function() invertM
  
  
  list(set = set, get = get,
       setInvert = setInvert,
       getInvert = getInvert)
}


cacheSolve <- function(x) {
  ## Return a matrix that is the inverse of 'x'

  m <- x$getInvert()
  if(!is.null(m)) {
    message("getting cached data")
    return(m)
  }
  message("calculate inverse")

  ##  solve(X) returns its inverse

  data <- x$get()
  m <- solve(data)
  x$setInvert(m)
  m
  
}


## Sample code for Vector we introduce the <<- operator which can be used to
## assign a value to an object in an environment that is different from the
## current environment.

makeVector <- function(x = numeric()) {
  m <- NULL
  set <- function(y) {
    x <<- y
    m <<- NULL
  }
  get <- function() x
  setmean <- function(mean) m <<- mean
  getmean <- function() m
  list(set = set, get = get,
       setmean = setmean,
       getmean = getmean)
}

cachemean <- function(x, ...) {
  m <- x$getmean()
  if(!is.null(m)) {
    message("getting cached data")
    return(m)
  }
  message("caulate the mean")
  
  data <- x$get()
  m <- mean(data, ...)
  x$setmean(m)
  m
  
}

testCacheVector <- function(){

  testData <- rnorm(100000)
  testData2 <- testData

  makeV <- makeVector(testData)

  # Start the clock!
  ptm <- proc.time()

  cachemean(makeV)

  print(makeV$getmean())

  # Stop the clock
  print(proc.time() - ptm)

  ptm <- proc.time()
  print("second time")

  cachemean(makeV)

  print (makeV$getmean())
  print(proc.time() - ptm)


  print(" -- normal mean: ")
  print(system.time(
  print(mean(testData2))
  ))
  
}

testCacheMatrix <- function(){

    testM <- matrix(rnorm(1e6),nrow=1e3,ncol=1e3)
  testM2 <- testM

  print("testM to be inverted")
  str(testM)
  print(" -- normal invert: ")

  print(  system.time(
   str(solve(testM2))
  ))

  makeM <- makeCacheMatrix(testM)

  # Start the clock!
  ptm <- proc.time()

  cacheSolve(makeM)

  str(makeM$getInvert())

  # Stop the clock
  print(proc.time() - ptm)

  ptm <- proc.time()
  print("second time")

  cacheSolve(makeM)

  str(makeM$getInvert())

  print(proc.time() - ptm)

  
}

testCacheMatrix_2 <- function(){
  m <- matrix(c(-1, -2, 1, 1), 2,2)
  x <- makeCacheMatrix(m)
  print(x$get())
  ##      [,1] [,2]
  ## [1,]   -1    1
  ## [2,]   -2    1
  inv <- cacheSolve(x)
  print(inv)
  ##      [,1] [,2]
  ## [1,]    1   -1
  ## [2,]    2   -1
  inv <- cacheSolve(x)
  ## getting cached data
  print(inv)
  ##      [,1] [,2]
  ## [1,]    1   -1
  
}

