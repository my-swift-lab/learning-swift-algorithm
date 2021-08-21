#!/usr/bin/env swift

import Foundation

let ls = Process()
ls.executableURL = URL(fileURLWithPath: "/usr/bin/env")
ls.arguments = ["ls", "-al"]

do {
  try ls.run()
} catch {
  print(error.localizedDescription)
}