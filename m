From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v1 1/1] RDMA/nes: replace custom print_hex_dump()
Date: Fri,  6 May 2016 20:19:42 +0300
Message-ID: <1462555182-49917-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is no need to duplicate a lot of code that is in the kernel library for ages.
Replace duplicating code by calling to print_hex_dump() directly.

Note that output is slightly changed:
- hex and ascii parts have just two spaces delimeter
- there is no delimeter for ascii portions
- file and line removed from prefix (they were redundant anyway since previous
  output shows same closer enough)

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_utils.c | 60 ++---------------------------------
 1 file changed, 3 insertions(+), 57 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index 6d3a169..37331e2 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -44,6 +44,7 @@
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -903,70 +904,15 @@ void nes_clc(unsigned long parm)
  */
 void nes_dump_mem(unsigned int dump_debug_level, void *addr, int length)
 {
-	char  xlate[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
-		'a', 'b', 'c', 'd', 'e', 'f'};
-	char  *ptr;
-	char  hex_buf[80];
-	char  ascii_buf[20];
-	int   num_char;
-	int   num_ascii;
-	int   num_hex;
-
 	if (!(nes_debug_level & dump_debug_level)) {
 		return;
 	}
 
-	ptr = addr;
 	if (length > 0x100) {
 		nes_debug(dump_debug_level, "Length truncated from %x to %x\n", length, 0x100);
 		length = 0x100;
 	}
-	nes_debug(dump_debug_level, "Address=0x%p, length=0x%x (%d)\n", ptr, length, length);
-
-	memset(ascii_buf, 0, 20);
-	memset(hex_buf, 0, 80);
-
-	num_ascii = 0;
-	num_hex = 0;
-	for (num_char = 0; num_char < length; num_char++) {
-		if (num_ascii == 8) {
-			ascii_buf[num_ascii++] = ' ';
-			hex_buf[num_hex++] = '-';
-			hex_buf[num_hex++] = ' ';
-		}
-
-		if (*ptr < 0x20 || *ptr > 0x7e)
-			ascii_buf[num_ascii++] = '.';
-		else
-			ascii_buf[num_ascii++] = *ptr;
-		hex_buf[num_hex++] = xlate[((*ptr & 0xf0) >> 4)];
-		hex_buf[num_hex++] = xlate[*ptr & 0x0f];
-		hex_buf[num_hex++] = ' ';
-		ptr++;
-
-		if (num_ascii >= 17) {
-			/* output line and reset */
-			nes_debug(dump_debug_level, "   %s |  %s\n", hex_buf, ascii_buf);
-			memset(ascii_buf, 0, 20);
-			memset(hex_buf, 0, 80);
-			num_ascii = 0;
-			num_hex = 0;
-		}
-	}
+	nes_debug(dump_debug_level, "Address=0x%p, length=0x%x (%d)\n", addr, length, length);
 
-	/* output the rest */
-	if (num_ascii) {
-		while (num_ascii < 17) {
-			if (num_ascii == 8) {
-				hex_buf[num_hex++] = ' ';
-				hex_buf[num_hex++] = ' ';
-			}
-			hex_buf[num_hex++] = ' ';
-			hex_buf[num_hex++] = ' ';
-			hex_buf[num_hex++] = ' ';
-			num_ascii++;
-		}
-
-		nes_debug(dump_debug_level, "   %s |  %s\n", hex_buf, ascii_buf);
-	}
+	print_hex_dump(KERN_ERR, PFX, DUMP_PREFIX_NONE, 16, 1, addr, length, true);
 }
-- 
2.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
