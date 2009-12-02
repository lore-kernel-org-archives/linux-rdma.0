From: Patrick Finnegan <pat@computer-refuge.org>
Subject: Sun V880 + Infiniband?
Date: Wed, 2 Dec 2009 10:45:02 -0500
Message-ID: <200912021045.02970.pat@computer-refuge.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: sparclinux@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

So, I'm trying to get a Mellanox IB card to work on my Sun V880, and I'm 
getting this error output to dmesg: 

[   99.529658] ib_mthca: Mellanox InfiniBand HCA driver v1.0 (April 4, 
2008)
[   99.609988] ib_mthca: Initializing 0003:01:00.0
[   99.664180] PCI: Enabling device: (0003:01:00.0), cmd 2
[   99.664193] ib_mthca 0003:01:00.0: Missing DCS, aborting.

I'm using a kernel compiled off of Linus's git tree as of a few days ago 
(to fix other SPARC issues).  From what I've seen from google searches, 
this means that the first BAR isn't mapped or visible to the driver, so 
maybe this is a SPARC related thing?

lspci -v output for the device:

0003:00:01.0 PCI bridge: Mellanox Technologies MT23108 PCI Bridge (rev 
a1) (prog-if 00 [Normal decode])
        Flags: bus master, 66MHz, slow devsel, latency 64
        [virtual] Memory at fffff80500000000 (32-bit, non-prefetchable) 
[size=1]
        [virtual] Memory at fffff80500000000 (32-bit, non-prefetchable) 
[size=1]
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        Memory behind bridge: 00100000-0fffffff
        [virtual] Expansion ROM at fffff80500000000 [disabled] [size=1]
        Capabilities: [70] PCI-X bridge device

0003:01:00.0 InfiniBand: Mellanox Technologies MT23108 InfiniHost (rev 
a1)
        Subsystem: Mellanox Technologies MT23108 InfiniHost
        Flags: 66MHz, slow devsel, IRQ 30
        Memory at fffff80500000000 (64-bit, non-prefetchable) [size=1]
        Memory at fffff80500000000 (64-bit, prefetchable) [size=1]
        Memory at fffff80500000000 (64-bit, prefetchable) [size=1]
        [virtual] Expansion ROM at fffff80500000000 [disabled] [size=1]
        Capabilities: [40] MSI-X: Enable- Mask- TabSize=32
        Capabilities: [50] Vital Product Data <?>
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/5 Enable-
        Capabilities: [70] PCI-X non-bridge device
        Kernel modules: ib_mthca


Pat
-- 
Purdue University Research Computing ---  http://www.rcac.purdue.edu/
The Computer Refuge                  ---  http://computer-refuge.org
