All about subnetting
cidrsubnet("10.0.0.0/16", 8, netnum)
```

**Parameters:**
- Starting CIDR: `10.0.0.0/16`
- newbits: `8` (adds 8 bits to subnet mask)
- netnum: `0, 1, 2, 3...` (which subnet number)

## Bit Layout After Adding 8 Bits
```
Original /16: 10.0.0.0/16
Add 8 bits: /16 + 8 = /24

32 bits broken down:
[Network: 16 bits][Subnet: 8 bits][Host: 8 bits]

In decimal octets:
[  10  .   0  ][  S  ][  H  ]
└─Fixed (16)──┘└─8bit┘└─8bit┘
```

## How netnum Maps to the Third Octet

The 8 subnet bits become the **third octet** in `10.0.X.0`:
```
Binary breakdown:

10.0.0.0/16 original:
00001010.00000000 . SSSSSSSS . HHHHHHHH
└─Network (16)───┘ └─Sub(8)┘ └─Host(8)┘
    10.0           .    X    .    Y

The netnum value directly fills those 8 subnet bits (third octet)
```

## Calculating Each Subnet

### netnum = 0
```
Subnet bits = 00000000 (binary) = 0 (decimal)

Result: 10.0.[0].0/24

Full calculation:
- First octet: 10 (fixed)
- Second octet: 0 (fixed)
- Third octet: 0 (from netnum=0)
- Fourth octet: 0-255 (host range)

Answer: 10.0.0.0/24
IP range: 10.0.0.0 - 10.0.0.255
```

### netnum = 1
```
Subnet bits = 00000001 (binary) = 1 (decimal)

Result: 10.0.[1].0/24

Full calculation:
- First octet: 10 (fixed)
- Second octet: 0 (fixed)
- Third octet: 1 (from netnum=1)
- Fourth octet: 0-255 (host range)

Answer: 10.0.1.0/24
IP range: 10.0.1.0 - 10.0.1.255
```

### netnum = 2
```
Subnet bits = 00000010 (binary) = 2 (decimal)

Result: 10.0.[2].0/24

Answer: 10.0.2.0/24
IP range: 10.0.2.0 - 10.0.2.255
```

### netnum = 255 (maximum for 8 bits)
```
Subnet bits = 11111111 (binary) = 255 (decimal)

Result: 10.0.[255].0/24

Answer: 10.0.255.0/24
IP range: 10.0.255.0 - 10.0.255.255
```

## The Pattern
```
cidrsubnet("10.0.0.0/16", 8, netnum) = "10.0.[netnum].0/24"

netnum directly becomes the third octet because:
- We started with /16 (first 2 octets fixed: 10.0)
- We added 8 bits (exactly 1 octet for subnetting)
- Those 8 bits land in the third octet position
```

## All Possible Subnets
```
netnum 0:   10.0.0.0/24
netnum 1:   10.0.1.0/24
netnum 2:   10.0.2.0/24
netnum 3:   10.0.3.0/24
...
netnum 254: 10.0.254.0/24
netnum 255: 10.0.255.0/24

Total: 2^8 = 256 possible subnets ✓
```

## Why It's So Clean

Because 8 bits = exactly 1 octet, the subnet numbering maps perfectly to the third octet:
```
IP Address Structure:
Octet 1 . Octet 2 . Octet 3 . Octet 4
  8bits    8bits     8bits     8bits  = 32 bits total

With /16 + 8:
[Fixed:10].[Fixed:0].[Subnet:netnum].[Hosts:0-255]
```

## Compare with newbits = 10 (Not So Clean)
```
cidrsubnet("10.0.0.0/16", 10, 0) = "10.0.0.0/26"
cidrsubnet("10.0.0.0/16", 10, 1) = "10.0.0.64/26"
cidrsubnet("10.0.0.0/16", 10, 2) = "10.0.0.128/26"

Here netnum doesn't map cleanly to an octet because 10 bits 
spans across octets 3 and 4
```

## The Formula (General Case)
```
Starting IP address in decimal = Base IP + (netnum × subnet_size)

Where:
subnet_size = 2^(32 - final_mask) = 2^(host_bits)

For /24: subnet_size = 2^(32-24) = 2^8 = 256

netnum 0: 10.0.0.0 + (0 × 256) = 10.0.0.0
netnum 1: 10.0.0.0 + (1 × 256) = 10.0.1.0
netnum 2: 10.0.0.0 + (2 × 256) = 10.0.2.0


//////////////////////////////////////////////////////////
Think of it like slicing a pizza:
VPC = 10.0.0.0/16 (one big pizza with 65,536 IPs)
With newbits = 4 → /20 subnets
/16 + 4 = /20

Subnet mask /20 means:
- 32 - 20 = 12 bits for hosts
- 2^12 = 4,096 IPs per subnet
- You can only make 2^4 = 16 subnets total (big slices)

Result: FEW big slices (16 subnets × 4,096 IPs each)
With newbits = 8 → /24 subnets
/16 + 8 = /24

Subnet mask /24 means:
- 32 - 24 = 8 bits for hosts
- 2^8 = 256 IPs per subnet
- You can make 2^8 = 256 subnets total (medium slices)

Result: MORE medium slices (256 subnets × 256 IPs each)
With newbits = 10 → /26 subnets
/16 + 10 = /26

Subnet mask /26 means:
- 32 - 26 = 6 bits for hosts
- 2^6 = 64 IPs per subnet
- You can make 2^10 = 1,024 subnets total (tiny slices)

Result: MANY tiny slices (1,024 subnets × 64 IPs each)