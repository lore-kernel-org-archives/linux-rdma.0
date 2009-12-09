From: David Miller <davem@davemloft.net>
Subject: Re: Sun V880 + Infiniband?
Date: Wed, 09 Dec 2009 01:39:55 -0800 (PST)
Message-ID: <20091209.013955.262196704.davem@davemloft.net>
References: <adaocmhuupk.fsf@roland-alpha.cisco.com>
	<20091202.144255.137848873.davem@davemloft.net>
	<200912030144.18971.pat@computer-refuge.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <200912030144.18971.pat@computer-refuge.org>
Sender: sparclinux-owner@vger.kernel.org
To: pat@computer-refuge.org
Cc: rdreier@cisco.com, sparclinux@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Patrick Finnegan <pat@computer-refuge.org>
Date: Thu, 3 Dec 2009 01:44:18 -0500

> On Wednesday 02 December 2009, David Miller wrote:
>> If there's something Linux isn't doing right, those dumps will help
>> me spot it.
> 
> Thanks again!

Please give this patch a try:

sparc64: Fix overly strict range type matching for PCI devices.

When we are trying to see if a range property entry applies
to a given address, we are overly strict about the type.

We should only allow I/O ranges for I/O addresses, and only allow
CONFIG space ranges for CONFIG space address.

However for MEM ranges, they come in 32-bit and 64-bit flavors.
And a lack of an exact match is OK if the range is 32-bit and
the address is 64-bit.  We can assign a 64-bit address properly
into a 32-bit parent range just fine.

So allow it.

Reported-by: Patrick Finnegan <pat@computer-refuge.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/of_device_64.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index 881947e..0a6f2d1 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -104,9 +104,19 @@ static int of_bus_pci_map(u32 *addr, const u32 *range,
 	int i;
 
 	/* Check address type match */
-	if ((addr[0] ^ range[0]) & 0x03000000)
-		return -EINVAL;
+	if (!((addr[0] ^ range[0]) & 0x03000000))
+		goto type_match;
+
+	/* Special exception, we can map a 64-bit address into
+	 * a 32-bit range.
+	 */
+	if ((addr[0] & 0x03000000) == 0x03000000 &&
+	    (range[0] & 0x03000000) == 0x02000000)
+		goto type_match;
+
+	return -EINVAL;
 
+type_match:
 	if (of_out_of_range(addr + 1, range + 1, range + na + pna,
 			    na - 1, ns))
 		return -EINVAL;
-- 
1.6.5

