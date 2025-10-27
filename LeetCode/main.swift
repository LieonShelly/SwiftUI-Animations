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
}

var nums = [2,2,1,1,1,2,2]

print(Solution().majorityElement(nums))
