//: Playground - noun: a place where people can play
import GameplayKit
import UIKit

var str = "Hello, playground"

srand(UInt32(time(nil)))
print(rand())
print(rand())
print(rand())
print(rand())

print(arc4random())
print(arc4random())
print(arc4random())
print(arc4random())
print(arc4random_uniform(6))

print(GKRandomSource.sharedRandom().nextInt())
print(GKRandomSource.sharedRandom().nextIntWithUpperBound(6))

let source = GKARC4RandomSource()
source.nextIntWithUpperBound(20)
source.dropValuesWithCount(1024)

let source2 = GKMersenneTwisterRandomSource()
source2.nextIntWithUpperBound(20)

let d6 = GKRandomDistribution.d6()
d6.nextInt()

let d20 = GKRandomDistribution.d20()
d20.nextInt()

let crazy = GKRandomDistribution(lowestValue: 1, highestValue: 11539)
crazy.nextInt()

let rand = GKMersenneTwisterRandomSource()
let distribution = GKRandomDistribution(randomSource: rand, lowestValue: 10, highestValue: 20)
print(distribution.nextInt())

let distribution2 = GKShuffledDistribution.d6()
print(distribution2.nextInt())
print(distribution2.nextInt())
print(distribution2.nextInt())
print(distribution2.nextInt())
print(distribution2.nextInt())
print(distribution2.nextInt())
print(distribution2.nextInt())

let lotteryBalls = [Int](1...49)
let shuffledBalls = GKARC4RandomSource.sharedRandom().arrayByShufflingObjectsInArray(lotteryBalls)
print(shuffledBalls[0])
print(shuffledBalls[1])
print(shuffledBalls[2])
print(shuffledBalls[3])
print(shuffledBalls[4])
print(shuffledBalls[5])

let lotteryBalls2 = [Int](1...49)
let shuffledBalls2 = GKMersenneTwisterRandomSource(seed: 1001).arrayByShufflingObjectsInArray(lotteryBalls2)
print(shuffledBalls2[0])
print(shuffledBalls2[1])
print(shuffledBalls2[2])
print(shuffledBalls2[3])
print(shuffledBalls2[4])
print(shuffledBalls2[5])