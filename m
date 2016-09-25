From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] IB/hfi1: Change EPROM read for internal use
Date: Sun, 25 Sep 2016 07:49:36 -0700
Message-ID: <20160925144934.13602.76268.stgit@scvm10.sc.intel.com>
References: <20160925144724.13602.38549.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925144724.13602.38549.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change the EPROM read to save to a buffer and allow any offset.
Remove missed includes and left over declarations.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/eprom.c    |   78 ++++++++++++++++++++++++++-------
 drivers/infiniband/hw/hfi1/eprom.h    |    2 -
 drivers/infiniband/hw/hfi1/file_ops.c |    1 
 3 files changed, 61 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/eprom.c b/drivers/infiniband/hw/hfi1/eprom.c
index 5a11bee..30ecd94 100644
--- a/drivers/infiniband/hw/hfi1/eprom.c
+++ b/drivers/infiniband/hw/hfi1/eprom.c
@@ -62,7 +62,8 @@
 
 /* controller page size, in bytes */
 #define EP_PAGE_SIZE 256
-#define EEP_PAGE_MASK (EP_PAGE_SIZE - 1)
+#define EP_PAGE_MASK (EP_PAGE_SIZE - 1)
+#define EP_PAGE_DWORDS (EP_PAGE_SIZE / sizeof(u32))
 
 /* controller commands */
 #define CMD_SHIFT 24
@@ -89,35 +90,78 @@ static void read_page(struct hfi1_devdata *dd, u32 offset, u32 *result)
 	int i;
 
 	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_READ_DATA(offset));
-	for (i = 0; i < EP_PAGE_SIZE / sizeof(u32); i++)
+	for (i = 0; i < EP_PAGE_DWORDS; i++)
 		result[i] = (u32)read_csr(dd, ASIC_EEP_DATA);
 	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_NOP); /* close open page */
 }
 
 /*
- * Read length bytes starting at offset.  Copy to user address addr.
+ * Read length bytes starting at offset from the start of the EPROM.
  */
-static int read_length(struct hfi1_devdata *dd, u32 start, u32 len, u64 addr)
+static int read_length(struct hfi1_devdata *dd, u32 start, u32 len, void *dest)
 {
-	u32 offset;
-	u32 buffer[EP_PAGE_SIZE / sizeof(u32)];
-	int ret = 0;
+	u32 buffer[EP_PAGE_DWORDS];
+	u32 end;
+	u32 start_offset;
+	u32 read_start;
+	u32 bytes;
+
+	if (len == 0)
+		return 0;
 
-	/* reject anything not on an EPROM page boundary */
-	if ((start & EEP_PAGE_MASK) || (len & EEP_PAGE_MASK))
+	end = start + len;
+
+	/*
+	 * Make sure the read range is not outside of the controller read
+	 * command address range.  Note that '>' is correct below - the end
+	 * of the range is OK if it stops at the limit, but no higher.
+	 */
+	if (end > (1 << CMD_SHIFT))
 		return -EINVAL;
 
-	for (offset = 0; offset < len; offset += EP_PAGE_SIZE) {
-		read_page(dd, start + offset, buffer);
-		if (copy_to_user((void __user *)(addr + offset),
-				 buffer, EP_PAGE_SIZE)) {
-			ret = -EFAULT;
-			goto done;
+	/* read the first partial page */
+	start_offset = start & EP_PAGE_MASK;
+	if (start_offset) {
+		/* partial starting page */
+
+		/* align and read the page that contains the start */
+		read_start = start & ~EP_PAGE_MASK;
+		read_page(dd, read_start, buffer);
+
+		/* the rest of the page is available data */
+		bytes = EP_PAGE_SIZE - start_offset;
+
+		if (len <= bytes) {
+			/* end is within this page */
+			memcpy(dest, (u8 *)buffer + start_offset, len);
+			return 0;
 		}
+
+		memcpy(dest, (u8 *)buffer + start_offset, bytes);
+
+		start += bytes;
+		len -= bytes;
+		dest += bytes;
 	}
+	/* start is now page aligned */
 
-done:
-	return ret;
+	/* read whole pages */
+	while (len >= EP_PAGE_SIZE) {
+		read_page(dd, start, buffer);
+		memcpy(dest, buffer, EP_PAGE_SIZE);
+
+		start += EP_PAGE_SIZE;
+		len -= EP_PAGE_SIZE;
+		dest += EP_PAGE_SIZE;
+	}
+
+	/* read the last partial page */
+	if (len) {
+		read_page(dd, start, buffer);
+		memcpy(dest, buffer, len);
+	}
+
+	return 0;
 }
 
 /*
diff --git a/drivers/infiniband/hw/hfi1/eprom.h b/drivers/infiniband/hw/hfi1/eprom.h
index d41f0b1..b7ac9ce 100644
--- a/drivers/infiniband/hw/hfi1/eprom.h
+++ b/drivers/infiniband/hw/hfi1/eprom.h
@@ -45,8 +45,6 @@
  *
  */
 
-struct hfi1_cmd;
 struct hfi1_devdata;
 
 int eprom_init(struct hfi1_devdata *dd);
-int handle_eprom_command(struct file *fp, const struct hfi1_cmd *cmd);
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 13bb6a5..677efa0 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -58,7 +58,6 @@
 #include "trace.h"
 #include "user_sdma.h"
 #include "user_exp_rcv.h"
-#include "eprom.h"
 #include "aspm.h"
 #include "mmu_rb.h"
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
