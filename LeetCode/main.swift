//
//  main.swift
//  LeetCode
//
//  Created by Renjun Li on 2025/10/27.
//

import Foundation


class Solution {
    // 两数和
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var hasMap: [Int: Int] = [:]
        for index in 0 ..< nums.count {
            let currentValue = nums[index]

            let otherValue = target - currentValue
            
            if currentValue + otherValue == target, let otherN = hasMap[otherValue] {
                return [otherN, index]
            }
            hasMap[nums[index]] = index
            
        }
        return []
    }
    
    // 合并两个有序数组
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        var p1 = 0, p2 = 0
        var sorted: [Int] = []
        while p1 < m || p2 < n {
            if p1 == m {
                sorted.append(nums2[p2])
                p2 += 1
            } else if p2 == n {
                sorted.append(nums1[p1])
                p1 += 1
            } else if nums1[p1] < nums2[p2] {
                sorted.append(nums1[p1])
                p1 += 1
            } else {
                sorted.append(nums2[p2])
                p2 += 1
            }
        }
        nums1 = sorted
    }
    
    // 移除数组元素
    func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
        var k = 0
        var result: [Int] = []
        for index in 0 ..< nums.count {
            if val != nums[index] {
                k += 1
                result.insert(nums[index], at: 0)
            }
        }
        nums = result
        return k
      }
    
    // 26. 删除有序数组中的重复项
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        var map: [Int: Int] = [:]
        var set: Set<Int> = []
        for index in  0 ..< nums.count {
            set.insert(nums[index])
            map[nums[index]] = index
        }
        nums = set.sorted(by: { $0 < $1 })
        return set.count
    }
    
    // 给你一个有序数组 nums ，请你 原地 删除重复出现的元素，使得出现次数超过两次的元素只出现两次 ，返回删除后数组的新长度。
    // [0,0,1,1,1,1,2,3,3]
    
    func moveElement(moveIndex: Int, nums: inout [Int]) {
        for index in moveIndex ..< nums.count - 1 {
            nums[index] = nums[index + 1]
        }
    }

    func removeDuplicatesII(_ nums: inout [Int]) -> Int {
        if nums.count <= 2 {
            return nums.count
        }
        var j = 2;
        for index in 2 ..< nums.count {
            if nums[index] != nums[j - 2] {
                nums[j] = nums[index]
                j += 1
            }
        }
        return j
    }
    // 给定一个大小为 n 的数组 nums ，返回其中的多数元素。多数元素是指在数组中出现次数 大于 ⌊ n/2 ⌋ 的元素。你可以假设数组是非空的，并且给定的数组总是存在多数元素。
    func majorityElement(_ nums: [Int]) -> Int {
        var n = ceil(Double(nums.count) / 2.0)
        var dict: [Int: Int] = [:]
        for index in 0 ..< nums.count {
            dict[nums[index]] = (dict[nums[index]] ?? 0) + 1
            if dict[nums[index]]! >= Int(n) {
                return nums[index]
            }
        }
        return 1
    }
    
    
    /**
     给定一个整数数组 nums，将数组中的元素向右轮转 k 个位置，其中 k 是非负数。
     示例 1:

     输入: nums = [1,2,3,4,5,6,7], k = 3
     输出: [5,6,7,1,2,3,4]
     解释:
     向右轮转 1 步: [7,1,2,3,4,5,6]
     向右轮转 2 步: [6,7,1,2,3,4,5]
     向右轮转 3 步: [5,6,7,1,2,3,4]
     
     示例 2:

     输入：nums = [-1,-100,3,99], k = 2
     输出：[3,99,-1,-100]
     解释:
     向右轮转 1 步: [99,-1,-100,3]
     向右轮转 2 步: [3,99,-1,-100]
     */
    
    
    func rotate(_ nums: inout [Int], _ k: Int) {
        let n = nums.count
        if n == 0 { return }
        let k = k % n
        reverse(&nums, left: 0, right: n - 1)
        reverse(&nums, left: 0, right: k - 1)
        reverse(&nums, left: k, right: n - 1)
    }
    
    func reverse(_ nums: inout [Int], left: Int, right: Int) {
        var left = left
        var right = right
        while left < right {
            nums.swapAt(left, right)
            left += 1
            right -= 1
        }
    }
    
    /**
    121. 买卖股票的最佳时机
    给定一个数组 prices ，它的第 i 个元素 prices[i] 表示一支给定股票第 i 天的价格。

    你只能选择 某一天 买入这只股票，并选择在 未来的某一个不同的日子 卖出该股票。设计一个算法来计算你所能获取的最大利润。

    返回你可以从这笔交易中获取的最大利润。如果你不能获取任何利润，返回 0 。
     */
    
    func maxProfit(_ prices: [Int]) -> Int {
        var minProfit = Int.max
        var maxProfit = 0
        for price in prices {
            if price < minProfit {
                minProfit = price
            } else {
                let profit = price - minProfit
                if profit > maxProfit {
                    maxProfit = profit
                }
            }
        }
        return maxProfit
    }
    
    /**
     给你一个整数数组 prices ，其中 prices[i] 表示某支股票第 i 天的价格。

     在每一天，你可以决定是否购买和/或出售股票。你在任何时候 最多 只能持有 一股 股票。然而，你可以在 同一天 多次买卖该股票，但要确保你持有的股票不超过一股。

     返回 你能获得的 最大 利润
     */
    
    func maxProfitII(_ prices: [Int]) -> Int {
        var totalProfit = 0
        for i in 1 ..< prices.count {
            if prices[i] > prices[i - 1] {
                totalProfit += prices[i] - prices[i - 1]
            }
        }
        return totalProfit
    }
    
    /**
     给你一个非负整数数组 nums ，你最初位于数组的 第一个下标 。数组中的每个元素代表你在该位置可以跳跃的最大长度。

     判断你是否能够到达最后一个下标，如果可以，返回 true ；否则，返回 false 。

     示例 1：

     输入：nums = [2,3,1,1,4]
     输出：true
     解释：可以先跳 1 步，从下标 0 到达下标 1, 然后再从下标 1 跳 3 步到达最后一个下标。
     示例 2：

     输入：nums = [3,2,1,0,4]
     输出：false
     解释：无论怎样，总会到达下标为 3 的位置。但该下标的最大跳跃长度是 0 ， 所以永远不可能到达最后一个下标。
     */
    
    func canJump(_ nums: [Int]) -> Bool {
        var maxReach = 0
        for index in 0 ..< nums.count {
            if index > maxReach {
                return false
            }
            maxReach = max(maxReach, index + nums[index])
            if maxReach >= nums.count - 1 {
                return true
            }
        }
        return true
    }

}

var nums = [2,4,1]

print(Solution().maxProfit(nums))

