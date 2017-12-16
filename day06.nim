import strutils
import sequtils
import tables
import math

proc get_input(): string =
  var f: File
  if open(f, "data/day6.txt"):
    try:
      return readLine(f)
    finally:
      close(f)

proc parse_input(a: string): seq[int] =
  map(splitWhitespace(a), proc(x: string): int = parseInt(x))

proc get_max_index(b: seq[int]): int =
  var max_value = 0
  var max_index = 0
  var cur_index = 0
  while cur_index < len(b):
    if b[cur_index] > max_value:
      max_index = cur_index
      max_value = b[cur_index]
    cur_index = cur_index + 1
  max_index

proc update_banks(b: var seq[int]): seq[int] =
  let redistribute_index = get_max_index(b)
  var redistribute_value = b[redistribute_index]
  let L = len(b)
  let add_per = (ceil(float32(redistribute_value) / float32(L))).int32

  b[redistribute_index] = 0
  var new_index = (redistribute_index + 1) mod L
  while new_index != redistribute_index:
    if add_per < redistribute_value:
      b[new_index] = b[new_index] + add_per
      redistribute_value = redistribute_value - add_per
    else:
      b[new_index] = b[new_index] + redistribute_value
      redistribute_value = 0
    new_index = (new_index + 1) mod L
  if redistribute_value > 0:
    b[new_index] = b[new_index] + redistribute_value
  b

let a = get_input()
var b = parse_input(a)

var h = initTable[seq[int], bool]()
var step = 0
while not hasKey(h, b):
  h[b] = true
  b = update_banks(b)
  step = step + 1

echo "final steps, part a: " & intToStr(step)

let c = b

step = 0

while step == 0 or b != c:
  b = update_banks(b)
  step += 1

echo "final steps, part b: " & intToStr(step)
